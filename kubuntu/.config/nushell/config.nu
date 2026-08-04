$env.config.show_banner = false
$env.config.buffer_editor = "hx"
const proxy_port = 22727

# 配置当前会话本地代理环境变量。协议可选socks5h（默认）、socks5、http、https。传入off可清除代理环境变量
def --env proxy [
	scheme: string = "socks5h" # 代理协议或off
]: nothing -> nothing {
	match $scheme {
		"off" => {
			for name in [
				HTTP_PROXY
				HTTPS_PROXY
				ALL_PROXY
				http_proxy
				https_proxy
				all_proxy
			] {
				if $name in ($env | columns) {
					hide-env $name
				}
			}

			print "Proxy Disabled"
		}
		"socks5h" | "socks5" | "http" | "https" => {
			let proxy_url = $"($scheme)://127.0.0.1:($proxy_port)"

			$env.HTTP_PROXY = $proxy_url
			$env.HTTPS_PROXY = $proxy_url
			$env.ALL_PROXY = $proxy_url
			$env.http_proxy = $proxy_url
			$env.https_proxy = $proxy_url
			$env.all_proxy = $proxy_url

			print $"Proxy Enabled -> ($proxy_url)"
		}
		_ => {
			error make { msg: $"Invalid proxy mode '($scheme)'; expected socks5h, socks5, http, https, or off" }
		}
	}
}

# cd to "~/Desktop/temp/". `--clear` or `-c` to also empty it.
def --env temp [
	--clear (-c) # Delete and recreate the temporary directory before entering it.
]: nothing -> nothing {
	let temp_dir = ("~/Desktop/temp" | path expand)

	mkdir $temp_dir
	cd $temp_dir

	if $clear {
		let pattern = ($"($temp_dir)/*" | str replace --all "\\" "/")
		let entries = (glob $pattern)
		if ($entries | is-not-empty) {
			rm --recursive --force ...$entries
		}
	}
}

proxy
