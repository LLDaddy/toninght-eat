#!/usr/bin/env python3
"""Gate for hardcoded CJK UI copy in lib/pages."""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Sequence


CJK_RE = re.compile(r"[\u3400-\u4DBF\u4E00-\u9FFF]")
STRING_RE = re.compile(r"'(?:\\.|[^'\\])*'|\"(?:\\.|[^\"\\])*\"")
UI_PROP_RE = re.compile(
    r"\b(title|subtitle|label|tooltip|hint|message|text|content)\b\s*:",
    re.IGNORECASE,
)

UI_CONTEXT_HINTS = [
    "text(",
    "richtext(",
    "snackbar(",
    "appbar(",
    "alertdialog(",
    "cupertinoalertdialog(",
    "showdialog(",
    "showsnackbar(",
    "tab(",
    "bottomnavigationbaritem(",
    "inputdecoration(",
    "dropdownmenuitem(",
    "popupmenuitem(",
    "chip(",
    "filterchip(",
    "choicechip(",
    "actionchip(",
    "tooltip:",
    "labeltext:",
    "hinttext:",
    "helpertext:",
    "errortext:",
    "semanticlabel:",
    "semanticslabel:",
]


@dataclass(frozen=True)
class Violation:
    file: Path
    line: int
    snippet: str


def _contains_cjk(text: str) -> bool:
    return bool(CJK_RE.search(text))


def _ui_context_hit(lines: Sequence[str], index: int) -> bool:
    start = max(0, index - 2)
    end = min(len(lines), index + 3)
    window = "\n".join(lines[start:end]).lower()
    if any(hint in window for hint in UI_CONTEXT_HINTS):
        return True
    return bool(UI_PROP_RE.search(lines[index]))


def _extract_string_value(literal: str) -> str:
    if len(literal) >= 2 and literal[0] == literal[-1] and literal[0] in {"'", '"'}:
        return literal[1:-1]
    return literal


def _scan_file(path: Path) -> Iterable[Violation]:
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except UnicodeDecodeError:
        return []

    violations: List[Violation] = []
    for idx, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("//"):
            continue
        if not _ui_context_hit(lines, idx):
            continue
        for match in STRING_RE.finditer(line):
            literal = match.group(0)
            value = _extract_string_value(literal).strip()
            if not value:
                continue
            if _contains_cjk(value):
                violations.append(Violation(file=path, line=idx + 1, snippet=value))
    return violations


def scan_pages(target_dir: Path) -> List[Violation]:
    if not target_dir.exists():
        raise FileNotFoundError(f"Target path not found: {target_dir}")
    dart_files = sorted(target_dir.rglob("*.dart"))
    violations: List[Violation] = []
    for file_path in dart_files:
        violations.extend(_scan_file(file_path))
    return violations


def _print_violations(violations: Sequence[Violation]) -> None:
    for violation in violations:
        print(f"{violation.file}:{violation.line}:{violation.snippet}")


def run_gate(root: Path, target: str) -> int:
    target_dir = (root / target).resolve()
    try:
        violations = scan_pages(target_dir)
    except FileNotFoundError as exc:
        print(f"FAIL: {exc}")
        return 1

    if violations:
        print(f"FAIL: found {len(violations)} hardcoded CJK UI string(s).")
        _print_violations(violations)
        return 1

    print("PASS: no hardcoded CJK UI strings found in lib/pages.")
    return 0


def run_self_test(fixtures_root: Path) -> int:
    pass_root = (fixtures_root / "pass" / "lib" / "pages").resolve()
    fail_root = (fixtures_root / "fail" / "lib" / "pages").resolve()
    errors: List[str] = []

    try:
        pass_violations = scan_pages(pass_root)
    except FileNotFoundError as exc:
        print(f"[SELF-TEST] FAIL fixture missing: {exc}")
        return 1
    if pass_violations:
        errors.append(
            f"pass fixture should pass but found {len(pass_violations)} violation(s)."
        )
        _print_violations(pass_violations)
    else:
        print("[SELF-TEST] pass fixture: OK")

    try:
        fail_violations = scan_pages(fail_root)
    except FileNotFoundError as exc:
        print(f"[SELF-TEST] FAIL fixture missing: {exc}")
        return 1
    if not fail_violations:
        errors.append("fail fixture should fail but found 0 violations.")
    else:
        print(f"[SELF-TEST] fail fixture: detected {len(fail_violations)} violation(s)")
        _print_violations(fail_violations)

    if errors:
        print("[SELF-TEST] FAILED")
        for error in errors:
            print(f"- {error}")
        return 1

    print("[SELF-TEST] PASSED")
    return 0


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Block hardcoded CJK UI strings in lib/pages/**/*.dart."
    )
    parser.add_argument(
        "--root",
        default=".",
        help="Project root used to resolve target path (default: current directory).",
    )
    parser.add_argument(
        "--target",
        default="lib/pages",
        help="Relative target directory to scan (default: lib/pages).",
    )
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="Run fixture self-tests only.",
    )
    parser.add_argument(
        "--fixtures-root",
        default="scripts/fixtures/pages_l10n_gate",
        help="Fixture root for --self-test.",
    )
    return parser.parse_args(argv)


def main(argv: Sequence[str]) -> int:
    args = parse_args(argv)
    root = Path(args.root).resolve()
    if args.self_test:
        fixtures_root = (root / args.fixtures_root).resolve()
        return run_self_test(fixtures_root)
    return run_gate(root, args.target)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
