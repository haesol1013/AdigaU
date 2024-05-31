import requests, json

# 요청을 보낼 URL
url = "https://port-0-aadigauu-1272llwnq4inr.sel5.cloudtype.app/first_data/"
file_path = r"/Users/rnoro/Documents/GitHub/AAdigaUU/processed_data.json"

#json 파일 열기
with open(file_path, 'r', encoding="UTF-8") as file:
    #파일 내용 읽기
    json_data = json.load(file)


data = {"isLike": True}


# JSON 데이터를 포함하여 POST 요청 보내기
response = requests.post(url, json=json_data)
#response = requests.put(url, data = data)

# 응답 받기
print(response.text)
