import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:naver_map_test/constant/constants.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: Constants.naverClintId,
    onAuthFailed: (ex) {
      debugPrint('네이버맵 인증 실패: $ex');
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late NaverMapController mapController;
  bool isLoading = true;

  Future<void> getPermission() async {
    try {
      if (await Permission.locationWhenInUse.request().isGranted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('getPermission error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? Container()
          : NaverMap(
              options: const NaverMapViewOptions(
                locationButtonEnable: true,
              ),
              forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
              onMapReady: (controller) async {
                mapController = controller;
                const iconImage = NOverlayImage.fromAssetImage('images/fire.png');
                final marker1 = NMarker(id: '1', position: const NLatLng(37.5596985, 126.9462753), icon: iconImage);
                final locationOverlay = mapController.getLocationOverlay();
                mapController.addOverlayAll({marker1});
                mapController.setLocationTrackingMode(NLocationTrackingMode.follow);
              },
              onMapTapped: (point, latLng) {},
              onSymbolTapped: (symbol) {},
              onCameraChange: (position, reason) {},
              onCameraIdle: () {},
              onSelectedIndoorChanged: (indoor) {},
            ),
    );
  }
}
