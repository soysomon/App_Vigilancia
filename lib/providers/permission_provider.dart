import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier {
  bool _isPermissionUnknown = true;
  PermissionStatus _status = PermissionStatus.denied;

  PermissionStatus get status => _status;

  Future<void> requestPermission() async {
    if (_isPermissionUnknown) {
      _status = await Permission.microphone.request();
      _isPermissionUnknown = false;
    }
    notifyListeners();
  }
}