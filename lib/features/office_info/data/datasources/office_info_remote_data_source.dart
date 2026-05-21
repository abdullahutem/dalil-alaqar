import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/office_info_model.dart';

abstract class OfficeInfoRemoteDataSource {
  Future<OfficeInfoModel> getOfficeInfo();
}

class OfficeInfoRemoteDataSourceImpl implements OfficeInfoRemoteDataSource {
  final ApiConsumer apiConsumer;

  OfficeInfoRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfficeInfoModel> getOfficeInfo() async {
    final response = await apiConsumer.get(EndPoints.officeInfo);
    return OfficeInfoModel.fromJson(response);
  }
}
