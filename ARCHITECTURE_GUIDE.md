# Architecture Guide - dalil_alaqar Project

## Overview
This project follows **Clean Architecture** principles with clear separation between domain, data, and presentation layers.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, State Management)        │
│  - Screens (Mobile/Tablet Layouts)      │
│  - Widgets (Cards, Sections)            │
│  - Cubit (State Management)             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Domain Layer                  │
│     (Business Logic, Entities)          │
│  - Entities (Pure Dart Objects)         │
│  - Repository Interfaces                │
│  - Use Cases (Business Logic)           │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Data Layer                   │
│  (Data Sources, Models, Repositories)   │
│  - Models (JSON Serialization)          │
│  - Data Sources (API, Local DB)         │
│  - Repository Implementation            │
└─────────────────────────────────────────┘
```

## Feature Structure

Every feature follows this structure:

```
lib/features/[feature_name]/
├── domain/
│   ├── entities/              # Pure business objects
│   ├── repositories/          # Abstract interfaces
│   └── usecases/             # Business logic
├── data/
│   ├── models/               # Data transfer objects
│   ├── datasources/          # API/DB access
│   └── repositories/         # Concrete implementations
└── presentation/
    ├── cubit/                # State management
    ├── screens/              # UI screens
    └── widgets/              # Reusable UI components
```

## Layer Responsibilities

### 1. Domain Layer (Business Logic)

**Purpose**: Contains business logic and rules, independent of frameworks

**Components**:
- **Entities**: Pure Dart classes representing business objects
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-responsibility business logic operations

**Rules**:
- ✅ No dependencies on other layers
- ✅ Pure Dart code only
- ✅ No Flutter imports
- ✅ No external packages (except dartz for Either)
- ❌ No JSON parsing
- ❌ No API calls
- ❌ No UI code

**Example**:
```dart
// Entity
class PropertyEntity {
  final int id;
  final String title;
  final String price;
  // ... pure business fields
}

// Repository Interface
abstract class PropertiesRepository {
  Future<Either<Failure, PropertiesResponseEntity>> getProperties();
}

// Use Case
class GetPropertiesUseCase {
  final PropertiesRepository repository;
  
