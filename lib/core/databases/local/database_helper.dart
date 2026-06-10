import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dalil_alaqar.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 22, // Added employee_stats table for caching employee statistics
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Verify the slides table exists and has the correct schema
        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='slides'",
        );

        if (tables.isEmpty) {
          AppLogger.warning(
            'Slides table does not exist, creating it...',
            'Database',
          );
          await _createDB(db, 6);
        } else {
          AppLogger.database('Slides table exists', 'Database');
        }

        // Verify the offices table exists
        final officesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='offices'",
        );

        if (officesTables.isEmpty) {
          AppLogger.warning(
            'Offices table does not exist, creating it...',
            'Database',
          );
          await _createOfficesTable(db);
        } else {
          AppLogger.database('Offices table exists', 'Database');
        }

        // Verify the office_details table exists
        final officeDetailsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='office_details'",
        );

        if (officeDetailsTables.isEmpty) {
          AppLogger.warning(
            'Office details table does not exist, creating it...',
            'Database',
          );
          await _createOfficeDetailsTable(db);
        } else {
          AppLogger.database('Office details table exists', 'Database');
        }

        // Verify the property_types table exists
        final propertyTypesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='property_types'",
        );

        if (propertyTypesTables.isEmpty) {
          AppLogger.warning(
            'Property types table does not exist, creating it...',
            'Database',
          );
          await _createPropertyTypesTable(db);
        } else {
          AppLogger.database('Property types table exists', 'Database');
        }

        // Verify the properties_cache table exists
        final propertiesCacheTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='properties_cache'",
        );

        if (propertiesCacheTables.isEmpty) {
          AppLogger.warning(
            'Properties cache table does not exist, creating it...',
            'Database',
          );
          await _createPropertiesCacheTable(db);
        } else {
          AppLogger.database('Properties cache table exists', 'Database');
        }

        // Verify the property_details table exists
        final propertyDetailsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='property_details'",
        );

        if (propertyDetailsTables.isEmpty) {
          AppLogger.warning(
            'Property details table does not exist, creating it...',
            'Database',
          );
          await _createPropertyDetailsTable(db);
        } else {
          AppLogger.database('Property details table exists', 'Database');
        }

        // Verify the promotions table exists
        final promotionsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='promotions'",
        );

        if (promotionsTables.isEmpty) {
          AppLogger.warning(
            'Promotions table does not exist, creating it...',
            'Database',
          );
          await _createPromotionsTable(db);
        } else {
          AppLogger.database('Promotions table exists', 'Database');
        }

        // Verify the dashboard_stats table exists
        final dashboardTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='dashboard_stats'",
        );

        if (dashboardTables.isEmpty) {
          AppLogger.warning(
            'Dashboard stats table does not exist, creating it...',
            'Database',
          );
          await _createDashboardStatsTable(db);
        } else {
          AppLogger.database('Dashboard stats table exists', 'Database');
        }

        // Verify the employees table exists
        final employeesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='employees'",
        );

        if (employeesTables.isEmpty) {
          AppLogger.warning(
            'Employees table does not exist, creating it...',
            'Database',
          );
          await _createEmployeesTable(db);
        } else {
          AppLogger.database('Employees table exists', 'Database');
        }

        // Verify the currencies table exists
        final currenciesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='currencies'",
        );

        if (currenciesTables.isEmpty) {
          AppLogger.warning(
            'Currencies table does not exist, creating it...',
            'Database',
          );
          await _createCurrenciesTable(db);
        } else {
          AppLogger.database('Currencies table exists', 'Database');
        }

        // Verify the districts table exists
        final districtsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='districts'",
        );

        if (districtsTables.isEmpty) {
          AppLogger.warning(
            'Districts table does not exist, creating it...',
            'Database',
          );
          await _createDistrictsTable(db);
        } else {
          AppLogger.database('Districts table exists', 'Database');
        }

        // Verify the governorates table exists
        final governoratesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='governorates'",
        );

        if (governoratesTables.isEmpty) {
          AppLogger.warning(
            'Governorates table does not exist, creating it...',
            'Database',
          );
          await _createGovernoratesTable(db);
        } else {
          AppLogger.database('Governorates table exists', 'Database');
        }

        // Verify the neighborhoods table exists
        final neighborhoodsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='neighborhoods'",
        );

        if (neighborhoodsTables.isEmpty) {
          AppLogger.warning(
            'Neighborhoods table does not exist, creating it...',
            'Database',
          );
          await _createNeighborhoodsTable(db);
        } else {
          AppLogger.database('Neighborhoods table exists', 'Database');
        }

        // Verify the cache_metadata table exists
        final cacheMetadataTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='cache_metadata'",
        );

        if (cacheMetadataTables.isEmpty) {
          AppLogger.warning(
            'Cache metadata table does not exist, creating it...',
            'Database',
          );
          await _createCacheMetadataTable(db);
        } else {
          AppLogger.database('Cache metadata table exists', 'Database');
        }

        // Verify the plans table exists
        final plansTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='plans'",
        );

        if (plansTables.isEmpty) {
          AppLogger.warning(
            'Plans table does not exist, creating it...',
            'Database',
          );
          await _createPlansTable(db);
        } else {
          AppLogger.database('Plans table exists', 'Database');
        }

        // Verify the office_info table exists
        final officeInfoTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='office_info'",
        );

        if (officeInfoTables.isEmpty) {
          AppLogger.warning(
            'Office info table does not exist, creating it...',
            'Database',
          );
          await _createOfficeInfoTable(db);
        } else {
          AppLogger.database('Office info table exists', 'Database');
        }

        // Verify the profile table exists
        final profileTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='profile'",
        );

        if (profileTables.isEmpty) {
          AppLogger.warning(
            'Profile table does not exist, creating it...',
            'Database',
          );
          await _createProfileTable(db);
        } else {
          AppLogger.database('Profile table exists', 'Database');
        }

        // Verify the employee_stats table exists
        final employeeStatsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='employee_stats'",
        );

        if (employeeStatsTables.isEmpty) {
          AppLogger.warning(
            'Employee stats table does not exist, creating it...',
            'Database',
          );
          await _createEmployeeStatsTable(db);
        } else {
          AppLogger.database('Employee stats table exists', 'Database');
        }
      },
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Drop old slides table if it exists (to fix NOT NULL constraint on office_id)
      await db.execute('DROP TABLE IF EXISTS slides');

      // Create new slides table with updated schema (office_id is nullable)
      await db.execute('''
        CREATE TABLE slides (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          image TEXT NOT NULL,
          link TEXT NOT NULL,
          position TEXT NOT NULL,
          "order" INTEGER NOT NULL,
          office_id INTEGER,
          start_date TEXT NOT NULL,
          end_date TEXT NOT NULL,
          views_count INTEGER NOT NULL,
          clicks_count INTEGER NOT NULL,
          is_active INTEGER NOT NULL,
          status TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          cached_at TEXT NOT NULL
        )
      ''');

      AppLogger.success(
        'Database upgraded to version $newVersion - office_id is now nullable',
        'Database',
      );
    }

    if (oldVersion < 4) {
      // Add offices table
      await _createOfficesTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - offices table added',
        'Database',
      );
    }

    if (oldVersion < 5) {
      // Add office_details table
      await _createOfficeDetailsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - office_details table added',
        'Database',
      );
    }

    if (oldVersion < 6) {
      // Add property_types table
      await _createPropertyTypesTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - property_types table added',
        'Database',
      );
    }

    if (oldVersion < 7) {
      // Add properties_cache table
      await _createPropertiesCacheTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - properties_cache table added',
        'Database',
      );
    }

    if (oldVersion < 8) {
      // Add property_details table
      await _createPropertyDetailsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - property_details table added',
        'Database',
      );
    }

    if (oldVersion < 9) {
      // Add promotions table
      await _createPromotionsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - promotions table added',
        'Database',
      );
    }

    if (oldVersion < 10) {
      // Add dashboard_stats table
      await _createDashboardStatsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - dashboard_stats table added',
        'Database',
      );
    }

    if (oldVersion < 11) {
      // Add employees table
      await _createEmployeesTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - employees table added',
        'Database',
      );
    }

    if (oldVersion < 12) {
      // Add currencies table
      await _createCurrenciesTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - currencies table added',
        'Database',
      );
    }

    if (oldVersion < 13) {
      // Add districts table
      await _createDistrictsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - districts table added',
        'Database',
      );
    }

    if (oldVersion < 14) {
      // Add governorates table
      await _createGovernoratesTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - governorates table added',
        'Database',
      );
    }

    if (oldVersion < 15) {
      // Add neighborhoods table
      await _createNeighborhoodsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - neighborhoods table added',
        'Database',
      );
    }

    if (oldVersion < 16) {
      // Add office_properties tables
      await _createOfficePropertiesListTable(db);
      await _createOfficePropertyDetailsTable(db);
      await _createOfficePropertyStatsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - office_properties tables added',
        'Database',
      );
    }

    if (oldVersion < 17) {
      // Update office_properties tables to simplified JSON structure
      // Drop old complex tables
      await db.execute('DROP TABLE IF EXISTS office_properties_list');
      await db.execute('DROP TABLE IF EXISTS office_property_details');

      // Create new simplified tables
      await db.execute('''
        CREATE TABLE office_properties_cache (
          id INTEGER PRIMARY KEY,
          data_json TEXT NOT NULL,
          cached_at TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE office_property_details_cache (
          property_id INTEGER PRIMARY KEY,
          details_json TEXT NOT NULL,
          cached_at TEXT NOT NULL
        )
      ''');

      AppLogger.success(
        'Database upgraded to version $newVersion - office_properties tables updated to JSON structure',
        'Database',
      );
    }

    if (oldVersion < 18) {
      // Add cache_metadata table for sophisticated cache management
      await _createCacheMetadataTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - cache_metadata table added',
        'Database',
      );
    }

    if (oldVersion < 19) {
      // Add plans table for caching subscription plans
      await _createPlansTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - plans table added',
        'Database',
      );
    }

    if (oldVersion < 20) {
      // Add office_info table for caching office information
      await _createOfficeInfoTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - office_info table added',
        'Database',
      );
    }

    if (oldVersion < 21) {
      // Add profile table for caching user profile
      await _createProfileTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - profile table added',
        'Database',
      );
    }

    if (oldVersion < 22) {
      // Add employee_stats table for caching employee statistics
      await _createEmployeeStatsTable(db);
      AppLogger.success(
        'Database upgraded to version $newVersion - employee_stats table added',
        'Database',
      );
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE slides (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL,
        link TEXT NOT NULL,
        position TEXT NOT NULL,
        "order" INTEGER NOT NULL,
        office_id INTEGER,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        views_count INTEGER NOT NULL,
        clicks_count INTEGER NOT NULL,
        is_active INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');

    await _createOfficesTable(db);
    await _createOfficeDetailsTable(db);
    await _createPropertyTypesTable(db);
    await _createPropertiesCacheTable(db);
    await _createPropertyDetailsTable(db);
    await _createPromotionsTable(db);
    await _createOfficePropertiesListTable(db);
    await _createOfficePropertyDetailsTable(db);
    await _createOfficePropertyStatsTable(db);
    await _createCacheMetadataTable(db);
    await _createPlansTable(db);
    await _createOfficeInfoTable(db);
    await _createProfileTable(db);
    await _createEmployeeStatsTable(db);
  }

  Future _createOfficesTable(Database db) async {
    await db.execute('''
      CREATE TABLE offices (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        owner_name TEXT,
        slug TEXT NOT NULL,
        logo TEXT,
        email TEXT,
        phone TEXT,
        mobile_phone TEXT,
        whatsapp_number TEXT,
        commercial_license TEXT,
        license_number TEXT,
        description TEXT,
        website TEXT,
        facebook TEXT,
        instagram TEXT,
        twitter TEXT,
        governorate_id INTEGER,
        district_id INTEGER,
        address TEXT,
        latitude TEXT,
        longitude TEXT,
        subscription_type TEXT,
        subscription_start_date TEXT,
        subscription_end_date TEXT,
        max_properties INTEGER,
        is_verified INTEGER NOT NULL,
        verification_date TEXT,
        rating REAL,
        total_ratings INTEGER,
        total_properties INTEGER,
        total_views INTEGER,
        status TEXT,
        created_at TEXT,
        updated_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createOfficeDetailsTable(Database db) async {
    await db.execute('''
      CREATE TABLE office_details (
        office_id INTEGER PRIMARY KEY,
        details_json TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createPropertyTypesTable(Database db) async {
    await db.execute('''
      CREATE TABLE property_types (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        description TEXT,
        "order" INTEGER NOT NULL,
        is_active INTEGER NOT NULL,
        created_by INTEGER,
        updated_by INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createPropertiesCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE properties_cache (
        id INTEGER PRIMARY KEY,
        data_json TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createPropertyDetailsTable(Database db) async {
    await db.execute('''
      CREATE TABLE property_details (
        property_id INTEGER PRIMARY KEY,
        details_json TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createPromotionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE promotions (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        image TEXT,
        type TEXT NOT NULL,
        discount_value REAL,
        office_id INTEGER,
        property_id INTEGER,
        plan_id INTEGER,
        start_date TEXT,
        end_date TEXT,
        terms TEXT,
        max_usage INTEGER,
        usage_count INTEGER NOT NULL,
        is_active INTEGER NOT NULL,
        status TEXT,
        created_at TEXT,
        updated_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createDashboardStatsTable(Database db) async {
    await db.execute('''
      CREATE TABLE dashboard_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        properties_total INTEGER NOT NULL,
        properties_available INTEGER NOT NULL,
        properties_reserved INTEGER NOT NULL,
        properties_sold INTEGER NOT NULL,
        properties_rented INTEGER NOT NULL,
        properties_this_month INTEGER NOT NULL,
        employees_total INTEGER NOT NULL,
        employees_active INTEGER NOT NULL,
        employees_inactive INTEGER NOT NULL,
        views_total TEXT NOT NULL,
        views_this_month TEXT NOT NULL,
        subscription_plan_name TEXT NOT NULL,
        subscription_status TEXT NOT NULL,
        subscription_end_date TEXT NOT NULL,
        subscription_days_remaining INTEGER NOT NULL,
        subscription_is_expiring_soon INTEGER NOT NULL,
        limits_max_properties INTEGER NOT NULL,
        limits_used_properties INTEGER NOT NULL,
        limits_can_add_more INTEGER NOT NULL,
        recent_properties TEXT NOT NULL,
        top_viewed_properties TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createEmployeesTable(Database db) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        whatsapp_number TEXT,
        address TEXT,
        user_type TEXT NOT NULL,
        role TEXT NOT NULL,
        office_id INTEGER NOT NULL,
        office_name TEXT NOT NULL,
        office_email TEXT NOT NULL,
        is_active INTEGER NOT NULL,
        avatar TEXT,
        created_at TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createCurrenciesTable(Database db) async {
    await db.execute('''
      CREATE TABLE currencies (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        name_en TEXT NOT NULL,
        code TEXT NOT NULL,
        symbol TEXT NOT NULL,
        exchange_rate TEXT NOT NULL,
        is_default INTEGER NOT NULL,
        decimal_places INTEGER NOT NULL,
        position TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createDistrictsTable(Database db) async {
    await db.execute('''
      CREATE TABLE districts (
        id INTEGER PRIMARY KEY,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        is_active INTEGER NOT NULL,
        governorate_id INTEGER NOT NULL,
        created_by INTEGER,
        updated_by INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createGovernoratesTable(Database db) async {
    await db.execute('''
      CREATE TABLE governorates (
        id INTEGER PRIMARY KEY,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        is_active INTEGER NOT NULL,
        created_by INTEGER,
        updated_by INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        districts_count INTEGER NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createNeighborhoodsTable(Database db) async {
    await db.execute('''
      CREATE TABLE neighborhoods (
        id INTEGER PRIMARY KEY,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        is_active INTEGER NOT NULL,
        district_id INTEGER NOT NULL,
        created_by INTEGER,
        updated_by INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createOfficePropertiesListTable(Database db) async {
    await db.execute('''
      CREATE TABLE office_properties_cache (
        id INTEGER PRIMARY KEY,
        data_json TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createOfficePropertyDetailsTable(Database db) async {
    await db.execute('''
      CREATE TABLE office_property_details_cache (
        property_id INTEGER PRIMARY KEY,
        details_json TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createOfficePropertyStatsTable(Database db) async {
    await db.execute('''
      CREATE TABLE office_property_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total INTEGER NOT NULL,
        available INTEGER NOT NULL,
        reserved INTEGER NOT NULL,
        sold INTEGER NOT NULL,
        rented INTEGER NOT NULL,
        this_month INTEGER NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createCacheMetadataTable(Database db) async {
    await db.execute('''
      CREATE TABLE cache_metadata (
        key TEXT PRIMARY KEY,
        last_updated INTEGER NOT NULL,
        expires_at INTEGER NOT NULL
      )
    ''');
  }

  Future _createPlansTable(Database db) async {
    await db.execute('''
      CREATE TABLE plans (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        slug TEXT NOT NULL,
        description TEXT NOT NULL,
        prices_json TEXT NOT NULL,
        limits_json TEXT NOT NULL,
        features_json TEXT NOT NULL,
        priority_level INTEGER NOT NULL,
        trial_days INTEGER NOT NULL,
        has_trial INTEGER NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createOfficeInfoTable(Database db) async {
    await db.execute('''
      CREATE TABLE office_info (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        whatsapp_number TEXT,
        website TEXT,
        facebook TEXT,
        instagram TEXT,
        twitter TEXT,
        description TEXT,
        address TEXT,
        logo TEXT,
        logo_url TEXT,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createProfileTable(Database db) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY,
        user_json TEXT NOT NULL,
        office_json TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future _createEmployeeStatsTable(Database db) async {
    await db.execute('''
      CREATE TABLE employee_stats (
        id INTEGER PRIMARY KEY,
        total INTEGER NOT NULL,
        active INTEGER NOT NULL,
        inactive INTEGER NOT NULL,
        can_add_more INTEGER NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> clearAllData() async {}

  Future close() async {
    final db = await database;
    db.close();
  }
}
