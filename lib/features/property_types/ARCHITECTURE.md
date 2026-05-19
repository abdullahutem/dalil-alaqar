# Property Types Feature - Architecture Overview

## 🏗️ Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                    UI (Widgets)                        │ │
│  │  • PropertyTypesExampleScreen                          │ │
│  │  • PropertyTypeFilterChip                              │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              State Management (Cubit)                  │ │
│  │  • PropertyTypesCubit                                  │ │
│  │  • PropertyTypesState                                  │ │
│  │    - PropertyTypesInitial                              │ │
│  │    - PropertyTypesLoading                              │ │
│  │    - PropertyTypesSuccess                              │ │
│  │    - PropertyTypesError                                │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                   Use Cases                            │ │
│  │  • GetPropertyTypesUseCase                             │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Repository Interface                      │ │
│  │  • PropertyTypesRepository (abstract)                  │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                   Entities                             │ │
│  │  • PropertyTypeEntity                                  │ │
│  │  • PropertyTypesResponseEntity                         │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │           Repository Implementation                    │ │
│  │  • PropertyTypesRepositoryImpl                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                  Data Sources                          │ │
│  │  • PropertyTypesRemoteDataSource                       │ │
│  │  • PropertyTypesRemoteDataSourceImpl                   │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                    Models                              │ │
│  │  • PropertyTypeModel                                   │ │
│  │  • PropertyTypesResponseModel                          │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                    EXTERNAL LAYER                            │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                  API Consumer                          │ │
│  │  • ApiConsumer (from core)                             │ │
│  │  • EndPoints.propertyTypes                             │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                  Network                               │ │
│  │  • NetworkInfo (from core)                             │ │
│  │  • Internet connectivity check                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                           ↕                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                  Backend API                           │ │
│  │  GET: public/data/property-types                       │ │
│  │  https://dalil-alaqar.codebrains.net/api/             │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow

### 1. User Interaction → API Call

```
User taps button
    ↓
PropertyTypesExampleScreen
    ↓
PropertyTypesCubit.getPropertyTypes()
    ↓
emit(PropertyTypesLoading)
    ↓
GetPropertyTypesUseCase.call()
    ↓
PropertyTypesRepository.getPropertyTypes()
    ↓
Check NetworkInfo.isConnected
    ↓
PropertyTypesRemoteDataSource.getPropertyTypes()
    ↓
ApiConsumer.get(EndPoints.propertyTypes)
    ↓
HTTP GET Request to API
```

### 2. API Response → UI Update

```
API Response (JSON)
    ↓
PropertyTypesResponseModel.fromJson()
    ↓
Convert to PropertyTypesResponseEntity
    ↓
Return Either<Failure, PropertyTypesResponseEntity>
    ↓
GetPropertyTypesUseCase returns result
    ↓
PropertyTypesCubit processes result
    ↓
emit(PropertyTypesSuccess) or emit(PropertyTypesError)
    ↓
BlocBuilder rebuilds UI
    ↓
Display property types or error message
```

## 📊 State Management Flow

```
┌─────────────────────────────────────────────────────────┐
│                  PropertyTypesState                      │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Initial    │  │   Loading    │  │   Success    │
│              │  │              │  │              │
│ First state  │  │ API call in  │  │ Data loaded  │
│              │  │  progress    │  │ successfully │
└──────────────┘  └──────────────┘  └──────────────┘
                         │
                         ▼
                  ┌──────────────┐
                  │    Error     │
                  │              │
                  │ API call     │
                  │   failed     │
                  └──────────────┘
```

## 🔌 Dependency Injection Flow

```
┌─────────────────────────────────────────────────────────┐
│              Service Locator (GetIt)                     │
└─────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Data Source  │  │  Repository  │  │   Use Case   │
│              │  │              │  │              │
│ Lazy         │  │ Lazy         │  │ Lazy         │
│ Singleton    │  │ Singleton    │  │ Singleton    │
└──────────────┘  └──────────────┘  └──────────────┘
                                             │
                                             ▼
                                    ┌──────────────┐
                                    │    Cubit     │
                                    │              │
                                    │   Factory    │
                                    │ (new each    │
                                    │   time)      │
                                    └──────────────┘
```

## 🎯 Component Responsibilities

### Presentation Layer
- **PropertyTypesCubit**: Manages state and business logic
- **PropertyTypesState**: Represents different UI states
- **PropertyTypesExampleScreen**: Full-featured example screen
- **PropertyTypeFilterChip**: Reusable filter chip widget