  Future<Either<Failure, PropertiesResponseEntity>> call() {
    return repository.getProperties();
  }
}
```

### 2. Data Layer (Data Management)

**Purpose**: Handles data from various sources (API, database, cache)

**Components**:
- **Models**: Extend entities, add JSON serialization
- **Data Sources**: Handle API calls, database operations
- **Repository Implementation**: Implements domain repository interfaces

**Rules**:
- ✅ Depends on domain layer
- ✅ Handles JSON parsing
- ✅ Manages API calls
- ✅ Handles caching
- ✅ Error handling
- ❌ No UI code
- ❌ No business logic

**Example**:
```dart
// Model
class PropertyModel extends PropertyEntity {
  PropertyModel({required super.id, required super.title});
  
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

// Data Source
class PropertiesRemoteDataSource {
  Future<PropertiesResponseModel> getProperties() async {
    final response = await apiConsumer.get('public/properties');
    return PropertiesResponseModel.fromJson(response);
  }
}

// Repository Implementation
class PropertiesRepositoryImpl implements PropertiesRepository {
  @override
  Future<Either<Failure, PropertiesResponseEntity>> getProperties() async {
    try {
      final result = await remoteDataSource.getProperties();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### 3. Presentation Layer (UI)

**Purpose**: Displays data and handles user interactions

**Components**:
- **Cubit**: State management using BLoC pattern
- **States**: Different UI states (Loading, Success, Error)
- **Screens**: Main screen with layout routing
- **Layouts**: Mobile and tablet specific layouts
- **Widgets**: Reusable UI components

**Rules**:
- ✅ Depends on domain layer (entities, use cases)
- ✅ Uses Flutter widgets
- ✅ Handles user input
- ✅ Displays data
- ❌ No direct API calls
- ❌ No JSON parsing
- ❌ No business logic

**Example**:
```dart
// Cubit
class PropertiesCubit extends Cubit<PropertiesState> {
  final GetPropertiesUseCase getPropertiesUseCase;
  
  Future<void> getProperties() async {
    emit(PropertiesLoading());
    final result = await getPropertiesUseCase();
    result.fold(
      (failure) => emit(PropertiesError(failure.message)),
      (data) => emit(PropertiesSuccess(data)),
    );
  }
}

// Screen
class PropertiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return PropertiesTabletLayout();
        } else {
          return PropertiesMobileLayout();
        }
      },
    );
  }
}
```

## Responsive Design Pattern

### Screen Structure
```
[Feature]Screen (Main)
├── LayoutBuilder
│   ├── if width < 600px → [Feature]MobileLayout
│   └── if width ≥ 600px → [Feature]TabletLayout
```

### Mobile Layout
- Vertical scrolling list
- Full-width cards
- 16px padding
- Standard font sizes
- Single column

### Tablet Layout
- Grid layout (2 columns)
- Centered content (max-width: 1200px)
- 24px padding
- Larger font sizes
- Better use of space

## State Management Pattern

### Cubit States
```dart
abstract class [Feature]State {}

class [Feature]Initial extends [Feature]State {}

class [Feature]Loading extends [Feature]State {}

class [Feature]Success extends [Feature]State {
  final [Feature]ResponseEntity data;
}

class [Feature]Error extends [Feature]State {
  final String message;
}

// For pagination
class [Feature]LoadMoreError extends [Feature]State {
  final [Feature]ResponseEntity data;
  final String message;
}
```

### Cubit Factory Pattern
```dart
class [Feature]Cubit extends Cubit<[Feature]State> {
  final Get[Feature]UseCase useCase;
  
  [Feature]Cubit({required this.useCase}) : super([Feature]Initial());
  
  // Factory method for easy instantiation
  factory [Feature]Cubit.create() {
    final apiConsumer = DioConsumer(dio: Dio());
    final dataSource = [Feature]RemoteDataSourceImpl(apiConsumer: apiConsumer);
    final networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = [Feature]RepositoryImpl(
      remoteDataSource: dataSource,
      networkInfo: networkInfo,
    );
    final useCase = Get[Feature]UseCase(repository: repository);
    
    return [Feature]Cubit(useCase: useCase);
  }
}
```

## Naming Conventions

### Files
- Snake case: `property_card.dart`, `properties_screen.dart`
- Descriptive: `properties_mobile_layout.dart`

### Classes
- Pascal case: `PropertyCard`, `PropertiesScreen`
- Suffix with type: `PropertyEntity`, `PropertyModel`, `PropertiesCubit`

### Variables
- Camel case: `propertyId`, `propertiesList`
- Descriptive: `isLoadingMore`, `currentPage`

### Folders
- Lowercase: `domain`, `data`, `presentation`
- Plural for collections: `entities`, `models`, `screens`

## Common Patterns

### 1. Pagination
```dart
// In Cubit
int _currentPage = 1;
List<Entity> _allItems = [];

Future<void> loadMore() async {
  if (_currentPage >= _meta.lastPage) return;
  _currentPage++;
  // Fetch and append
}
```

### 2. Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    await cubit.getItems(refresh: true);
  },
  child: ListView(...),
)
```

### 3. Error Handling
```dart
try {
  final result = await dataSource.getData();
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message));
} on DioException catch (e) {
  return Left(ServerFailure(message: e.message));
} catch (e) {
  return Left(ServerFailure(message: e.toString()));
}
```

### 4. Image Caching
```dart
ImageCacheConfig.cachedImage(
  imageUrl: imageUrl.startsWith('http')
      ? imageUrl
      : 'https://dalil-alaqar.codebrains.net/storage/$imageUrl',
  fit: BoxFit.cover,
)
```

## Best Practices

### ✅ Do's
- Follow clean architecture layers
- Separate mobile and tablet layouts
- Use factory methods in cubits
- Handle nullable fields properly
- Implement error states
- Add loading states
- Include empty states
- Use pull-to-refresh
- Cache images
- Format numbers appropriately
- Use Arabic text in UI
- Add proper documentation

### ❌ Don'ts
- Mix layer responsibilities
- Put business logic in UI
- Parse JSON in domain layer
- Make API calls in presentation
- Ignore null safety
- Skip error handling
- Forget loading states
- Hardcode values
- Ignore responsive design
- Skip documentation

## Testing Strategy

### Unit Tests
- Domain layer (entities, use cases)
- Data layer (models, repositories)

### Widget Tests
- Individual widgets
- Screens
- Layouts

### Integration Tests
- Full feature flows
- API integration
- Navigation

## Performance Optimization

1. **Image Caching**: Use `ImageCacheConfig`
2. **State Preservation**: Use `AutomaticKeepAliveClientMixin`
3. **Lazy Loading**: Implement pagination
4. **Efficient Scrolling**: Use `ListView.builder`
5. **Minimal Rebuilds**: Use `BlocBuilder` selectively

## Theme System (Dark/Light Mode)

### Overview
The app supports both light and dark themes with seamless switching.

### Theme Structure
```dart
// Theme Cubit
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: false));
  
  void toggleTheme() {
    emit(ThemeState(isDarkMode: !state.isDarkMode));
  }
}

