import 'package:dalil_alaqar/features/districts/data/models/district_model.dart';
import 'package:dalil_alaqar/features/districts/domain/entities/districts_response_entity.dart';

class DistrictsResponseModel extends DistrictsResponseEntity {
  DistrictsResponseModel({
    required super.success,
    required super.message,
    required super.districts,
  });

  factory DistrictsResponseModel.fromJson(Map<String, dynamic> json) {
    return DistrictsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      districts:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => DistrictModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': districts
          .map((district) => (district as DistrictModel).toJson())
          .toList(),
    };
  }
}
