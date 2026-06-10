import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/property_types/data/models/property_type_model.dart';

abstract class PropertyTypesLocalDataSource {
  Future<List<PropertyTypeModel>> getCachedPropertyTypes();
  Future<void> cachePropertyTypes(List<PropertyTypeModel> propertyTypes);
  Future<void> clearPropertyTypes();
}

class PropertyTypesLocalDataSourceImpl implements PropertyTypesLocalDataSource {
  final DatabaseHelper databaseHelper;

  PropertyTypesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<PropertyTypeModel>> getCachedPropertyTypes() async {
    final db = await databaseHelper.database;
    final result = await db.query('property_types', orderBy: 'order ASC');

    return result.map((json) {
      return PropertyTypeModel(
        id: json['id'] as int,
        name: json['name'] as String,
        icon: json['icon'] as String,
        description: json['description'] as String?,
        order: json['order'] as int,
        isActive: (json['is_active'] as int) == 1,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        deletedAt: json['deleted_at'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> cachePropertyTypes(List<PropertyTypeModel> propertyTypes) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${propertyTypes.length} property types to database');

      // Clear existing property types
      await db.delete('property_types');

      // Insert new property types
      final cachedAt = DateTime.now().toIso8601String();
      for (final propertyType in propertyTypes) {
        print(
          '💾 Inserting property type ${propertyType.id}: ${propertyType.name}',
        );
        await db.insert('property_types', {
          'id': propertyType.id,
          'name': propertyType.name,
          'icon': propertyType.icon,
          'description': propertyType.description,
          'order': propertyType.order,
          'is_active': propertyType.isActive ? 1 : 0,
          'created_by': propertyType.createdBy,
          'updated_by': propertyType.updatedBy,
          'created_at': propertyType.createdAt,
          'updated_at': propertyType.updatedAt,
          'deleted_at': propertyType.deletedAt,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${propertyTypes.length} property types');
    } catch (e, stackTrace) {
      print('❌ Error caching property types: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearPropertyTypes() async {
    final db = await databaseHelper.database;
    await db.delete('property_types');
  }
}
