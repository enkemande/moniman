import 'dart:async';

import 'package:flutter/material.dart';

class StreamChangeNotifier extends ChangeNotifier {
  late final List<StreamSubscription<dynamic>> _subscriptions;

  StreamChangeNotifier(List<Stream<dynamic>> streams) {
    notifyListeners();
    _subscriptions = streams.map((stream) {
      return stream
          .asBroadcastStream()
          .listen((dynamic _) => notifyListeners());
    }).toList();
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
