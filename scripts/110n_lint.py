#!/usr/bin/env python3
"""Lint ARB localization files for corruption and high-risk copy length."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Set, Tuple


PLACEHOLDER_RE = re.compile(r"\{([A-Za-z_][A-Za-z0-9_]*)\}")
CJK_RE = re.compile(r"[\u4e00-\u9fff]")

# Corruption markers to block by default.
BANNED_SUBSTRINGS = ("????",)
BANNED_CODEPOINTS = (0x6D60, 0x93B6, 0x935A)  # known mojibake signatures

# Key groups used for length-risk warnings in EN copy.
CTA_EXACT_KEYS: Set[str] = {
    "commonLock",
    "commonRegenerate",
    "commonReplaceThis",
    "commonRetry",
    "loginSendOtp",
    "onboardingAdd",
    "onboardingSave",
    "otpVerifyAndLogin",
    "recipeDetailAddTodayMenuButton",
    "recipeDetailFavoriteButton",
    "tarotDrawTodayMenuButton",
    "tarotRedraw",
    "tarotUseThisMenu",
    "todayDrawTodayMenu",
}

SNACKBAR_EXACT_KEYS: Set[str] = {
    "loginOtpSent",
    "loginSendFailed",
    "onboardingRequiredFieldsIncomplete",
    "onboardingSaveFailed",
    "onboardingSaveSuccess",
    "onboardingSessionExpired",
    "otpLoginSuccess",
    "otpVerifyFailed",
    "startupMissingEnv",
    "startupMissingSupabaseKeys",
    "tarotDrawFailed",
    "todayLockedCannotReplace",
    "todayLogoutFailed",
    "todayMenuGenerateFailed",
    "todayNoReplacementCandidates",
    "todayPreviewCannotLogout",
    "todayReplaceFailed",
    "todayReplacedOneDish",
}


@dataclass(frozen=True)
class Issue:
    severity: str
    rule: str
    file: str
    key: str
    message: str


def _project_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _default_en() -> Path:
    return _project_root() / "lib" / "l10n" / "app_en.arb"


def _default_zh() -> Path:
    return _project_root() / "lib" / "l10n" / "app_zh.arb"


def _load_arb(path: Path) -> Dict[str, object]:
    text = path.read_text(encoding="utf-8")
    payload = json.loads(text)
    if not isinstance(payload, dict):
        raise ValueError("ARB root must be a JSON object")
    return payload


def _iter_string_entries(payload: Dict[str, object]) -> Iterable[Tuple[str, str]]:
    for key, value in payload.items():
        if key == "@@locale" or key.startswith("@"):
            continue
        if isinstance(value, str):
            yield key, value


def _extract_placeholders(text: str) -> Set[str]:
    return set(PLACEHOLDER_RE.findall(text))


def _is_title_key(key: str) -> bool:
    key_lower = key.lower()
    return key_lower.endswith("title") or key == "appTitle"


def _is_cta_key(key: str) -> bool:
    return key in CTA_EXACT_KEYS or key.lower().endswith("button")


def _is_snackbar_key(key: str) -> bool:
    if key in SNACKBAR_EXACT_KEYS:
        return True
    return key.endswith("Failed") or key.endswith("Success")


def _find_first_banned_codepoint(text: str) -> int | None:
    for cp in BANNED_CODEPOINTS:
        if chr(cp) in text:
            return cp
    return None


def _lint(
    en_path: Path,
    zh_path: Path,
    cta_max: int,
    title_max: int,
    snackbar_max: int,
) -> Tuple[List[Issue], List[Issue]]:
    errors: List[Issue] = []
    warnings: List[Issue] = []

    try:
        en_payload = _load_arb(en_path)
    except Exception as exc:  # noqa: BLE001 - explicit lint failure
        errors.append(Issue("error", "json", str(en_path), "-", f"Failed to load: {exc}"))
        return errors, warnings

    try:
        zh_payload = _load_arb(zh_path)
    except Exception as exc:  # noqa: BLE001 - explicit lint failure
        errors.append(Issue("error", "json", str(zh_path), "-", f"Failed to load: {exc}"))
        return errors, warnings

    en_strings = dict(_iter_string_entries(en_payload))
    zh_strings = dict(_iter_string_entries(zh_payload))

    # Corruption symbols + known mojibake signatures in both locales.
    for path, entries in ((en_path, en_strings), (zh_path, zh_strings)):
        for key, value in entries.items():
            for marker in BANNED_SUBSTRINGS:
                if marker and marker in value:
                    errors.append(
                        Issue(
                            "error",
                            "pollution-symbol",
                            str(path),
                            key,
                            f"Found banned marker '{marker}'.",
                        )
                    )
            cp = _find_first_banned_codepoint(value)
            if cp is not None:
                errors.append(
                    Issue(
                        "error",
                        "pollution-mojibake",
                        str(path),
                        key,
                        f"Found banned codepoint U+{cp:04X}.",
                    )
                )

    # EN copy should not contain Chinese Han characters.
    for key, value in en_strings.items():
        if CJK_RE.search(value):
            errors.append(
                Issue(
                    "error",
                    "en-cjk",
                    str(en_path),
                    key,
                    "English copy contains Chinese characters.",
                )
            )

    # Key set + placeholder parity between zh/en.
    en_keys = set(en_strings.keys())
    zh_keys = set(zh_strings.keys())
    for key in sorted(en_keys - zh_keys):
        errors.append(
            Issue("error", "missing-zh-key", str(zh_path), key, "Missing key in zh ARB.")
        )
    for key in sorted(zh_keys - en_keys):
        errors.append(
            Issue("error", "missing-en-key", str(en_path), key, "Missing key in en ARB.")
        )

    for key in sorted(en_keys & zh_keys):
        en_ph = _extract_placeholders(en_strings[key])
        zh_ph = _extract_placeholders(zh_strings[key])
        if en_ph != zh_ph:
            errors.append(
                Issue(
                    "error",
                    "placeholder-mismatch",
                    str(en_path),
                    key,
                    f"EN placeholders {sorted(en_ph)} != ZH placeholders {sorted(zh_ph)}.",
                )
            )

    # EN length risk warnings.
    for key, value in en_strings.items():
        text_len = len(value)
        if _is_cta_key(key) and text_len > cta_max:
            warnings.append(
                Issue(
                    "warning",
                    "length-cta",
                    str(en_path),
                    key,
                    f"Length {text_len} > CTA max {cta_max}.",
                )
            )
        if _is_title_key(key) and text_len > title_max:
            warnings.append(
                Issue(
                    "warning",
                    "length-title",
                    str(en_path),
                    key,
                    f"Length {text_len} > title max {title_max}.",
                )
            )
        if _is_snackbar_key(key) and text_len > snackbar_max:
            warnings.append(
                Issue(
                    "warning",
                    "length-snackbar",
                    str(en_path),
                    key,
                    f"Length {text_len} > snackbar max {snackbar_max}.",
                )
            )

    return errors, warnings


def _build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Lint ARB files for corruption markers, placeholder parity, and EN copy length risks."
    )
    parser.add_argument("--en", type=Path, default=_default_en(), help="Path to app_en.arb")
    parser.add_argument("--zh", type=Path, default=_default_zh(), help="Path to app_zh.arb")
    parser.add_argument("--cta-max", type=int, default=18, help="CTA max length in EN")
    parser.add_argument("--title-max", type=int, default=28, help="Title max length in EN")
    parser.add_argument(
        "--snackbar-max", type=int, default=72, help="Snackbar-like max length in EN"
    )
    return parser


def main() -> int:
    args = _build_arg_parser().parse_args()

    errors, warnings = _lint(
        en_path=args.en,
        zh_path=args.zh,
        cta_max=args.cta_max,
        title_max=args.title_max,
        snackbar_max=args.snackbar_max,
    )

    for issue in errors + warnings:
        print(
            f"[{issue.severity.upper()}] {issue.rule} | {issue.file}:{issue.key} | {issue.message}"
        )

    print(f"summary: error={len(errors)} warning={len(warnings)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
