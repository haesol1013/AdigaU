import requests, json

# 요청을 보낼 URL
url = "https://port-0-aadigauu-1272llwnq4inr.sel5.cloudtype.app/zzim/20"


data = {"isLiked": "True"}

response = requests.put(url, data = data)

# 응답 받기
print(response.text)
