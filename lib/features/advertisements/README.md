# Slider Feature

A dynamic hero slider feature built with Clean Architecture principles for the Panorama Hotel App.

## Quick Usage

```dart
import 'package:dalil_alaqar/features/slider/presentation/widgets/slider_widget.dart';

// Mobile
SliderWidget()

// Tablet
SliderWidget(isTablet: true)
```

## Features

✅ Dynamic content from API  
✅ Bilingual support (Arabic/English)  
✅ Responsive design (mobile/tablet)  
✅ Image caching  
✅ Loading & error states  
✅ Swipeable slides with indicators  
✅ Retry functionality  

## Architecture

```
slider/
├── data/           # Data layer (API, models, repositories)
├── domain/         # Business logic (entities, use cases)
└── presentation/   # UI layer (widgets, state management)
```

## API Endpoint

```
GET /api/v1/mobile/hotel/slider
```

## Documentation

- **Full Documentation**: See `/SLIDER_FEATURE_DOCUMENTATION.md`
- **Integration Guide**: See `/SLIDER_INTEGRATION_GUIDE.md`

## Dependencies

- `flutter_bloc` - State management
- `cached_network_image` - Image caching
- `dio` - HTTP client
- `dartz` - Functional programming
