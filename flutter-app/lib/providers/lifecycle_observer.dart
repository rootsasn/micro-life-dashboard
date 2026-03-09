import 'package:flutter/material.dart';
import 'data_provider.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  final DataProvider dataProvider;

  LifecycleObserver(this.dataProvider);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        debugPrint('App resumed - checking for old items');
        dataProvider.deleteOldItems();
        break;
      case AppLifecycleState.paused:
        // App going to background
        debugPrint('App paused - data persisted');
        break;
      case AppLifecycleState.inactive:
        // App inactive (e.g., phone call)
        break;
      case AppLifecycleState.detached:
        // App detached
        break;
      case AppLifecycleState.hidden:
        // App hidden
        break;
    }
  }
}
