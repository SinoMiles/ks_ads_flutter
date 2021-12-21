package com.ahd.ks_ads_flutter;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.kwad.sdk.api.KsAdSDK;
import com.kwad.sdk.api.KsLoadManager;
import com.kwad.sdk.api.KsScene;
import com.kwad.sdk.api.KsSplashScreenAd;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import java.util.HashMap;
import java.util.Map;

class SplashView  implements PlatformView {

    private FrameLayout mContainer;
    private Context mContext;
    private MethodChannel channel;
    private long adId;
    SplashView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams,BinaryMessenger messenger)  {
        mContainer= new FrameLayout(context);
        mContext=context;
        adId =  Long.parseLong(creationParams.get("androidCodeId").toString());
        channel = new MethodChannel(messenger, AdConfig.splash + "_" + id);
        requestSplashScreenAd();
    }

    @NonNull
    @Override
    public View getView() {
        return mContainer;
    }
    public void requestSplashScreenAd() {
        KsScene scene = new KsScene

                .Builder(adId).build(); // 此为测试posId，请联

        if (KsAdSDK.getLoadManager() != null) {
            KsAdSDK.getLoadManager().loadSplashScreenAd(scene, new
                    KsLoadManager.SplashScreenAdListener() {
                        @Override
                        public void onError(int code, String msg) {
                            channel.invokeMethod("onError",msg);
                        }
                        @Override
                        public void onRequestResult(int adNumber) {
                        }
                        @Override
                        public void onSplashScreenAdLoad(@NonNull KsSplashScreenAd splashScreenAd){
                            addView(splashScreenAd);

                        }
                    });
        }
    }
    private void addView(final KsSplashScreenAd splashScreenAd) {
        View view =
                splashScreenAd.getView(mContext,
                        new KsSplashScreenAd.SplashScreenAdInteractionListener() {

                            @Override
                            public void onAdClicked() {

                            }

                            @Override
                            public void onAdShowError(int i, String s) {
                                channel.invokeMethod("onAdShowError",s);
                            }

                            @Override
                            public void onAdShowEnd() {
                                channel.invokeMethod("onAdShowEnd","");
                            }

                            @Override
                            public void onAdShowStart() {

                            }

                            @Override
                            public void onSkippedAd() {
                                channel.invokeMethod("onSkippedAd","");
                            }

                            @Override
                            public void onDownloadTipsDialogShow() {

                            }

                            @Override
                            public void onDownloadTipsDialogDismiss() {

                            }

                            @Override
                            public void onDownloadTipsDialogCancel() {

                            }
                        });
        mContainer.addView(view);
    }
    @Override
    public void dispose() {}
}