$prefix = "http" + "://127.0.0.1:8080/"
$H = New-Object System.Net.HttpListener
$H.Prefixes.Add($prefix)
$H.Start()
Write-Host ("Server Running at " + $prefix + " (Keep open)") -ForegroundColor Green

while ($H.IsListening) {
    $C = $H.GetContext()
    $reqPath = $C.Request.Url.AbsolutePath.TrimStart("/")
    if ([string]::IsNullOrWhiteSpace($reqPath)) { $reqPath = "index.html" }
    $P = Join-Path (Get-Location) $reqPath
    if (Test-Path $P -PathType Container) { $P = Join-Path $P "index.html" }
    if (Test-Path $P) {
        $B = [IO.File]::ReadAllBytes($P)
        if ($P -like "*.html") { $C.Response.ContentType = "text/html; charset=utf-8" }
        elseif ($P -like "*.png") { $C.Response.ContentType = "image/png" }
        else { $C.Response.ContentType = "application/octet-stream" }
        $C.Response.OutputStream.Write($B, 0, $B.Length)
    } else {
        $C.Response.StatusCode = 404
    }
    $C.Response.Close()
}