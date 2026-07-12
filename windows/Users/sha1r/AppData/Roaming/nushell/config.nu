$env.config.show_banner = false
$env.config.buffer_editor = "hx"

const proxy_port = 22727

# Enable localhost proxy environment variables.
#
# Uses `socks5h` by default. Pass another scheme such as `http` to override it.
def --env v2 [scheme = "socks5h"]: nothing -> nothing {
	let proxy_url = $"($scheme)://127.0.0.1:($proxy_port)"

	$env.HTTP_PROXY = $proxy_url
	$env.HTTPS_PROXY = $proxy_url
	$env.ALL_PROXY = $proxy_url
	$env.http_proxy = $proxy_url
	$env.https_proxy = $proxy_url
	$env.all_proxy = $proxy_url

	print $"Proxy Enabled -> ($proxy_url)"
}

# Disable proxy environment variables set by `v2`.
def --env v2off []: nothing -> nothing {
	for name in [HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy NO_PROXY] {
		if $name in ($env | columns) {
			hide-env $name
		}
	}

	print "Proxy Disabled"
}

v2
