# Office Info Feature

Displays the authenticated office's profile information fetched from `office/office`.

## Structure

```
lib/features/office_info/
├── domain/
│   ├── entities/
│   │   └── office_info_entity.dart
│   ├── repositories/
│   │   └── office_info_repository.dart
│   └── usecases/
│       └── get_office_info_usecase.dart
├── data/
│   ├── models/
│   │   └── office_info_model.dart
│   ├── datasources/
│   │   └── office_info_remote_data_source.dart
│   └── repositories/
│       └── office_info_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── office_info_cubit.dart
    │   └── office_info_state.dart
    ├── screens/
    │   ├── office_info_screen.dart
    │   ├── office_info_mobile_layout.dart
    │   └── office_info_tablet_layout.dart
    └── widgets/
        ├── office_info_header.dart
        ├── office_info_contact_card.dart
        ├── office_info_social_card.dart
        ├── office_info_description_card.dart
        └── office_info_skeleton.dart
```

## API

- **Endpoint**: `GET office/office`
- **Auth**: Required (office token)
- **Response**: Single office object (no pagination)

## States

| State | Description |
|---|---|
| `OfficeInfoInitial` | Before first load |
| `OfficeInfoLoading` | Fetching data |
| `OfficeInfoSuccess` | Data loaded successfully |
| `OfficeInfoError` | Request failed |

## Usage

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const OfficeInfoScreen()),
);
```

## Notes

- Social links (`facebook`, `instagram`, `twitter`) are all nullable — the social card hides itself when none are set.
- `logo_url` is used for the avatar image with a fallback icon.
- Pull-to-refresh is supported on both layouts.
- Skeleton loading matches the actual card structure for each layout.
