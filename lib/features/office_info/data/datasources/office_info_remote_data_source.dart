import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dio/dio.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/office_info_model.dart';
import '../models/office_logo_model.dart';

abstract class OfficeInfoRemoteDataSource {
  Future<OfficeInfoModel> getOfficeInfo();
  Future<OfficeInfoModel> updateOfficeInfo(Map<String, dynamic> updateData);
  Future<OfficeLogoModel> uploadOfficeLogo(String filePath);
}

class OfficeInfoRemoteDataSourceImpl implements OfficeInfoRemoteDataSource {
  final ApiConsumer apiConsumer;

  OfficeInfoRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfficeInfoModel> getOfficeInfo() async {
    final response = await apiConsumer.get(EndPoints.officeInfo);
    return OfficeInfoModel.fromJson(response);
  }

  @override
  Future<OfficeInfoModel> updateOfficeInfo(
    Map<String, dynamic> updateData,
  ) async {
    final response = await apiConsumer.put(
      EndPoints.officeInfo,
      data: updateData,
    );
    return OfficeInfoModel.fromJson(response);
  }

  @override
  Future<OfficeLogoModel> uploadOfficeLogo(String filePath) async {
    final formData = FormData.fromMap({
      'logo': await MultipartFile.fromFile(filePath),
    });

    final response = await apiConsumer.post(
      EndPoints.officeLogo,
      data: formData,
      isFormData: true,
    );
    return OfficeLogoModel.fromJson(response);
  }
}
