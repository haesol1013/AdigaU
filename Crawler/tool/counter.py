import json
import res.info as info

if __name__ == "__main__":
    with open(info.raw_data_path, "r", encoding="utf-8") as json_file:
        raw_data = json.load(json_file)
        print(f"length of raw_data: {len(raw_data)}")

    with open(info.processed_data_path, "r", encoding="utf-8") as json_file:
        raw_data = json.load(json_file)
        print(f"length of processed_data: {len(raw_data)}")
