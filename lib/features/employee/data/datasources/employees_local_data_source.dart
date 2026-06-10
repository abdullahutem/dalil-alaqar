import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/employee/data/models/employee_model.dart';

abstract class EmployeesLocalDataSource {
  Future<List<EmployeeModel>> getCachedEmployees();
  Future<void> cacheEmployees(List<EmployeeModel> employees);
  Future<void> clearEmployees();
}

class EmployeesLocalDataSourceImpl implements EmployeesLocalDataSource {
  final DatabaseHelper databaseHelper;

  EmployeesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<EmployeeModel>> getCachedEmployees() async {
    final db = await databaseHelper.database;
    final result = await db.query('employees', orderBy: 'id DESC');

    return result.map((json) {
      // Parse office data
      final officeData = {
        'id': json['office_id'] as int,
        'name': json['office_name'] as String,
        'email': json['office_email'] as String,
      };

      return EmployeeModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phoneNumber: json['phone_number'] as String,
        whatsappNumber: json['whatsapp_number'] as String?,
        address: json['address'] as String?,
        userType: json['user_type'] as String,
        role: json['role'] as String,
        office: EmployeeOfficeModel.fromJson(officeData),
        isActive: (json['is_active'] as int) == 1,
        avatar: json['avatar'] as String?,
        createdAt: json['created_at'] as String,
      );
    }).toList();
  }

  @override
  Future<void> cacheEmployees(List<EmployeeModel> employees) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${employees.length} employees to database');

      // Clear existing employees
      await db.delete('employees');

      // Insert new employees
      final cachedAt = DateTime.now().toIso8601String();
      for (final employee in employees) {
        print('💾 Inserting employee ${employee.id}: ${employee.name}');
        await db.insert('employees', {
          'id': employee.id,
          'name': employee.name,
          'email': employee.email,
          'phone_number': employee.phoneNumber,
          'whatsapp_number': employee.whatsappNumber,
          'address': employee.address,
          'user_type': employee.userType,
          'role': employee.role,
          'office_id': employee.office.id,
          'office_name': employee.office.name,
          'office_email': employee.office.email,
          'is_active': employee.isActive ? 1 : 0,
          'avatar': employee.avatar,
          'created_at': employee.createdAt,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${employees.length} employees');
    } catch (e, stackTrace) {
      print('❌ Error caching employees: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearEmployees() async {
    final db = await databaseHelper.database;
    await db.delete('employees');
  }
}
