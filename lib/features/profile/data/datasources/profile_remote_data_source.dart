import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/profile_model.dart';
import '../models/updated_user_model.dart';
import '../../domain/entities/update_profile_params.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<UpdatedUserModel> updateProfile(UpdateProfileParams params);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiConsumer.get(EndPoints.profile);

    if (response['success'] == true && response['data'] != null) {
      return ProfileModel.fromJson(response['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<UpdatedUserModel> updateProfile(UpdateProfileParams params) async {
    final response = await apiConsumer.put(
      EndPoints.updateProfile,
      data: params.toJson(),
    );

    if (response['success'] == true && response['data'] != null) {
      return UpdatedUserModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to update profile');
    }
  }
}
