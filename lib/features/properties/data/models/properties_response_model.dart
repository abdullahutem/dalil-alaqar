import 'package:dalil_alaqar/features/properties/data/models/property_model.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';

class PropertiesResponseModel extends PropertiesResponseEntity {
  PropertiesResponseModel({required super.properties, required super.meta});

  factory PropertiesResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>;
    final properties = dataList
        .map(
          (property) =>
              PropertyModel.fromJson(property as Map<String, dynamic>),
        )
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>;
    final meta = PaginationMetaModel.fromJson(metaJson);

    return PropertiesResponseModel(properties: properties, meta: meta);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': properties
          .map((property) => (property as PropertyModel).toJson())
          .toList(),
      'meta': (meta as PaginationMetaModel).toJson(),
    };
  }
}

class PaginationMetaModel extends PaginationMeta {
  PaginationMetaModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
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
