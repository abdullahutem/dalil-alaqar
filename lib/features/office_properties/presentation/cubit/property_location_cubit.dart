import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'property_location_state.dart';

class PropertyLocationCubit extends Cubit<PropertyLocationState> {
  LatLng currentPosition = const LatLng(
    15.3694,
    44.1910,
  ); // Sana'a, Yemen default
  String? currentAddress;
  bool hasLocationPermission = false;

  PropertyLocationCubit() : super(const PropertyLocationInitial());

  /// Request location permission and get current position
  Future<void> requestLocationPermission() async {
    emit(const PropertyLocationLoading());

    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(const PropertyLocationPermissionDenied('خدمة الموقع غير مفعلة'));
      await _reverseGeocode(currentPosition);
      emit(PropertyLocationUpdated(currentPosition, currentAddress));
      return;
    }

    // Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // Request permission if denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(const PropertyLocationPermissionDenied('تم رفض إذن الموقع'));
        await _reverseGeocode(currentPosition);
        emit(PropertyLocationUpdated(currentPosition, currentAddress));
        return;
      }
    }

    // Handle permanently denied
    if (permission == LocationPermission.deniedForever) {
      emit(
        const PropertyLocationPermissionDenied(
          'تم رفض إذن الموقع بشكل دائم. الرجاء تفعيله من الإعدادات',
        ),
      );
      await _reverseGeocode(currentPosition);
      emit(PropertyLocationUpdated(currentPosition, currentAddress));
      return;
    }

    // Get current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition = LatLng(position.latitude, position.longitude);
      hasLocationPermission = true;
      await _reverseGeocode(currentPosition);
      emit(PropertyLocationUpdated(currentPosition, currentAddress));
    } catch (e) {
      emit(PropertyLocationError('فشل الحصول على الموقع: ${e.toString()}'));
      await _reverseGeocode(currentPosition);
      emit(PropertyLocationUpdated(currentPosition, currentAddress));
    }
  }

  /// Update position when user taps on map
  Future<void> updateMapPosition(LatLng position) async {
    currentPosition = position;
    emit(const PropertyLocationLoading());
    await _reverseGeocode(position);
    emit(PropertyLocationUpdated(position, currentAddress));
  }

  /// Get address from coordinates using reverse geocoding
  Future<void> _reverseGeocode(LatLng position) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': position.latitude,
          'lon': position.longitude,
          'zoom': 18,
          'addressdetails': 1,
          'accept-language': 'ar',
        },
        options: Options(headers: {'User-Agent': 'DalilAlaqar/1.0'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        currentAddress =
            response.data['display_name'] as String? ??
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      } else {
        currentAddress =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      }
    } catch (e) {
      // Fallback to coordinates if geocoding fails
      currentAddress =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    }
  }

  /// Initialize with existing coordinates (for edit mode)
  Future<void> initializeWithCoordinates(
    double latitude,
    double longitude,
  ) async {
    currentPosition = LatLng(latitude, longitude);
    await _reverseGeocode(currentPosition);
    emit(PropertyLocationUpdated(currentPosition, currentAddress));
  }

  /// Reset to initial state
  void reset() {
    currentPosition = const LatLng(15.3694, 44.1910);
    currentAddress = null;
    hasLocationPermission = false;
    emit(const PropertyLocationInitial());
  }
}
