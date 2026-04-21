param(
  [string]$Python = "python"
)

$scriptPath = Join-Path $PSScriptRoot "l10n_lint.py"
& $Python $scriptPath @args
exit $LASTEXITCODE
