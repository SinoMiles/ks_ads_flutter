import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ks_ads_flutter/ks_ads_callback.dart';

class SplashAdView extends StatefulWidget {
  final String androidCodeId;
  final SplashViewCallback? callBack;
  SplashAdView({Key? key, required this.androidCodeId, this.callBack})
      : super(key: key);

  @override
  _SplashAdViewState createState() => _SplashAdViewState();
}

class _SplashAdViewState extends State<SplashAdView> {
  String _viewType = "com.miles.ksAd/SplashAdView";
  MethodChannel? _channel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AndroidView(
        viewType: _viewType,
        creationParams: {"androidCodeId": widget.androidCodeId},
        onPlatformViewCreated: _registerChannel,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }

  //注册channel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onSkippedAd":
        widget.callBack!.onSkip!();
        break;
      case "onAdShowEnd":
        widget.callBack!.onShow!();
        break;
      case "onAdShowError":
        widget.callBack!.onSkip!();
        break;
      case "onError":
        widget.callBack!.onFail!(call.arguments);
        break;
      default:
    }
  }
}
