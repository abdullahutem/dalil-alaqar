import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/property_types/data/models/property_types_response_model.dart';

abstract class PropertyTypesRemoteDataSource {
  Future<PropertyTypesResponseModel> getPropertyTypes();
}

class PropertyTypesRemoteDataSourceImpl
    implements PropertyTypesRemoteDataSource {
  final ApiConsumer apiConsumer;

  PropertyTypesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<PropertyTypesResponseModel> getPropertyTypes() async {
    final response = await apiConsumer.get(EndPoints.propertyTypes);
    return PropertyTypesResponseModel.fromJson(response);
  }
}
