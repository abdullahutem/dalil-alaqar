import 'package:dio/dio.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/promotions_response_model.dart';

abstract class PromotionsRemoteDataSource {
  Future<PromotionsResponseModel> getPromotions();
}

class PromotionsRemoteDataSourceImpl implements PromotionsRemoteDataSource {
  final Dio dio;

  PromotionsRemoteDataSourceImpl({required this.dio});

  @override
  Future<PromotionsResponseModel> getPromotions() async {
    try {
      final response = await dio.get(EndPoints.promotions);
      return PromotionsResponseModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] as String? ??
            e.message ??
            'خطأ في الاتصال بالخادم',
      );
    } catch (e) {
      throw ServerException(message: 'حدث خطأ غير متوقع');
    }
  }
}
