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
      version:
          17, // Updated office_properties tables to simplified JSON structure
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Verify the slides table exists and has the correct schema
        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='slides'",
        );

        if (tables.isEmpty) {
          print('⚠️ Slides table does not exist, creating it...');
          await _createDB(db, 6);
        } else {
          print('✅ Slides table exists');
        }

        // Verify the offices table exists
        final officesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='offices'",
        );

        if (officesTables.isEmpty) {
          print('⚠️ Offices table does not exist, creating it...');
          await _createOfficesTable(db);
        } else {
          print('✅ Offices table exists');
        }

        // Verify the office_details table exists
        final officeDetailsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='office_details'",
        );

        if (officeDetailsTables.isEmpty) {
          print('⚠️ Office details table does not exist, creating it...');
          await _createOfficeDetailsTable(db);
        } else {
          print('✅ Office details table exists');
        }

        // Verify the property_types table exists
        final propertyTypesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='property_types'",
        );

        if (propertyTypesTables.isEmpty) {
          print('⚠️ Property types table does not exist, creating it...');
          await _createPropertyTypesTable(db);
        } else {
          print('✅ Property types table exists');
        }

        // Verify the properties_cache table exists
        final propertiesCacheTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='properties_cache'",
        );

        if (propertiesCacheTables.isEmpty) {
          print('⚠️ Properties cache table does not exist, creating it...');
          await _createPropertiesCacheTable(db);
        } else {
          print('✅ Properties cache table exists');
        }

        // Verify the property_details table exists
        final propertyDetailsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='property_details'",
        );

        if (propertyDetailsTables.isEmpty) {
          print('⚠️ Property details table does not exist, creating it...');
          await _createPropertyDetailsTable(db);
        } else {
          print('✅ Property details table exists');
        }

        // Verify the promotions table exists
        final promotionsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='promotions'",
        );

        if (promotionsTables.isEmpty) {
          print('⚠️ Promotions table does not exist, creating it...');
          await _createPromotionsTable(db);
        } else {
          print('✅ Promotions table exists');
        }

        // Verify the dashboard_stats table exists
        final dashboardTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='dashboard_stats'",
        );

        if (dashboardTables.isEmpty) {
          print('⚠️ Dashboard stats table does not exist, creating it...');
          await _createDashboardStatsTable(db);
        } else {
          print('✅ Dashboard stats table exists');
        }

        // Verify the employees table exists
        final employeesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='employees'",
        );

        if (employeesTables.isEmpty) {
          print('⚠️ Employees table does not exist, creating it...');
          await _createEmployeesTable(db);
        } else {
          print('✅ Employees table exists');
        }

        // Verify the currencies table exists
        final currenciesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='currencies'",
        );

        if (currenciesTables.isEmpty) {
          print('⚠️ Currencies table does not exist, creating it...');
          await _createCurrenciesTable(db);
        } else {
          print('✅ Currencies table exists');
        }

        // Verify the districts table exists
        final districtsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='districts'",
        );

        if (districtsTables.isEmpty) {
          print('⚠️ Districts table does not exist, creating it...');
          await _createDistrictsTable(db);
        } else {
          print('✅ Districts table exists');
        }

        // Verify the governorates table exists
        final governoratesTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='governorates'",
        );

        if (governoratesTables.isEmpty) {
          print('⚠️ Governorates table does not exist, creating it...');
          await _createGovernoratesTable(db);
        } else {
          print('✅ Governorates table exists');
        }

        // Verify the neighborhoods table exists
        final neighborhoodsTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='neighborhoods'",
        );

        if (neighborhoodsTables.isEmpty) {
          print('⚠️ Neighborhoods table does not exist, creating it...');
          await _createNeighborhoodsTable(db);
        } else {
          print('✅ Neighborhoods table exists');
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

      print(
        '✅ Database upgraded to version $newVersion - office_id is now nullable',
      );
    }

    if (oldVersion < 4) {
      // Add offices table
      await _createOfficesTable(db);
      print('✅ Database upgraded to version $newVersion - offices table added');
    }

    if (oldVersion < 5) {
      // Add office_details table
      await _createOfficeDetailsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - office_details table added',
      );
    }

    if (oldVersion < 6) {
      // Add property_types table
      await _createPropertyTypesTable(db);
      print(
        '✅ Database upgraded to version $newVersion - property_types table added',
      );
    }

    if (oldVersion < 7) {
      // Add properties_cache table
      await _createPropertiesCacheTable(db);
      print(
        '✅ Database upgraded to version $newVersion - properties_cache table added',
      );
    }

    if (oldVersion < 8) {
      // Add property_details table
      await _createPropertyDetailsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - property_details table added',
      );
    }

    if (oldVersion < 9) {
      // Add promotions table
      await _createPromotionsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - promotions table added',
      );
    }

    if (oldVersion < 10) {
      // Add dashboard_stats table
      await _createDashboardStatsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - dashboard_stats table added',
      );
    }

    if (oldVersion < 11) {
      // Add employees table
      await _createEmployeesTable(db);
      print(
        '✅ Database upgraded to version $newVersion - employees table added',
      );
    }

    if (oldVersion < 12) {
      // Add currencies table
      await _createCurrenciesTable(db);
      print(
        '✅ Database upgraded to version $newVersion - currencies table added',
      );
    }

    if (oldVersion < 13) {
      // Add districts table
      await _createDistrictsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - districts table added',
      );
    }

    if (oldVersion < 14) {
      // Add governorates table
      await _createGovernoratesTable(db);
      print(
        '✅ Database upgraded to version $newVersion - governorates table added',
      );
    }

    if (oldVersion < 15) {
      // Add neighborhoods table
      await _createNeighborhoodsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - neighborhoods table added',
      );
    }

    if (oldVersion < 16) {
      // Add office_properties tables
      await _createOfficePropertiesListTable(db);
      await _createOfficePropertyDetailsTable(db);
      await _createOfficePropertyStatsTable(db);
      print(
        '✅ Database upgraded to version $newVersion - office_properties tables added',
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

      print(
        '✅ Database upgraded to version $newVersion - office_properties tables updated to JSON structure',
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

  Future<void> clearAllData() async {}

  Future close() async {
    final db = await database;
    db.close();
  }
}
