# Categories Feature - Architecture Overview

## 🏗️ Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  CategoriesScreen (UI)                                 │ │
│  │  └── CategoryCard (Widget)                             │ │
│  │                                                         │ │
│  │  CategoriesCubit (State Management)                    │ │
│  │  ├── CategoriesInitial                                 │ │
│  │  ├── CategoriesLoading                                 │ │
│  │  ├── CategoriesLoaded                                  │ │
│  │  └── CategoriesError                                   │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  GetCategories (Use Case)                              │ │
│  │                                                         │ │
│  │  CategoriesRepository (Interface)                      │ │
│  │                                                         │ │
│  │  Entities:                                             │ │
│  │  ├── CategoriesEntity                                  │ │
│  │  ├── CategoryEntity                                    │ │
│  │  └── CategoryChildEntity                               │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                        DATA LAYER                            │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  CategoriesRepositoryImpl                              │ │
│  │                                                         │ │
│  │  CategoriesRemoteDataSource                            │ │
│  │  └── DioConsumer (API Client)                          │ │
│  │                                                         │ │
│  │  Models:                                               │ │
│  │  ├── CategoriesModel                                   │ │
│  │  ├── CategoryModel                                     │ │
│  │  └── CategoryChildModel                                │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                      EXTERNAL SERVICES                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  API: https://vwline.com/api/v1/menu/categories       │ │
│  │  Network: DataConnectionChecker                        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow

### Fetching Categories

```
User Action (Tap Button)
        ↓
CategoriesScreen
        ↓
CategoriesCubit.fetchCategories()
        ↓
emit(CategoriesLoading)
        ↓
GetCategories.call()
        ↓
CategoriesRepository.getCategories()
        ↓
Check Network Connection
        ↓
CategoriesRemoteDataSource.getCategories()
        ↓
DioConsumer.get(endpoint)
        ↓
API Response
        ↓
Parse to CategoriesModel
        ↓
Convert to CategoriesEntity
        ↓
Return Either<Failure, CategoriesEntity>
        ↓
CategoriesCubit receives result
        ↓
emit(CategoriesLoaded) or emit(CategoriesError)
        ↓
UI Updates
```

## 📦 Dependency Injection Flow

```
CategoriesInjection
        │
        ├── provideCategoriesCubit()
        │   └── requires: GetCategories
        │
        ├── provideGetCategories()
        │   └── requires: CategoriesRepository
        │
        ├── provideCategoriesRepository()
        │   ├── requires: CategoriesRemoteDataSource
        │   └── requires: NetworkInfo
        │
        ├── provideCategoriesRemoteDataSource()
        │   └── requires: DioConsumer
        │
        └── provideNetworkInfo()
            └── requires: DataConnectionChecker
```

## 🎯 Component Responsibilities

### Presentation Layer

**CategoriesScreen**
- Displays UI
- Listens to state changes
- Handles user interactions
- Shows loading/error/success states

**CategoryCard**
- Reusable widget
- Displays single category
- Handles expansion for children
- Shows subcategories as chips

**CategoriesCubit**
- Manages state
- Calls use cases
- Emits state changes
- Handles business logic

### Domain Layer

**GetCategories (Use Case)**
- Single responsibility: fetch categories
- Calls repository
- Returns Either<Failure, CategoriesEntity>

**CategoriesRepository (Interface)**
- Defines contract
- Abstracts data source
- Used by use cases

**Entities**
- Pure business objects
- No dependencies
- Immutable data structures

### Data Layer

**CategoriesRepositoryImpl**
- Implements repository interface
- Checks network connectivity
- Handles errors
- Converts models to entities

**CategoriesRemoteDataSource**
- Makes API calls
- Handles HTTP requests
- Returns models

**Models**
- Extends entities
- JSON serialization
- Data transformation

## 🔐 Error Handling Flow

```
API Call
    ↓
Try-Catch Block
    ↓
Success? ──Yes──→ Parse Response ──→ Return Right(data)
    │
    No
    ↓
Network Error? ──Yes──→ Return Left(Failure("No internet"))
    │
    No
    ↓
Server Error? ──Yes──→ Return Left(Failure(errorMessage))
    │
    No
    ↓
Parse Error? ──Yes──→ Return Left(Failure("Invalid data"))
    ↓
Cubit Receives Result
    ↓
Success? ──Yes──→ emit(CategoriesLoaded)
    │
    No
    ↓
emit(CategoriesError)
    ↓
UI Shows Error + Retry Button
```

## 🎨 State Management Flow

```
Initial State
    ↓
CategoriesInitial
    ↓
User Triggers Fetch
    ↓
CategoriesLoading
    ↓
API Call
    ↓
    ├── Success ──→ CategoriesLoaded(categories)
    │                   ↓
    │               Display List
    │
    └── Failure ──→ CategoriesError(message)
                        ↓
                    Show Error + Retry
                        ↓
                    User Taps Retry
                        ↓
                    Back to CategoriesLoading
```

## 📱 UI Component Hierarchy

```
CategoriesScreen
    │
    ├── AppBar
    │   └── Title: "الفئات"
    │
    └── BlocBuilder<CategoriesCubit, CategoriesState>
        │
        ├── CategoriesLoading
        │   └── CircularProgressIndicator
        │
        ├── CategoriesError
        │   ├── Error Text
        │   └── Retry Button
        │
        └── CategoriesLoaded
            └── ListView.builder
                └── CategoryCard (for each category)
                    ├── Card
                    │   └── ExpansionTile
                    │       ├── Title (name/name_ar)
                    │       ├── Subtitle (children count)
                    │       └── Children
                    │           └── Wrap
                    │               └── Chip (for each child)
```

## 🔌 API Integration

```
EndPoints.categories
    ↓
"menu/categories"
    ↓
Full URL: "https://vwline.com/api/v1/menu/categories"
    ↓
GET Request
    ↓
Headers:
    - Accept: application/json
    - Content-Type: application/json
    ↓
Response: JSON
    ↓
Parse to CategoriesModel
    ↓
Convert to CategoriesEntity
```

## 🧪 Testing Strategy (Future)

```
Unit Tests
    ├── Domain Layer
    │   ├── GetCategories use case
    │   └── Entity validation
    │
    ├── Data Layer
    │   ├── Repository implementation
    │   ├── Remote data source
    │   └── Model serialization
    │
    └── Presentation Layer
        ├── Cubit state transitions
        └── State emissions

Widget Tests
    ├── CategoriesScreen
    ├── CategoryCard
    └── UI interactions

Integration Tests
    ├── Full flow testing
    └── API integration
```

## 📊 Performance Considerations

1. **Lazy Loading**: Categories loaded on demand
2. **State Management**: Efficient state updates with Cubit
3. **Widget Rebuilds**: Only affected widgets rebuild
4. **Network Caching**: Can be added for offline support
5. **Image Loading**: Can be optimized with cached_network_image

## 🔒 Security Considerations

1. **API Authentication**: Can be added via interceptors
2. **Data Validation**: Models validate data structure
3. **Error Messages**: User-friendly, no sensitive info
4. **Network Security**: HTTPS enforced
5. **Input Sanitization**: Handled by models

## 🚀 Scalability

The architecture supports:
- ✅ Adding new features without modifying existing code
- ✅ Swapping data sources (API, local DB, cache)
- ✅ Adding new use cases
- ✅ Multiple UI implementations
- ✅ Easy testing at all layers
- ✅ Team collaboration with clear boundaries

---

This architecture ensures maintainability, testability, and scalability for the categories feature.
