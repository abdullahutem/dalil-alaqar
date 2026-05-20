import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/office_details/data/models/office_details_model.dart';

abstract class OfficeDetailsRemoteDataSource {
  Future<OfficeDetailsModel> getOfficeDetails(int officeId);
}

class OfficeDetailsRemoteDataSourceImpl
    implements OfficeDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  OfficeDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfficeDetailsModel> getOfficeDetails(int officeId) async {
    final response = await apiConsumer.get('${EndPoints.offices}/$officeId');
    return OfficeDetailsModel.fromJson(response['data']);
  }
}
