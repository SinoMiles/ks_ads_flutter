import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ks_ads_flutter/ks_ads_callback.dart';
import 'package:ks_ads_flutter/ks_ads_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? _adStream;

  @override
  void initState() {
    super.initState();

    _initSdk();
    _adStream = KsAdsFlutter.initRewardStream(KsRewardVideoCallback(
      onLoad: () {
        print('onLoad');
      },
      onFail: (error) {
        print('error: $error');
      },
      onShow: () {
        print('onShow');
      },
      onClick: () {
        print('onClick');
      },
      onFinish: () {
        print('onFinish');
      },
      onClose: () {
        print('onClose');
      },
      onReward: () {
        print('onReward');
      },
      onSkip: () {
        print('onSkip');
      },
    ));
  }

  _initSdk() async {
    await KsAdsFlutter.register(
      iosAppId: '870500005',
      androidAppId: '561000009',
      appName: '123456',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('快手联盟广告Flutter'),
      ),
      body: KsAdsFlutter.splashAdView(
          androidCodeId: "8705000005",
          callBack: SplashViewCallback(
              onSkip: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RewardView();
                }));
              },
              onShow: () {},
              onFail: (message) {
                print(message);
              })),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _adStream?.cancel();
  }
}

class RewardView extends StatefulWidget {
  const RewardView({Key? key}) : super(key: key);

  @override
  _RewardViewState createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  String _sdkVersion = "";
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    _streamSubscription =
        KsAdsFlutter.initRewardStream(KsRewardVideoCallback(onLoad: () {
      print("加载中。。。");
    }, onFail: (message) {
      print(message);
    }));
    KsAdsFlutter.loadRewardVideo(iosPosId: "8705000017", androidPosId: "");
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String sdkVersionl;

    try {
      sdkVersionl = await KsAdsFlutter.sdkVersion ?? 'Unknown Sdk version';
    } on PlatformException {
      sdkVersionl = 'Failed to get sdk version.';
    }

    if (!mounted) return;

    setState(() {
      _sdkVersion = sdkVersionl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("sdk version: " + _sdkVersion),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  KsAdsFlutter.showReardVideo();
                },
                child: Text("显示激励视频")),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
