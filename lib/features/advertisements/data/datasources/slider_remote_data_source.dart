import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/advertisements/data/models/slider_response_model.dart';

abstract class SliderRemoteDataSource {
  Future<SliderResponseModel> getSlides();
}

class SliderRemoteDataSourceImpl implements SliderRemoteDataSource {
  final ApiConsumer apiConsumer;

  SliderRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<SliderResponseModel> getSlides() async {
    try {
      final response = await apiConsumer.get(EndPoints.advertisements);

      print('📦 Raw API Response: $response');
      print('📦 Response type: ${response.runtimeType}');

      // The response structure is: {"success": true, "message": "...", "data": [...]}
      // We need to extract the data array
      final dataList = response['data'] as List<dynamic>;

      print('📦 Data list length: ${dataList.length}');
      print('📦 First item: ${dataList.isNotEmpty ? dataList[0] : "empty"}');

      // Convert to the expected format with slides array
      final formattedData = {'slides': dataList, 'count': dataList.length};

      print('📦 Formatted data: $formattedData');

      final result = SliderResponseModel.fromJson(formattedData);

      print('✅ Successfully parsed ${result.slides.length} slides');

      return result;
    } catch (e, stackTrace) {
      print('❌ Error in getSlides: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }
}
