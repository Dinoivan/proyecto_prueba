import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector extends ChangeNotifier {
  StreamSubscription? _accelerometerSubscription;
  static const double shakeThreshold = 15.0;
  double x = 0.0, y = 0.0, z = 0.0;
  bool _shook = false;

  ShakeDetector() {
    _startListening();
  }

  bool get shook => _shook;

  void _startListening() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double deltaX = (x - event.x).abs();
      double deltaY = (y - event.y).abs();
      double deltaZ = (z - event.z).abs();

      if (deltaX > shakeThreshold || deltaY > shakeThreshold || deltaZ > shakeThreshold) {
        _onShake();
      }

      x = event.x;
      y = event.y;
      z = event.z;
    });
  }

  void _onShake() {
    _shook = true;
    notifyListeners();
  }

  void resetShake() {
    _shook = false;
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}