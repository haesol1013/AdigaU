from fastapi import FastAPI, HTTPException, Body, Form
from pydantic import BaseModel
from typing import List, Optional

#멕스 아이디
# max_id = max((spot.id for spot in db if spot.id is not None), default=0)

app = FastAPI()

#Spot클래스 설정
class Spot(BaseModel):
    id: Optional[int] = None
    name: Optional[str] = None
    location: Optional[str] = None
    time: Optional[str] = None
    tags: Optional[List[str]] = None
    description: Optional[str] = None
    category: Optional[str] = None
    isVideo: Optional[bool] = None
    likes: Optional[int] = None
    like_ratio: Optional[float] = None
    img_url: Optional[str] = None
    isLiked: Optional[bool] =  False

#데이터 저장소
db: List[Spot] = []
db_cafes: List[Spot] = []
db_pubs: List[Spot] = []
db_restaurants: List[Spot] = []


#처음 데이터 넣을 때
def load_data_first_from_json(data: List[Spot]):
    global db
    global db_cafes
    global db_pubs
    global db_restaurants
    db = []
    db_cafes = []
    db_pubs = []
    db_restaurants = []

    data = sorted(data, key=lambda x: x.like_ratio, reverse=True)
    id = 0
    for item in data:
        id += 1
        item.id = id
        db.append(item)
    for i in db:
        if i.category == 'cafes':
            db_cafes.append(i)
        elif i.category == 'restaurants':
            db_restaurants.append(i)
        elif i.category == 'pubs':
            db_pubs.append(i)


#두번째 부터 함수 넣을 때
def load_data_update_from_json(updata: List[Spot]):
    global db
    global db_cafes
    global db_pubs
    global db_restaurants
    updata = sorted(updata, key=lambda x: x.like_ratio, reverse=True)
    max_id = max((spot.id for spot in db if spot.id is not None), default=0)
    for item in updata:
        max_id += 1
        item.id = max_id
        db.append(item)
    db = sorted(db, key=lambda x: x.like_ratio, reverse=True)


#메인 화면
@app.get("/")
async def message():
    return ('어디가유 데이터 서버입니다.5')

#첫 데이터 넣을 때
@app.post("/first_data/")
def load_data_first(data: List[Spot]):
    try:
        load_data_first_from_json(data)
        return {"message": "First data loaded successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#업데이트 데이터 넣을 때
@app.post("/update_data/")
def load_data_update(data: List[Spot]):
    try:
        load_data_update_from_json(data)
        return {"message": "Update data loaded successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#찜 하기 기능
@app.put("/zzim/{spot_id}")
def zzimhagi(spot_id: int, isLiked: bool = Form(...)):
    for spot in db:
        if spot_id == spot.id:
            spot.isLiked = isLiked
            return {"message": "zzimhagi successfully"}
    raise HTTPException(status_code=404, detail="Spot not found")

@app.post("/spots/")
def create_spot(spot: Spot):
    if db:
        max_id = max(s.id for s in db if s.id is not None)
        spot.id = max_id + 1
    else:
        spot.id = 1

    db.append(spot)
    return spot

@app.get("/spots/")
def read_spots():
    return db

@app.get("/spots/cafes/")
def get_cafes():
    return db_cafes

@app.get("/spots/restaurants/")
def get_restaurants():
    return db_restaurants

@app.get("/spots/pubs/")
def get_pubs():
    return db_pubs

@app.get("/spots/zzim/")
def get_zzim():
    zzimlist = []
    for item in db:
        if item.isLiked == True:
            zzimlist.append(item)
    return zzimlist


@app.get("/spots/{spot_id}")
def read_spot(spot_id: int):
    for spot in db:
        if spot_id == spot.id:
            return spot
    raise HTTPException(status_code=404, detail="Spot not found")
