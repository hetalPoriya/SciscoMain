package io.flutter.plugins;

import io.flutter.app.FlutterApplication;


public class Application extends FlutterApplication /*implements PluginRegistrantCallback*/ {

    @Override
    public void onCreate() {
        super.onCreate();
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

/*    @Override
    public void registerWith(PluginRegistry registry) {
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
    }*/
}