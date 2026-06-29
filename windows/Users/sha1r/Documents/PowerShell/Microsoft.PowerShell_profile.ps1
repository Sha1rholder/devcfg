function powershell
{
	pwsh @args
}

function v2
{
	$proxy = "socks5h://127.0.0.1:22727"
	$env:HTTP_PROXY = $proxy
	$env:HTTPS_PROXY = $proxy
	$env:ALL_PROXY = $proxy
	$env:http_proxy = $proxy
	$env:https_proxy = $proxy
	$env:all_proxy = $proxy
	$env:NO_PROXY = "localhost,127.0.0.1,::1"
	Write-Host "Proxy Enabled -> $proxy" -ForegroundColor Green
}
function v2h
{
	$proxy = "http://127.0.0.1:22727"
	$env:HTTP_PROXY = $proxy
	$env:HTTPS_PROXY = $proxy
	$env:ALL_PROXY = $proxy
	$env:http_proxy = $proxy
	$env:https_proxy = $proxy
	$env:all_proxy = $proxy
	$env:NO_PROXY = "localhost,127.0.0.1,::1"
	Write-Host "Proxy Enabled -> $proxy" -ForegroundColor Green
}
function v2off
{
	Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
	Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
	Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue
	Remove-Item Env:http_proxy -ErrorAction SilentlyContinue
	Remove-Item Env:https_proxy -ErrorAction SilentlyContinue
	Remove-Item Env:all_proxy -ErrorAction SilentlyContinue
	Remove-Item Env:NO_PROXY -ErrorAction SilentlyContinue
	Write-Host "Proxy Disabled" -ForegroundColor Yellow
}
