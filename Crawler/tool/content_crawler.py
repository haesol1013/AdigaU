from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import parser
import json
import unicodedata as uni
import time
import re
import numpy as np
import res.info as info


def init() -> None:
    global driver

    # ChromeOptions 설정
    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36")

    # Chrome 실행 및 instagram 접속
    driver = webdriver.Chrome(options=options)
    url = 'https://www.instagram.com'
    driver.get(url)
    driver.implicitly_wait(5)

    # Login
    username_input = WebDriverWait(driver, 2).until(EC.presence_of_element_located((By.NAME, 'username')))
    password_input = driver.find_element(By.NAME, 'password')
    username_input.send_keys(info.insta_id)
    password_input.send_keys(info.insta_pw)
    login_button = driver.find_element(By.XPATH, "//button[@type='submit']")
    login_button.click()
    driver.implicitly_wait(5)


def move_next() -> None:
    right = driver.find_element(By.CSS_SELECTOR, "svg[aria-label='다음']")
    right.click()
    driver.implicitly_wait(2)


def get_content():
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')

    try:
        content = soup.select('div._a9zs')[0].text
        content = uni.normalize('NFC', content)
    except:
        content = None

    try:
        likes = soup.select('.x193iq5w.xeuugli.x1fj9vlw.x13faqbe.x1vvkbs.xt0psk2.x1i0vuye.xvs91rp.x1s688f.x5n08af.x10wh9bi.x1wdrske.x8viiok.x18hxmgj')[0].text
        likes = int(re.findall(r'[\d]+', likes)[0])
    except:
        likes = None

    video = soup.find('video')
    is_video = True if video else False

    return content, is_video, likes


def choose_parser(user_tag: str):
    match user_tag:
        case "daejeon_people":
            return parser.parse_daejeon_people
        case "matdongyeop":
            return parser.parse_matdongyeop


def get_data(user_tag: str) -> tuple[list[dict], list[int]]:
    parsing_func = choose_parser(user_tag)
    total_data = []
    total_likes = []

    driver.get('https://www.instagram.com/' + user_tag + '/')
    first = WebDriverWait(driver, 5).until(EC.element_to_be_clickable((By.CSS_SELECTOR, info.account[user_tag]["first_post"])))
    first.click()
    driver.implicitly_wait(2)

    for _ in range(info.account[user_tag]["valid_posts"]):
        content, is_video, likes = get_content()
        total_data.append(parsing_func(content, is_video, likes))
        total_likes.append(likes)

        move_next()
        time.sleep(0.7)
        # driver.implicitly_wait(2)

    return total_data, total_likes


def append_extra_info(total_data: list[dict], likes: list[int], user_tag: str) -> list[dict]:
    likes = np.array(likes)
    like_ratio = np.round(likes / np.mean(likes), 3)

    with open(info.img_url_path, "r", encoding="utf-8") as json_file:
        img_urls = json.load(json_file)

    result_data = []
    for idx in range(info.account[user_tag]["valid_posts"]):
        total_data[idx]["like_ratio"] = like_ratio[idx]
        total_data[idx]["img_url"] = img_urls[user_tag][idx]
        result_data.append(total_data[idx])
    return result_data


def write_json(new_data: list[dict]) -> None:
    with open(info.raw_data_path, "r", encoding="utf-8") as json_file:
        load_data = json.load(json_file)
    load_data += [dict_ for dict_ in new_data if dict_ not in load_data]
    with open(info.raw_data_path, "w", encoding="utf-8") as json_file:
        json.dump(load_data, json_file, ensure_ascii=False, indent=4)


if __name__ == '__main__':
    init()
    time.sleep(5)
    user = "daejeon_people"
    content_data, like_data = get_data(user)
    all_data = append_extra_info(content_data, like_data, user)
    write_json(all_data)
