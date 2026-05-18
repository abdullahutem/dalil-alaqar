import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/features/splash/data/models/splash_model.dart';

abstract class SplashLocalDataSource {
  Future<SplashModel> getSplashData();
  Future<bool> checkFirstLaunch();
  Future<void> setFirstLaunchComplete();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final CacheHelper cacheHelper;

  SplashLocalDataSourceImpl({required this.cacheHelper});

  @override
  Future<SplashModel> getSplashData() async {
    return const SplashModel(
      appName: 'Panorama Hotel',
      version: '1.0.0',
      isFirstLaunch: false,
    );
  }

  @override
  Future<bool> checkFirstLaunch() async {
    final isFirstLaunch = await cacheHelper.getData(key: 'is_first_launch');
    return isFirstLaunch ?? true;
  }

  @override
  Future<void> setFirstLaunchComplete() async {
    await cacheHelper.saveData(key: 'is_first_launch', value: false);
  }
}
