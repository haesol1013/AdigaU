import 'package:adigau/models/address_model.dart';
import 'package:adigau/models/information_model.dart';
import 'package:adigau/services/api_service.dart';
import 'package:adigau/services/geocode_service.dart';
import 'package:adigau/services/location_service.dart';
import 'package:adigau/widgets/thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class DetailScreen extends StatefulWidget {
  final String name, address, category, titleCategory;
  final int id;

  const DetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.titleCategory,
    required this.category,
    required this.address,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<AddressModel> address;
  late Future<Position> currencyLocation;
  late Future<InformationModel> information;

  @override
  void initState() {
    super.initState();
    information = ApiService.getInformationsByid(widget.id);
    currencyLocation = LocationService().getCurrencyPosition();
    address = GeocodeService().getGeocode(widget.address);
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
                  '${widget.titleCategory}가유',
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 13),
                    child: GestureDetector(
                      onTapDown: (details) {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder(
                      future: information,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).cardColor),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Thumbnail(
                                    name: snapshot.data!.name,
                                    imgUrl: snapshot.data!.imgUrl,
                                    isVideo: snapshot.data!.isVideo,
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
                                          snapshot.data!.name,
                                          style: const TextStyle(
                                              fontFamily: "GmarketSansBold",
                                              fontSize: 15),
                                        ),
                                        Text(
                                          snapshot.data!.location
                                              .split(" ")
                                              .sublist(0, 3)
                                              .join(" "),
                                          style: const TextStyle(fontSize: 8),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                snapshot.data!.tags
                                                    .join(" ")
                                                    .split(' ')
                                                    .sublist(0, 3)
                                                    .join(''),
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                                softWrap: true,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 55,
                                            ),
                                            Row(
                                              children: [
                                                snapshot.data!.isLiked
                                                    ? const Icon(
                                                        Icons.favorite_rounded)
                                                    : const Icon(Icons
                                                        .favorite_border_rounded),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data!.likes
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const Text('Loading...');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Container(
                      height: 450,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: Future.wait(
                                  [currencyLocation, address, information]),
                              builder: (context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                if (snapshot.hasData) {
                                  // Position location = snapshot.data![0];
                                  AddressModel coordinate = snapshot.data![1];
                                  InformationModel information =
                                      snapshot.data![2];
                                  return Column(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: SizedBox(
                                          width: 400,
                                          height: 230,
                                          child: NaverMap(
                                            options: NaverMapViewOptions(
                                              initialCameraPosition:
                                                  NCameraPosition(
                                                      target: NLatLng(
                                                        double.parse(coordinate
                                                            .latitude),
                                                        double.parse(coordinate
                                                            .longitude),
                                                        // snapshot.data![0].latitude,
                                                        // snapshot.data![0].longitude,
                                                      ),
                                                      zoom: 12),
                                            ),
                                            onMapReady: (controller) async {
                                              final targetMarker = NMarker(
                                                id: "targetMarker",
                                                position: NLatLng(
                                                  double.parse(
                                                      coordinate.latitude),
                                                  double.parse(
                                                      coordinate.longitude),
                                                ),
                                              );
                                              controller
                                                  .addOverlay(targetMarker);
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        information.location,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        information.time,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: SizedBox(
                                          height: 100,
                                          child: SingleChildScrollView(
                                            child: Text(
                                              information.description,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
