$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $PSScriptRoot
$output = Join-Path $root 'dist\store-artwork'
New-Item -ItemType Directory -Force -Path $output | Out-Null
$green = [System.Drawing.Color]::FromArgb(89,255,155)
# Resize the supplied master for packaging; do not redraw or crop its artwork.
function Draw-RyserMark($graphics, [single]$x, [single]$y, [single]$size) {
    $logo = [System.Drawing.Image]::FromFile((Join-Path $root 'assets\branding\ryser-logo.png'))
    try {
        if ($logo.Width -ne $logo.Height) { throw 'The master logo must be square.' }
        $graphics.InterpolationMode = 'HighQualityBicubic'
        $graphics.PixelOffsetMode = 'HighQuality'
        $graphics.DrawImage($logo, $x, $y, $size, $size)
    } finally {
        $logo.Dispose()
    }
}
# The original green R is reserved for launcher/store app icons.
function Draw-AppIcon($graphics, [single]$size) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $points = @(@(32,28),@(61,28),@(77,44),@(77,56),@(64,68),@(78,82),@(61,82),@(47,67),@(44,67),@(44,82),@(32,82))
    [System.Drawing.PointF[]]$polygon = $points | ForEach-Object { [System.Drawing.PointF]::new($_[0]*$size/108, $_[1]*$size/108) }
    $path.AddPolygon($polygon)
    [System.Drawing.PointF[]]$hole = @(@(44,40),@(44,55),@(58,55),@(64,49),@(64,46),@(58,40)) | ForEach-Object { [System.Drawing.PointF]::new($_[0]*$size/108, $_[1]*$size/108) }
    $path.AddPolygon($hole)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(0,255,65))
    try { $graphics.FillPath($brush,$path) }
    finally { $brush.Dispose(); $path.Dispose() }
}
function Write-Icon([string]$path,[int]$size) {
    $bitmap = [System.Drawing.Bitmap]::new($size,$size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = 'AntiAlias'
    $graphics.Clear([System.Drawing.Color]::Black)
    Draw-AppIcon $graphics $size
    $bitmap.Save($path,[System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose(); $bitmap.Dispose()
}
Write-Icon (Join-Path $output 'ryser-icon-512.png') 512
foreach ($density in @(@('mdpi',48),@('hdpi',72),@('xhdpi',96),@('xxhdpi',144),@('xxxhdpi',192))) {
    Write-Icon (Join-Path $root "android\app\src\main\res\mipmap-$($density[0])\ic_launcher.png") $density[1]
}
$bitmap = [System.Drawing.Bitmap]::new(1024,500)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::Black)
$graphics.SmoothingMode = 'AntiAlias'
Draw-RyserMark $graphics 20 38 420
$brush = New-Object System.Drawing.SolidBrush($green)
$font = New-Object System.Drawing.Font('Consolas',64,[System.Drawing.FontStyle]::Bold)
$small = New-Object System.Drawing.Font('Consolas',21,[System.Drawing.FontStyle]::Regular)
$graphics.DrawString('RYSER',$font,$brush,440,155)
$graphics.DrawString('ADAPTIVE ALARM',$small,$brush,445,265)
$bitmap.Save((Join-Path $output 'ryser-feature-1024x500.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$font.Dispose(); $small.Dispose(); $brush.Dispose(); $graphics.Dispose(); $bitmap.Dispose()
$storeAssets = Join-Path $root 'docs\store\assets'
New-Item -ItemType Directory -Force -Path $storeAssets | Out-Null
foreach ($name in @('ryser-icon-512.png','ryser-feature-1024x500.png')) {
    Copy-Item -LiteralPath (Join-Path $output $name) -Destination (Join-Path $storeAssets $name)
}
Get-ChildItem -LiteralPath $output | Select-Object Name,Length
