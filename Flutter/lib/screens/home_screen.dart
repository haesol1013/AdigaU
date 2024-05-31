import 'package:adigau/models/information_model.dart';
import 'package:adigau/screens/detail_screen.dart';
import 'package:adigau/services/api_service.dart';
import 'package:adigau/widgets/thumbnail_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<InformationModel>> informations;
  late String category;
  late String titleCategory;

  @override
  void initState() {
    super.initState();
    category = "zzim";
    informations = ApiService.getInformationsByCategory(category);
    titleCategory = '어디';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                child: Text(
                  '$titleCategory가유',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontFamily: 'GmarketSansBold',
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              titleCategory = '카페';
                              category = "cafes";
                              informations =
                                  ApiService.getInformationsByCategory(
                                      category);
                            });
                          },
                          icon: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/cafe.jpeg',
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                '카페',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              titleCategory = '맛집';
                              category = "restaurants";
                              informations =
                                  ApiService.getInformationsByCategory(
                                      category);
                            });
                          },
                          icon: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/food.jpeg',
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                '맛집',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              titleCategory = '술집';
                              category = "pubs";
                              informations =
                                  ApiService.getInformationsByCategory(
                                      category);
                            });
                          },
                          icon: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 50,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/pub.png',
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                '술집',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              category = "zzim";
                              informations =
                                  ApiService.getInformationsByCategory(
                                      category);
                              titleCategory = '어디';
                            });
                          },
                          icon: Column(
                            children: [
                              SizedBox(
                                width: 80,
                                height: 50,
                                child: Icon(
                                  Icons.favorite_rounded,
                                  size: 55,
                                  color: Colors.red.shade400,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                '찜',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: informations,
                    builder: (context, snapshot) {
                      if (snapshot.data?.isEmpty == true) {
                        return const Column(
                          children: [
                            SizedBox(
                              height: 180,
                            ),
                            Text('찜하기 리스트가 비어있습니다.'),
                            Text('마음에 드는 장소에 하트를 눌러 찜할 수 있어요!')
                          ],
                        );
                      } else if (snapshot.hasData) {
                        return Expanded(
                          child: RefreshIndicator(
                            color: Theme.of(context).cardColor,
                            onRefresh: () async {
                              setState(() {
                                informations =
                                    ApiService.getInformationsByCategory(
                                        category);
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListView.separated(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 10,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var information = snapshot.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                DetailScreen(
                                                    id: information.id,
                                                    name: information.name,
                                                    address:
                                                        information.location,
                                                    category:
                                                        information.category,
                                                    titleCategory:
                                                        titleCategory),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Theme.of(context).cardColor),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Thumbnail(
                                                name: information.name,
                                                imgUrl: information.imgUrl,
                                                isVideo: information.isVideo,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      information.name,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              "GmarketSansBold",
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      information.location
                                                          .split(" ")
                                                          .sublist(0, 3)
                                                          .join(" "),
                                                      style: const TextStyle(
                                                          fontSize: 8),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                            information.tags
                                                                .join(" ")
                                                                .split(' ')
                                                                .sublist(0, 3)
                                                                .join(''),
                                                            style: TextStyle(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7)),
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  ApiService().postIsLiked(
                                                                      information
                                                                          .id,
                                                                      !information
                                                                          .isLiked);
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          milliseconds:
                                                                              100)); // sleep 대신 Future.delayed 사용
                                                                  setState(() {
                                                                    informations =
                                                                        ApiService.getInformationsByCategory(
                                                                            category);
                                                                  }); // UI 업데이트
                                                                },
                                                                icon: Icon(information
                                                                        .isLiked
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border),
                                                              ),
                                                              Text(
                                                                information
                                                                    .likes
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case