import 'package:dalil_alaqar/features/governorates/data/models/governorate_model.dart';
import 'package:dalil_alaqar/features/governorates/domain/entities/governorates_response_entity.dart';

class GovernoratesResponseModel extends GovernoratesResponseEntity {
  GovernoratesResponseModel({
    required super.success,
    required super.message,
    required super.governorates,
  });

  factory GovernoratesResponseModel.fromJson(Map<String, dynamic> json) {
    return GovernoratesResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      governorates:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    GovernorateModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': governorates
          .map((gov) => (gov as GovernorateModel).toJson())
          .toList(),
    };
  }
}
