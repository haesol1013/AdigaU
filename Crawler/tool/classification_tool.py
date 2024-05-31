import json
import res.info as info




def get_category(tags: list[str]) -> str:
    tags = str(tags)
    category = None
    if "카페" in tags:
        category = "cafes"
    elif "술집" in tags:
        category = "pubs"
    elif "맛집" in tags:
        category = "restaurants"
    return category


def split_tag(tags: list[str]) -> list[str]:
    result = []
    for tag in tags:
        if "#" not in tag[1:]:
            result.append(tag)
        else:
            result.extend(map(lambda x: "#" + x, tag[1:].split("#")))
    return result


def is_available(dict_: dict) -> bool:
    result = (dict_["name"] and
              dict_["location"] and
              dict_["time"] and
              dict_["description"] and
              dict_["category"] and
              dict_["name"] not in name_set)
    return result


def get_processed_data() -> None:
    global name_set
    name_set = set()
    processed_data = []

    with open(info.raw_data_path, "r", encoding="utf-8") as json_file:
        raw_data = json.load(json_file)

    for dict_ in raw_data:
        if is_available(dict_):
            processed_data.append(dict_)
            name_set.add(dict_["name"])

    with open(info.processed_data_path, "w", encoding="utf-8") as json_file:
        json.dump(processed_data, json_file, ensure_ascii=False, indent=4)


def change_category():
    with open(info.processed_data_path, "r", encoding="utf-8") as json_file:
        source_data = json.load(json_file)

    for dict_ in source_data:
        tags = dict_["tags"]
        dict_["category"] = get_category(tags)

    with open(info.processed_data_path, "w", encoding="utf-8") as json_file:
        json.dump(source_data, json_file, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    get_processed_data()
