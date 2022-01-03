#import "SplashViewFactory.h"
#import <KSAdSDK/KSAdSDK.h>



@interface SplashView () <KSSplashAdViewDelegate>

@end

@implementation SplashViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

//- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
//                                   viewIdentifier:(int64_t)viewId
//                                        arguments:(id _Nullable)args {
////  return [[SplashView alloc] initWithFrame:frame
////                              viewIdentifier:viewId
////                                   arguments:args
////                             binaryMessenger:_messenger];
//    SplashView *splashView = [[SplashView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
//    return  SplashView
//}
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    SplashView *videoView = [[SplashView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return videoView;
}
@end

@implementation SplashView {
    UIWindow *_container;
    KSSplashAdView *splashAdView;
    FlutterMethodChannel* _channel;
}


- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    NSString *methodName = [NSString stringWithFormat:@"com.miles.ksAd/SplashAdView_%lld", viewId];
    _channel = [FlutterMethodChannel methodChannelWithName:methodName binaryMessenger:messenger];
    _container = [[UIWindow alloc] initWithFrame:frame];
    _container.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    splashAdView= [[KSSplashAdView alloc] initWithPosId:@"8879000003"];
    splashAdView.delegate=self;
    splashAdView.rootViewController=_container.rootViewController;
    [splashAdView loadAdData];
  return self;
}

 
#pragma -mark KSSplashAdDelegate
- (void)ksad_splashAdDidLoad:(KSSplashAdView *)splashAdView {

}
- (void)ksad_splashAdContentDidLoad:(KSSplashAdView *)splashAdView {
     [splashAdView showInView:[[UIApplication sharedApplication] keyWindow]];
}
- (void)ksad_splashAdDidVisible:(KSSplashAdView *)splashAdView {
    [_channel invokeMethod:@"onShow" arguments:nil];
}
- (void)ksad_splashAdVideoDidBeginPlay:(KSSplashAdView *)splashAdView {
 
}
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didFailWithError:(nonnull NSError
*)error {
    [_channel invokeMethod:@"onError" arguments:[NSString stringWithFormat:@"错误码：%ld", (long)error.code]];
}
- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didSkip:
(NSTimeInterval)playDuration {
    [_channel invokeMethod:@"onSkip" arguments:nil];
    [splashAdView removeFromSuperview];
    splashAdView=nil;
    [_channel invokeMethod:@"onSkip" arguments:nil];
}

- (void)ksad_splashAd:(KSSplashAdView *)splashAdView didClick:(BOOL)onZoomOutState {
 //点击跳转了
 
}
- (void)ksad_splashAdDidAutoDismiss:(KSSplashAdView *)splashAdView {

}
- (void)ksad_splashAdDidClose:(KSSplashAdView *)splashAdView {
    [_channel invokeMethod:@"onClose" arguments:nil];
    [splashAdView removeFromSuperview];
    splashAdView=nil;
}

- (UIView*)view {
  return _container;
}

@end