### Domain Layer
- **GetPropertyTypesUseCase**: Encapsulates business logic
- **PropertyTypesRepository**: Abstract contract for data operations
- **PropertyTypeEntity**: Core business object
- **PropertyTypesResponseEntity**: Response wrapper

### Data Layer
- **PropertyTypesRepositoryImpl**: Implements repository contract
- **PropertyTypesRemoteDataSource**: Handles API communication
- **PropertyTypeModel**: Data transfer object with JSON serialization
- **PropertyTypesResponseModel**: Response model with JSON parsing

## 🔐 Error Handling Flow

```
API Call
    │
    ├─ No Internet Connection
    │       ↓
    │   NetworkInfo.isConnected = false
    │       ↓
    │   Return Left(Failure("لا يوجد اتصال بالإنترنت"))
    │       ↓
    │   emit(PropertyTypesError)
    │
    ├─ Server Error (4xx, 5xx)
    │       ↓
    │   ServerException thrown
    │       ↓
    │   Catch and convert to Failure
    │       ↓
    │   Return Left(Failure(errorMessage))
    │       ↓
    │   emit(PropertyTypesError)
    │
    └─ Success (200)
            ↓
        Parse JSON to Model
            ↓
        Convert to Entity
            ↓
        Return Right(Entity)
            ↓
        emit(PropertyTypesSuccess)
```

## 📦 File Dependencies

```
property_types_cubit.dart
    ├─ depends on → property_types_state.dart
    └─ depends on → get_property_types_usecase.dart
                        ├─ depends on → property_types_repository.dart
                        └─ depends on → property_types_response_entity.dart

property_types_repository_impl.dart
    ├─ implements → property_types_repository.dart
    ├─ depends on → property_types_remote_data_source.dart
    ├─ depends on → network_info.dart (core)
    └─ depends on → failure.dart (core)

property_types_remote_data_source.dart
    ├─ depends on → api_consumer.dart (core)
    ├─ depends on → end_points.dart (core)
    └─ depends on → property_types_response_model.dart

property_type_model.dart
    ├─ extends → property_type_entity.dart
    └─ provides → JSON serialization

property_types_response_model.dart
    ├─ extends → property_types_response_entity.dart
    └─ depends on → property_type_model.dart
```

## 🎨 UI Component Hierarchy

```
PropertyTypesExampleScreen
    │
    ├─ AppBar
    │   └─ Title: "أنواع العقارات"
    │
    └─ BlocBuilder<PropertyTypesCubit, PropertyTypesState>
        │
        ├─ if Loading
        │   └─ CircularProgressIndicator
        │
        ├─ if Error
        │   └─ Error Column
        │       ├─ Error Icon
        │       ├─ Error Message
        │       └─ Retry Button
        │
        └─ if Success
            └─ SingleChildScrollView
                ├─ Filter Chips Section
                │   └─ Wrap
                │       └─ PropertyTypeFilterChip (x12)
                │           ├─ Icon (emoji)
                │           └─ Name (Arabic)
                │
                └─ List View Section
                    └─ ListView.builder
                        └─ Card (x12)
                            └─ ListTile
                                ├─ Leading: Icon
                                ├─ Title: Name
                                ├─ Subtitle: Description
                                └─ Trailing: Status Badge
```

## 🔄 Lifecycle

### Cubit Lifecycle
```
1. PropertyTypesCubit created
2. Initial state: PropertyTypesInitial
3. getPropertyTypes() called
4. State changes to: PropertyTypesLoading
5. Use case executes
6. State changes to: PropertyTypesSuccess or PropertyTypesError
7. UI rebuilds based on new state
```

### Widget Lifecycle
```
1. PropertyTypesExampleScreen created
2. initState() called
3. context.read<PropertyTypesCubit>().getPropertyTypes()
4. BlocBuilder listens to state changes
5. build() called with current state
6. UI renders based on state
7. User interaction triggers new state changes
8. dispose() called when widget removed
```

## 🚀 Performance Considerations

1. **Lazy Singleton**: Data sources and repositories created once
2. **Factory Pattern**: New cubit instance per screen
3. **BlocBuilder**: Only rebuilds when state changes
4. **Efficient JSON Parsing**: Direct model conversion
5. **Network Check**: Prevents unnecessary API calls

## 📝 Best Practices Implemented

✅ Separation of Concerns  
✅ Dependency Inversion Principle  
✅ Single Responsibility Principle  
✅ Interface Segregation  
✅ Error Handling at every layer  
✅ Type Safety with Dart  
✅ Immutable State Objects  
✅ Reactive Programming with BLoC  
✅ Clean Code Principles  
✅ Comprehensive Documentation  

---

This architecture ensures maintainability, testability, and scalability of the Property Types feature.
