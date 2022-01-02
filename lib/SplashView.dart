import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ks_ads_flutter/ks_ads_callback.dart';

class SplashAdView extends StatefulWidget {
  final String androidCodeId;
  final String? iosidCodeId;
  final SplashViewCallback? callBack;
  SplashAdView(
      {Key? key, required this.androidCodeId, this.callBack, this.iosidCodeId})
      : super(key: key);

  @override
  _SplashAdViewState createState() => _SplashAdViewState();
}

class _SplashAdViewState extends State<SplashAdView> {
  String _viewType = "com.miles.ksAd/SplashAdView";
  MethodChannel? _channel;
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
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
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {"iosCodeId": widget.iosidCodeId},
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
  }

  //注册channel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onShow":
        widget.callBack!.onShow!();
        break;
      case "onClose":
        widget.callBack!.onClose!();
        break;
      case "onSkip":
        widget.callBack!.onSkip!();
        break;
      case "onAdShowEnd":
        widget.callBack!.onShowEnd!();
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
