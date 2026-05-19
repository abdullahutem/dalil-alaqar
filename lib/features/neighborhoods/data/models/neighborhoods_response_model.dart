import 'package:dalil_alaqar/features/neighborhoods/data/models/neighborhood_model.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhoods_response_entity.dart';

class NeighborhoodsResponseModel extends NeighborhoodsResponseEntity {
  NeighborhoodsResponseModel({
    required super.success,
    required super.message,
    required super.neighborhoods,
  });

  factory NeighborhoodsResponseModel.fromJson(Map<String, dynamic> json) {
    return NeighborhoodsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      neighborhoods:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    NeighborhoodModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': neighborhoods
          .map((neighborhood) => (neighborhood as NeighborhoodModel).toJson())
          .toList(),
    };
  }
}
