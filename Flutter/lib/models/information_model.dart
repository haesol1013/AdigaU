class InformationModel {
  final String name, location, time, description, category, imgUrl;
  final List tags;
  final bool isVideo;
  final int id, likes;
  final double likeRatio;
  final bool isLiked;

  InformationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        location = json['location'],
        time = json['time'],
        tags = json['tags'],
        description = json['description'],
        category = json['category'],
        isVideo = json['isVideo'],
        likes = json['likes'],
        likeRatio = json['like_ratio'],
        imgUrl = json['img_url'],
        isLiked = json['isLiked'];
}
