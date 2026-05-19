# FEATURE_GENERATION_PROMPT.md Update Summary

## Date: 2026-05-19

## Purpose
Updated the feature generation prompt to prevent common errors found during the offices feature code review.

---

## Changes Made

### 1. ✅ Added Modern API Usage Requirement

**Location**: Code Quality Requirements section

**Added**:
- ✅ Use modern Flutter APIs (no deprecated methods)

**Why**: To ensure AI agents use current Flutter APIs instead of deprecated ones.

---

### 2. ✅ Updated Network Info Check Pattern

**Location**: Data Layer section

**Changed**:
```dart
// Before
- Include NetworkInfo check for internet connectivity

// After
- Include NetworkInfo check for internet connectivity with null coalescing: 
  `if (!(await networkInfo.isConnected ?? false))`
```

**Added**: Complete repository implementation pattern example showing correct null handling.

**Why**: The `networkInfo.isConnected` returns a nullable bool, which must be handled with `?? false`.

---

### 3. ✅ Updated Opacity Usage Guidelines

**Location**: Theme Support Guidelines section

**Changed**:
```dart
// Before - Used .withOpacity() in examples
Colors.grey[600]
Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)

// After - Uses .withValues(alpha: ...)
Colors.black.withValues(alpha: 0.08)
theme.colorScheme.primary.withValues(alpha: 0.1)
theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)
```

**Added**: 
- Clear section titled "Opacity - IMPORTANT: Use .withValues() NOT .withOpacity()"
- Multiple correct and incorrect examples
- Emphasis on the deprecation

**Why**: `.withOpacity()` is deprecated in favor of `.withValues(alpha: ...)`.

---

### 4. ✅ Standardized Shadow Implementation

**Location**: Theme Support Guidelines section

**Changed**:
```dart
// Before - Suggested different opacity per theme
BoxShadow(
  color: Colors.black.withOpacity(0.08),
)

// After - Consistent opacity for all themes
BoxShadow(
  color: Colors.black.withValues(alpha: 0.08),
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

**Added**: Clear example showing NOT to use different opacity per theme.

**Why**: Consistent shadows look better and are simpler to maintain.

---

### 5. ✅ Added "Common Mistakes to Avoid" Section

**Location**: New section before "Notes"

**Added comprehensive section covering**:

#### 1. Deprecated APIs
```dart
// ❌ WRONG
Colors.black.withOpacity(0.08)

// ✅ CORRECT
Colors.black.withValues(alpha: 0.08)
```

#### 2. Network Info Null Check
```dart
// ❌ WRONG
if (!await networkInfo.isConnected) {

// ✅ CORRECT
if (!(await networkInfo.isConnected ?? false)) {
```

#### 3. Error Widget Parameters
```dart
// ❌ WRONG
errorWidget: (_, __, ___) => widget

// ✅ CORRECT
errorWidget: (_, __, _) => widget
```

#### 4. Unused Variables
```dart
// ❌ WRONG
final isDark = Theme.of(context).brightness == Brightness.dark;
// ... never used

// ✅ CORRECT
// Don't declare if not needed
```

#### 5. Shadow Consistency
```dart
// ❌ WRONG
BoxShadow(
  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
)

// ✅ CORRECT
BoxShadow(
  color: Colors.black.withValues(alpha: 0.08),
)
```

**Why**: Provides clear examples of what NOT to do and what TO do instead.

---

### 6. ✅ Added Best Practices Checklist

**Location**: Common Mistakes to Avoid section

**Added checklist**:
- [ ] No `.withOpacity()` usage (use `.withValues(alpha: ...)` instead)
- [ ] Network info check includes `?? false`
- [ ] No multiple underscores in unused parameters
- [ ] No unused variable declarations
- [ ] Consistent shadow opacity (0.08 for all themes)
- [ ] All diagnostics pass (0 errors, 0 warnings)
- [ ] Theme tested in both light and dark modes

**Why**: Quick reference checklist for AI agents to verify before submitting code.

---

### 7. ✅ Enhanced Validation Checklist

**Location**: Validation Checklist section

**Added items**:
- [ ] **No diagnostic errors or warnings** (emphasized)
- [ ] **No deprecated APIs used (especially .withOpacity)**
- [ ] **Network info check includes ?? false**
- [ ] **Shadows use consistent opacity (0.08)**
- [ ] **No unused variables declared**
- [ ] **Error widget uses single underscores (_, __, _)**

**Added new sub-section**: Code Review Checklist with categories:
- API Usage
- Null Safety
- Code Style
- Theme Support
- Diagnostics

**Why**: More comprehensive validation to catch all the issues found in the offices feature.

---

### 8. ✅ Updated Error Widget Examples

**Location**: Theme Support Guidelines section

**Added**:
```dart
// ✅ CORRECT
errorWidget: (_, __, _) => placeholder()

// ❌ WRONG
errorWidget: (_, __, ___) => placeholder()  // Lint warning
```

**Why**: Prevent lint warnings about multiple underscores.

---

### 9. ✅ Added Unused Variables Warning

**Location**: Theme Support Guidelines section

**Added**:
```dart
// ❌ WRONG - Declaring but not using
final isDark = Theme.of(context).brightness == Brightness.dark;
// ... isDark never used

// ✅ CORRECT - Only declare if you use it
// Don't declare isDark if you're using consistent shadows
```

**Why**: Prevent unused variable warnings.

---

### 10. ✅ Updated Notes Section

**Location**: End of document

**Added**:
- **IMPORTANT**: Always use modern Flutter APIs - avoid deprecated methods

**Why**: Final reminder about using current APIs.

---

## Impact

### Before Updates:
AI agents would generate code with:
- ❌ Deprecated `.withOpacity()` calls (13 warnings)
- ❌ Missing null check on network info (1 error)
- ❌ Multiple underscores in error widgets (2 warnings)
- ❌ Unused variables (2 warnings)
- ❌ Inconsistent shadow opacity

### After Updates:
AI agents will now:
- ✅ Use `.withValues(alpha: ...)` instead of `.withOpacity()`
- ✅ Include `?? false` in network info checks
- ✅ Use single underscores in error widgets
- ✅ Avoid declaring unused variables
- ✅ Use consistent shadow opacity (0.08)
- ✅ Generate code with 0 diagnostics errors/warnings

---

## Testing Recommendation

When the next feature is generated using this updated prompt:
1. Check for `.withOpacity()` usage - should be 0
2. Check network info implementation - should include `?? false`
3. Run diagnostics - should show 0 errors, 0 warnings
4. Check error widgets - should use `(_, __, _)`
5. Check for unused variables - should be 0

---

## Files Modified

1. ✅ `FEATURE_GENERATION_PROMPT.md` - Updated with all improvements

## Files Created

1. ✅ `PROMPT_UPDATE_SUMMARY.md` - This document
2. ✅ `OFFICES_FEATURE_REVIEW.md` - Detailed code review
3. ✅ `OFFICES_FEATURE_SUMMARY.md` - Executive summary

---

## Summary

The FEATURE_GENERATION_PROMPT.md has been significantly enhanced with:
- Clear examples of deprecated vs modern APIs
- Comprehensive "Common Mistakes to Avoid" section
- Enhanced validation checklists
- Code review checklist
- Best practices checklist
- Specific patterns for network info, shadows, and error widgets

These updates will help AI agents generate cleaner, error-free code that follows modern Flutter best practices and passes all diagnostics checks.

---

**Updated by**: Kiro AI  
**Date**: 2026-05-19  
**Based on**: Offices feature code review findings
