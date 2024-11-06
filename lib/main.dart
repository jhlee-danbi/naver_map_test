import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
    clientId: '',
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
  // 세개의 오버레이 생성
  // (37.5596985, 126.9462753)
  // final marker1 = NMarker(id: '1', position: NLatLng(37.5596985, 126.9462753));
  // final marker2 = NMarker(id: '2', position: latLng2);
  // final circle = NCircleOverlay(id: '1', center: latLng3);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: NaverMap(
        options: const NaverMapViewOptions(locationButtonEnable: true), // 지도 옵션을 설정할 수 있습니다.
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
