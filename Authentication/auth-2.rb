require 'http'

url = 'https://0acd00ef035e9d088414365100cd00c4.web-security-academy.net/login'

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0"
	)
		
resp1 = client.post(url,:form=>{:username=>"carlos",:password=>"montoya"})
puts resp1.headers.to_a
cookie = resp1.headers['Set-Cookie']
puts cookie
