import 'package:dalil_alaqar/features/splash/domain/entities/splash_entity.dart';

class SplashModel extends SplashEntity {
  const SplashModel({
    required super.appName,
    required super.version,
    required super.isFirstLaunch,
  });

  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      appName: json['app_name'] ?? 'Panorama Hotel',
      version: json['version'] ?? '1.0.0',
      isFirstLaunch: json['is_first_launch'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'version': version,
      'is_first_launch': isFirstLaunch,
    };
  }
}
