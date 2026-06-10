import '../../domain/entities/office_properties_response_entity.dart';
import 'office_property_model.dart';

class OfficePropertiesResponseModel extends OfficePropertiesResponseEntity {
  const OfficePropertiesResponseModel({
    required super.properties,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory OfficePropertiesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;

    // The API returns meta inside the first item of the data array
    Map<String, dynamic>? meta;
    if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
      final firstItem = data[0] as Map<String, dynamic>;
      if (firstItem.containsKey('meta')) {
        meta = firstItem['meta'] as Map<String, dynamic>;
      }
    }

    // Convert all items to property models
    final dataList = data
        .map((e) => OfficePropertyModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return OfficePropertiesResponseModel(
      properties: dataList,
      currentPage: meta?['current_page'] as int? ?? 1,
      lastPage: meta?['last_page'] as int? ?? 1,
      perPage: meta?['per_page'] as int? ?? 15,
      total: meta?['total'] as int? ?? dataList.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': properties
          .map((e) => (e as OfficePropertyModel).toJson())
          .toList(),
      'meta': {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
      },
    };
  }
}
