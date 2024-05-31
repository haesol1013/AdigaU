import requests
import json

if __name__ == "__main__":
    with open(r"res/processed_data.json", "r", encoding="utf-8") as json_file:
        processed_data = json.load(json_file)
    response = requests.post("https://port-0-aadigauu-1272llwnq4inr.sel5.cloudtype.app/first_data/",
                             json=processed_data)
    print(response.status_code)
