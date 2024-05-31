import 'package:adigau/screens/home_screen.dart';
import 'package:adigau/services/api_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: ApiKey().clientID,
    onAuthFailed: (ex) {
      debugPrint("********* 네이버맵 인증오류 : $ex *********");
    },
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color(0xFF0A6847),
        colorScheme:
            ColorScheme.fromSwatch(backgroundColor: const Color(0xFFF6E9B2)
                // backgroundColor: const Color(0xFFF3CA52),
                ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF6E9B2),
        fontFamily: "GmarketSansMedium",
      ),
      home: const HomeScreen(),
    );
  }
}
