# Quick Feature Generation Prompt

Copy and paste this template, then fill in the bracketed sections:

---

## 🚀 Quick Prompt

```
Create a new feature called "[FEATURE_NAME]" for the dalil_alaqar Flutter app following clean architecture.

### API Details
- Endpoint: [ENDPOINT_PATH]
- Method: [GET/POST/PUT/DELETE]
- Response:
```json
[PASTE_FULL_API_RESPONSE_HERE]
```

### Requirements
1. **Domain Layer**: Create entities, repository interface, and use cases
2. **Data Layer**: Create models with fromJson/toJson, remote data source, and repository implementation
3. **Presentation Layer**: 
   - Cubit with states (Initial, Loading, Success, Error)
   - Factory method: `[FeatureName]Cubit.create()`
   - Three screens: main screen, mobile layout, tablet layout
   - Card widgets (regular and compact if needed for home screen)
4. **Responsive Design**:
   - Mobile: Vertical list, full-width cards
   - Tablet: 2-column grid, max-width 1200px
5. **Features**: Pagination, pull-to-refresh, error handling, empty states
6. **Home Integration** (if needed): Horizontal scrolling section with compact cards

### Structure Reference
Follow the exact structure of `lib/features/properties/`:
- Domain: entities, repositories, usecases
- Data: models, datasources, repositories
- Presentation: cubit, screens (3 files), widgets

### Important Notes
- Handle nullable fields (check API response carefully)
- Add endpoint to `lib/core/databases/api/end_points.dart`
- Use Arabic text for UI
- Implement image caching if images are present
- Format numbers appropriately
- Ensure no diagnostic errors
- **Support dark and light modes** (use Theme.of(context) for colors)
- Test in both light and dark themes
- Avoid hardcoded colors

Please create all files following this structure.
```

---

## 📋 Checklist After Generation

```
Feature: [FEATURE_NAME]
Date: [DATE]

Domain Layer:
[ ] entities/[feature]_entity.dart
[ ] entities/[feature]_response_entity.dart
[ ] repositories/[feature]_repository.dart
[ ] usecases/get_[feature]_usecase.dart

Data Layer:
[ ] models/[feature]_model.dart
[ ] models/[feature]_response_model.dart
[ ] datasources/[feature]_remote_data_source.dart
[ ] repositories/[feature]_repository_impl.dart

Presentation Layer:
[ ] cubit/[feature]_cubit.dart (with .create() factory)
[ ] cubit/[feature]_state.dart
[ ] screens/[feature]_screen.dart
[ ] screens/[feature]_mobile_layout.dart
[ ] screens/[feature]_tablet_layout.dart
[ ] widgets/[feature]_card.dart
[ ] widgets/[feature]_card_compact.dart (if needed)

Integration:
[ ] Endpoint added to end_points.dart
[ ] Home screen section (if needed)
[ ] Navigation implemented
[ ] README.md created

Quality:
[ ] No diagnostic errors
[ ] Null safety handled
[ ] Error handling implemented
[ ] Loading states work
[ ] Empty states work
[ ] Pagination works (if needed)
[ ] Pull-to-refresh works
[ ] Images cached (if applicable)
[ ] Dark mode tested
[ ] Light mode tested
[ ] Theme colors used (no hardcoded colors)
```

---

## 🎯 Real Example

```
Create a new feature called "Offices" for the dalil_alaqar Flutter app following clean architecture.

### API Details
- Endpoint: public/offices
- Method: GET
- Response:
```json
{
  "success": true,
  "message": "تم جلب المكاتب بنجاح",
  "data": [
    {
      "id": 1,
      "name": "مكتب دار السلام العقاري",
      "slug": "mktb-dar-alslam-alaakary",
      "phone": "+964 770 123 4567",
      "email": "info@daralsalam.iq",
      "logo": "offices/office-1-logo.jpg",
      "properties_count": 45,
      "rating": 4.5,
      "governorate": {
        "id": 1,
        "name_ar": "بغداد"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 20,
    "total": 95
  }
}
```

### Requirements
[Same as template above]

Please create all files following this structure.
```

---

## 💡 Pro Tips

1. **Always provide the complete API response** - Don't truncate it
2. **Check for nullable fields** - Look for `null` values in the response
3. **Specify home integration** - If you want it on the home screen
4. **Reference similar features** - "Similar to properties feature"
5. **Be specific about UI** - Mention any special design requirements

---

## 🔗 Related Files

- Full template: `FEATURE_GENERATION_PROMPT.md`
- Properties reference: `lib/features/properties/`
- Advertisements reference: `lib/features/advertisements/`
- Home integration: `lib/features/home/presentation/widgets/`
