$ErrorActionPreference = "Stop"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter 未安装或不在 PATH，请先安装 Flutter SDK。"
}

flutter create . --platforms=android,ios
flutter pub get

Write-Host "Flutter 项目平台工程已生成。"