// In main.dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
)
```

### Color System

**AppColors Constants:**
```dart
// Light Mode
static const Color lightBackground = Color(0xFFF8F9FA);
static const Color lightSurface = Color(0xFFFFFFFF);
static const Color lightText = Color(0xFF1A1A1A);
static const Color lightTextSecondary = Color(0xFF6B7280);

// Dark Mode
static const Color darkBackground = Color(0xFF121212);
static const Color darkSurface = Color(0xFF1E1E1E);
static const Color darkText = Color(0xFFFFFFFF);
static const Color darkTextSecondary = Color(0xFFB3B3B3);

// Common (works in both)
static const Color primary = Color(0xFF038086);
static const Color error = Color(0xFFCF6679);
static const Color success = Color(0xFF4CAF50);
```

### Best Practices for Theme Support

#### ✅ Do's

**1. Use Theme Colors:**
```dart
// Background
Container(
  color: Theme.of(context).scaffoldBackgroundColor,
)

// Card
Card(
  color: Theme.of(context).cardColor,
)

// Text
Text(
  'Hello',
  style: Theme.of(context).textTheme.bodyLarge,
)

// Divider
Divider(
  color: Theme.of(context).dividerColor,
)
```

**2. Use Theme-Aware Grey:**
```dart
// For secondary text
Text(
  'Secondary',
  style: TextStyle(
    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
  ),
)

// Or use grey with awareness
Colors.grey[600]  // Adapts reasonably to both themes
```

**3. Use Opacity for Overlays:**
```dart
// Works in both themes
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.black.withOpacity(0.3),
        Colors.black.withOpacity(0.6),
      ],
    ),
  ),
)
```

**4. Use Theme for Icons:**
```dart
Icon(
  Icons.home,
  color: Theme.of(context).iconTheme.color,
)
```

#### ❌ Don'ts

**1. Avoid Hardcoded Colors:**
```dart
// ❌ Bad
Container(color: Colors.white)
Text('Hello', style: TextStyle(color: Colors.black))

// ✅ Good
Container(color: Theme.of(context).cardColor)
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
```

**2. Avoid Assuming Background:**
```dart
// ❌ Bad - Assumes white background
Container(
  color: Colors.white,
  child: Text('Text', style: TextStyle(color: Colors.black)),
)

// ✅ Good - Theme-aware
Container(
  color: Theme.of(context).cardColor,
  child: Text(
    'Text',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)
```

**3. Avoid Fixed Shadows:**
```dart
// ❌ Bad - Too dark for dark mode
BoxShadow(
  color: Colors.black.withOpacity(0.5),
  blurRadius: 10,
)

// ✅ Good - Subtle for both themes
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

### Common Patterns

**1. Card with Theme Support:**
```dart
Card(
  color: Theme.of(context).cardColor,
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8),
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  ),
)
```

**2. Container with Background:**
```dart
Container(
  color: Theme.of(context).scaffoldBackgroundColor,
  child: Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        color: Theme.of(context).cardColor,
        child: Text(
          'Content',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ],
  ),
)
```

**3. Button with Theme:**
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  child: Text('Button'),
)
```

**4. Icon with Theme:**
```dart
Icon(
  Icons.home_outlined,
  color: Theme.of(context).iconTheme.color,
  size: 24,
)
```

### Testing Themes

**1. Toggle Theme:**
```dart
// In any widget with context
context.read<ThemeCubit>().toggleTheme();
```

**2. Check Current Theme:**
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
```

**3. Testing Checklist:**
- [ ] All screens tested in light mode
- [ ] All screens tested in dark mode
- [ ] Text is readable in both modes
- [ ] Cards are visible in both modes
- [ ] Icons are visible in both modes
- [ ] Buttons work in both modes
- [ ] Images display correctly in both modes
- [ ] Shadows are appropriate in both modes
- [ ] No hardcoded colors used
- [ ] Theme toggle works smoothly

### Theme-Aware Widgets

**Example: Property Card**
```dart
class PropertyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      // Uses theme card color
      color: Theme.of(context).cardColor,
      elevation: 2,
      child: Column(
        children: [
          // Image (works in both themes)
          CachedNetworkImage(imageUrl),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Title uses theme text style
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                
                // Secondary text with opacity
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                
                // Price with primary color (works in both)
                Text(
                  price,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## References

- Properties Feature: `lib/features/properties/`
- Advertisements Feature: `lib/features/advertisements/`
- Home Screen: `lib/features/home/`
- Core Utilities: `lib/core/`
