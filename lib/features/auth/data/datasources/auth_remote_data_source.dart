import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String phoneNumber,
    required String password,
  });

  Future<String> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<AuthResponseModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await apiConsumer.post(
      '${EndPoints.baserUrl}${EndPoints.login}',
      data: {'phone_number': phoneNumber, 'password': password},
    );

    final data = response['data'] as Map<String, dynamic>;
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<String> logout() async {
    final response = await apiConsumer.post(
      '${EndPoints.baserUrl}${EndPoints.logout}',
    );

    final data = response['data'] as Map<String, dynamic>;
    return data['message'] as String;
  }
}
