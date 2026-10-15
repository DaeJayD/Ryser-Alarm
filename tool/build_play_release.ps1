param(
    [Parameter(Mandatory=$true)][string]$KeystorePath,
    [string]$KeyAlias = 'ryser-upload',
    [Parameter(Mandatory=$true)][ValidatePattern('^[^\s@]+@[^\s@]+\.[^\s@]+$')][string]$SupportEmail,
    [Parameter(Mandatory=$true)][ValidatePattern('^https://[^\s]+$')][string]$PrivacyUrl
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$resolvedKey = (Resolve-Path -LiteralPath $KeystorePath).Path
if ($resolvedKey.StartsWith($projectRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Keep the upload keystore outside the project directory.'
}
$storeSecret = Read-Host 'Upload keystore password (not saved)' -AsSecureString
$keySecret = Read-Host 'Upload key password (not saved)' -AsSecureString
function Reveal-Secret([Security.SecureString]$value) {
    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($value)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer) }
}
$names = @('RYSER_UPLOAD_STORE_FILE','RYSER_UPLOAD_STORE_PASSWORD',
    'RYSER_UPLOAD_KEY_ALIAS','RYSER_UPLOAD_KEY_PASSWORD','RYSER_TEST_SIGNING','GRADLE_OPTS')
$original = @{}
foreach ($name in $names) { $original[$name] = [Environment]::GetEnvironmentVariable($name,'Process') }
Push-Location $projectRoot
try {
    $env:RYSER_UPLOAD_STORE_FILE = $resolvedKey
    $env:RYSER_UPLOAD_STORE_PASSWORD = Reveal-Secret $storeSecret
    $env:RYSER_UPLOAD_KEY_ALIAS = $KeyAlias
    $env:RYSER_UPLOAD_KEY_PASSWORD = Reveal-Secret $keySecret
    $env:RYSER_TEST_SIGNING = $null
    $env:GRADLE_OPTS = '-Dorg.gradle.daemon=false'
    flutter analyze --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'Static analysis failed.' }
    flutter test --no-pub
    if ($LASTEXITCODE -ne 0) { throw 'Regression tests failed.' }
    flutter build appbundle --release --no-pub "--dart-define=RYSER_SUPPORT_EMAIL=$SupportEmail" "--dart-define=RYSER_PRIVACY_URL=$PrivacyUrl"
    if ($LASTEXITCODE -ne 0) { throw 'Production bundle build failed.' }
    Get-FileHash -LiteralPath (Join-Path $projectRoot 'build\app\outputs\bundle\release\app-release.aab') -Algorithm SHA256 |
        Format-List Algorithm,Hash,Path
    Write-Output 'Bundle built. Verify its signer, 16 KB compatibility, and run the Play internal test before production.'
} finally {
    foreach ($name in $names) { [Environment]::SetEnvironmentVariable($name,$original[$name],'Process') }
    $storeSecret.Dispose()
    $keySecret.Dispose()
    Pop-Location
}
