# Add Employee Feature Implementation

## Overview
This document describes the implementation of the "Add Employee" feature for the Dalil Alaqar application. The feature allows office managers to add new employees with proper role assignment (manager or employee).

## API Endpoint
- **Endpoint**: `office/employees`
- **Method**: POST
- **Body**:
```json
{
  "name": "مدير المكتب",
  "email": "manager@test.com",
  "password": "password",
  "phone_number": "777666555",
  "whatsapp_number": "777666555",
  "address": "صنعاء، اليمن",
  "role": "manager" // or "employee"
}
```

## Architecture

The implementation follows Clean Architecture principles with three layers:

### 1. Data Layer
**Location**: `lib/features/employee/data/`

#### Models
- **`add_employee_request_model.dart`**: Request model for adding an employee
- **`add_employee_response_model.dart`**: Response model containing success status, message, and employee data

#### Data Sources
- **`employees_remote_data_source.dart`**: Updated with `addEmployee()` method

#### Repositories
- **`employees_repository_impl.dart`**: Updated with implementation of `addEmployee()` method

### 2. Domain Layer
**Location**: `lib/features/employee/domain/`

#### Entities
- **`add_employee_response_entity.dart`**: Domain entity for add employee response

#### Use Cases
- **`add_employee_usecase.dart`**: Use case for adding an employee

#### Repositories
- **`employees_repository.dart`**: Updated with abstract `addEmployee()` method

### 3. Presentation Layer
**Location**: `lib/features/employee/presentation/`

#### State Management (Cubit)
- **`add_employee_cubit.dart`**: Manages the state for adding employees
- **`add_employee_state.dart`**: Defines states: Initial, Loading, Success, Error

#### Screens (Responsive Design)
1. **`add_employees_screen.dart`**: Main screen with responsive layout switcher
2. **`add_employees_mobile_layout.dart`**: Mobile layout (< 600px width)
3. **`add_employees_tablet_layout.dart`**: Tablet/Desktop layout (≥ 600px width)

## Features

### Form Fields
1. **Name** - Required text field
2. **Email** - Required with email validation
3. **Password** - Required, minimum 6 characters, with visibility toggle
4. **Phone Number** - Required
5. **WhatsApp Number** - Required
6. **Address** - Required, multiline text field
7. **Role** - Toggle between "Employee" and "Manager"

### Validation
- All fields are required
- Email format validation
- Password minimum length (6 characters)
- Real-time error messages in both Arabic and English

### UI/UX Features
- **Dark/Light Mode Support**: Fully themed for both modes
- **Responsive Design**: 
  - Mobile: Single column layout
  - Tablet/Desktop: Two-column layout with centered card
- **Loading States**: Shows loading indicator during submission
- **Success/Error Feedback**: SnackBar notifications
- **Auto-navigation**: Returns to employee list after successful addition
- **Form Reset**: Clears all fields after successful submission
- **Auto-refresh**: Refreshes employee list when returning from add screen

### Theme Integration
- Uses `AppColors` for consistent theming
- Supports dark mode with appropriate color schemes
- Rounded corners and modern design
- Proper spacing and padding

## Localization

Added the following translation keys to `app_localizations.dart`:

### English
- `add_employee`: "Add Employee"
- `name`: "Name"
- `enter_name`: "Enter name"
- `email`: "Email"
- `enter_email`: "Enter email"
- `password`: "Password"
- `enter_password`: "Enter password"
- `phone_number`: "Phone Number"
- `enter_phone`: "Enter phone number"
- `whatsapp_number`: "WhatsApp Number"
- `enter_whatsapp`: "Enter WhatsApp number"
- `address`: "Address"
- `enter_address`: "Enter address"
- `role`: "Role"
- `employee`: "Employee"
- `manager`: "Manager"

### Arabic
- `add_employee`: "إضافة موظف"
- `name`: "الاسم"
- `enter_name`: "أدخل الاسم"
- `email`: "البريد الإلكتروني"
- `enter_email`: "أدخل البريد الإلكتروني"
- `password`: "كلمة المرور"
- `enter_password`: "أدخل كلمة المرور"
- `phone_number`: "رقم الهاتف"
- `enter_phone`: "أدخل رقم الهاتف"
- `whatsapp_number`: "رقم الواتساب"
- `enter_whatsapp`: "أدخل رقم الواتساب"
- `address`: "العنوان"
- `enter_address`: "أدخل العنوان"
- `role`: "الدور الوظيفي"
- `employee`: "موظف"
- `manager`: "مدير"

## Navigation

### From Employees Screen
A floating action button (FAB) has been added to the `EmployeesScreen`:
- Icon: Plus (+)
- Label: "Add Employee" / "إضافة موظف"
- Action: Navigates to `AddEmployeesScreen`
- On return: Refreshes employee list if an employee was added

### Usage
```dart
// Navigate to add employee screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddEmployeesScreen(),
  ),
);
```

## Testing Checklist

- [ ] Test form validation for all fields
- [ ] Test email format validation
- [ ] Test password visibility toggle
- [ ] Test role selection (Employee/Manager)
- [ ] Test successful employee creation
- [ ] Test error handling (network errors, validation errors)
- [ ] Test dark mode appearance
- [ ] Test light mode appearance
- [ ] Test mobile layout (< 600px)
- [ ] Test tablet/desktop layout (≥ 600px)
- [ ] Test Arabic localization
- [ ] Test English localization
- [ ] Test navigation back to employee list
- [ ] Test employee list refresh after adding

## Files Created

### Data Layer
1. `/lib/features/employee/data/models/add_employee_request_model.dart`
2. `/lib/features/employee/data/models/add_employee_response_model.dart`

### Domain Layer
3. `/lib/features/employee/domain/entities/add_employee_response_entity.dart`
4. `/lib/features/employee/domain/usecases/add_employee_usecase.dart`

### Presentation Layer
5. `/lib/features/employee/presentation/cubit/add_employee_cubit.dart`
6. `/lib/features/employee/presentation/cubit/add_employee_state.dart`
7. `/lib/features/employee/presentation/screens/add_employees_screen.dart`
8. `/lib/features/employee/presentation/screens/add_employees_mobile_layout.dart`
9. `/lib/features/employee/presentation/screens/add_employees_tablet_layout.dart`

## Files Modified

1. `/lib/features/employee/data/datasources/employees_remote_data_source.dart` - Added `addEmployee()` method
2. `/lib/features/employee/data/repositories/employees_repository_impl.dart` - Implemented `addEmployee()` method
3. `/lib/features/employee/domain/repositories/employees_repository.dart` - Added abstract `addEmployee()` method
4. `/lib/features/employee/presentation/screens/employees_screen.dart` - Added FAB for navigation
5. `/lib/core/localization/app_localizations.dart` - Added employee-related translations

## Dependencies

No new dependencies were added. The implementation uses existing packages:
- `flutter_bloc` - State management
- `dartz` - Functional programming (Either type)
- `dio` - HTTP client
- `equatable` - Value equality

## Future Enhancements

1. Add image upload for employee avatar
2. Add email verification
3. Add phone number formatting
4. Add duplicate email check before submission
5. Add more role types if needed
6. Add employee permissions management
7. Add bulk employee import
