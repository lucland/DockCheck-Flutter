import 'package:permission_handler/permission_handler.dart';

enum PermissionRequestStatus {
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

abstract class PermissionHandler {
  Future<PermissionRequestStatus> getCameraPermissionStatus();
  Future<PermissionRequestStatus> getPhotosPermissionStatus();
  Future<PermissionRequestStatus> getStoragePermissionStatus();
  Future<PermissionRequestStatus> getLocationPermissionStatus();
  Future<PermissionRequestStatus> getContactsPermissionStatus();
  Future<PermissionRequestStatus> requestCameraPermission();
  Future<PermissionRequestStatus> requestStoragePermission();
  Future<PermissionRequestStatus> requestPhotosPermission();
  Future<PermissionRequestStatus> requestLocationPermission();
  Future<PermissionRequestStatus> requestContactsPermission();
  Future<bool> openAppSettingsRequest();
}

class PermissionHandlerService implements PermissionHandler {
  @override
  Future<PermissionRequestStatus> getCameraPermissionStatus() async {
    final result = await _checkServiceStatus(Permission.camera);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> getContactsPermissionStatus() async {
    final result = await _checkServiceStatus(Permission.contacts);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> getLocationPermissionStatus() async {
    final result = await _checkServiceStatus(Permission.location);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> getPhotosPermissionStatus() async {
    final result = await _checkServiceStatus(Permission.photos);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> getStoragePermissionStatus() async {
    final result = await _checkServiceStatus(Permission.storage);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> requestCameraPermission() async {
    final result = await _requestPermission(Permission.camera);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> requestContactsPermission() async {
    final result = await _requestPermission(Permission.contacts);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> requestLocationPermission() async {
    final result = await _requestPermission(Permission.location);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> requestPhotosPermission() async {
    final result = await _requestPermission(Permission.photos);
    return _mapPermissionToRequestStatus(result);
  }

  @override
  Future<PermissionRequestStatus> requestStoragePermission() async {
    final result = await _requestPermission(Permission.storage);
    return _mapPermissionToRequestStatus(result);
  }

  Future<PermissionStatus> _checkServiceStatus(Permission permission) async {
    return await permission.status;
  }

  Future<PermissionStatus> _requestPermission(Permission permission) async {
    return await permission.request();
  }

  PermissionRequestStatus _mapPermissionToRequestStatus(
      PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        return PermissionRequestStatus.denied;
      case PermissionStatus.granted:
        return PermissionRequestStatus.granted;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        return PermissionRequestStatus.restricted;
      case PermissionStatus.permanentlyDenied:
        return PermissionRequestStatus.permanentlyDenied;
      case PermissionStatus.provisional:
        return PermissionRequestStatus.granted;
    }
  }

  @override
  Future<bool> openAppSettingsRequest() async => await openAppSettings();
}
