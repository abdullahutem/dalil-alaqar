import 'package:dalil_alaqar/features/offices/data/models/office_model.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/offices_response_entity.dart';

class OfficesResponseModel extends OfficesResponseEntity {
  const OfficesResponseModel({
    required super.success,
    required super.message,
    required super.data,
    required super.meta,
  });

  factory OfficesResponseModel.fromJson(Map<String, dynamic> json) {
    return OfficesResponseModel(
      success: (json['success'] as bool?) ?? false,
      message: json['message'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => OfficeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((office) {
        final officeModel = office as OfficeModel;
        return officeModel.toJson();
      }).toList(),
      'meta': (meta as MetaModel).toJson(),
    };
  }
}

class MetaModel extends MetaEntity {
  const MetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: (json['current_page'] as int?) ?? 1,
      lastPage: (json['last_page'] as int?) ?? 1,
      perPage: (json['per_page'] as int?) ?? 20,
      total: (json['total'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
