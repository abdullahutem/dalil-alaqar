# FEATURE_GENERATION_PROMPT.md Update - Skeleton Loading & Card Separation

## Date: 2026-05-19

## Purpose
Updated the feature generation prompt to require skeleton loading implementation and separate card designs for mobile and tablet layouts.

---

## Changes Made

### 1. ✅ Updated Presentation Layer Requirements

**Location**: Section 3 - Presentation Layer

**Added**:
- Requirement for skeleton loading state handling in cubit
- Separate card widgets for mobile and tablet
- Skeleton widget requirement
- Critical widget design rules

**New Widget Structure**:
```
**Widgets:**
- [feature_name]_card.dart - Full card for mobile list view
- [feature_name]_card_tablet.dart - Tablet-optimized card
- [feature_name]_card_compact.dart - Compact card for horizontal scrolling
- [feature_name]_skeleton.dart - Animated skeleton loading widget
- [feature_name]_section.dart - Section widget for home screen
```

**Critical Rules Added**:
- ❌ **NEVER** use the same card widget for mobile and tablet
- ✅ **ALWAYS** create separate card designs for different screen sizes
- ✅ **ALWAYS** implement skeleton loading for loading states
- ✅ **ALWAYS** use animated shimmer effect in skeletons

---

### 2. ✅ Added Home Screen Integration Guidelines

**Location**: Section 4 - Home Screen Integration

**Added**:
- Use `SingleChildScrollView` with `Row` for horizontal scrolling
- **DO NOT** use fixed height `SizedBox` with `ListView`
- Let cards expand based on content
- Include skeleton loading for sections

**Why**: Fixed height ListView causes overflow issues when content doesn't fit.

---

### 3. ✅ Added Complete Skeleton Loading Section

**Location**: New Section 5 - Skeleton Loading Implementation

**Added**:
- Complete skeleton widget pattern with code example
- AnimationController setup (1500ms duration)
- Shimmer animation (0.3 to 0.7 alpha)
- Usage examples in layouts
- Design guidelines

**Skeleton Pattern**:
```dart
class [FeatureName]Skeleton extends StatefulWidget {
  final bool isTablet;
  
  @override
  State<[FeatureName]Skeleton> createState() => _[FeatureName]SkeletonState();
}

class _[FeatureName]SkeletonState extends State<[FeatureName]Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Skeleton structure with animated shimmer
      },
    );
  }
}
```

**Guidelines**:
- Match skeleton structure to actual card layout
- Use animated shimmer effect
- Duration: 1500ms with reverse repeat
- Use theme-aware colors
- Create separate skeletons for mobile/tablet if layouts differ

---

### 4. ✅ Updated Validation Checklist

**Location**: Validation Checklist section

**Added Items**:
- [ ] **Separate card widgets for mobile and tablet (not the same card)**
- [ ] **Skeleton loading widget created and implemented**
- [ ] Loading states implemented with skeleton
- [ ] **Horizontal scrolling uses SingleChildScrollView + Row (not fixed height ListView)**

**Why**: Ensures AI agents don't skip these critical requirements.

---

### 5. ✅ Added Widget Design Checklist

**Location**: Code Review Checklist section

**New Section**:
```
**Widget Design:**
- [ ] Separate card widgets for mobile and tablet
- [ ] Skeleton loading widget created with animated shimmer
- [ ] Skeleton matches actual card layout structure
- [ ] Horizontal scrolling uses `SingleChildScrollView` + `Row`
- [ ] No fixed height constraints causing overflow
- [ ] Cards expand based on content
```

---

## Rationale

### Why Separate Cards for Mobile and Tablet?

**Problem**: Using the same card for both mobile and tablet results in:
- Poor use of tablet screen space
- Cramped or stretched layouts
- Suboptimal user experience

**Solution**: Create optimized cards for each screen size:
- **Mobile Card**: Compact, vertical layout, smaller fonts (14-16px)
- **Tablet Card**: Wider, horizontal elements, larger fonts (16-18px), generous padding
- **Compact Card**: Fixed width (280px) for horizontal scrolling

**Example from Project**:
- `office_card.dart` - Full card for list view
- `office_card_compact.dart` - Compact for horizontal scrolling

---

### Why Skeleton Loading?

**Benefits**:
1. **Better UX**: Users see structure while content loads
2. **Perceived Performance**: Feels faster than blank screen or spinner
3. **Professional Look**: Modern apps use skeleton loading
4. **Reduces Bounce Rate**: Users less likely to leave during loading

**Implementation**:
- Animated shimmer effect (pulsing opacity)
- Matches actual card structure
- Theme-aware colors
- Smooth animation (1500ms)

**Example from Project**:
- `slider_skeleton.dart` - Complete animated skeleton
- `offices_section.dart` - Simple skeleton with CircularProgressIndicator

---

### Why SingleChildScrollView + Row?

**Problem with Fixed Height ListView**:
```dart
// ❌ BAD - Causes overflow
SizedBox(
  height: 280,  // Fixed height
  child: ListView.builder(...),
)
```

When card content exceeds 280px → **RenderFlex overflow error**

**Solution**:
```dart
// ✅ GOOD - Expands based on content
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: items.map((item) => Card(...)).toList(),
  ),
)
```

Cards determine their own height → **No overflow**

---

## Impact

### Before Updates:
AI agents would:
- ❌ Use same card for mobile and tablet
- ❌ Skip skeleton loading implementation
- ❌ Use fixed height ListView causing overflow
- ❌ Show only CircularProgressIndicator for loading

### After Updates:
AI agents will:
- ✅ Create separate optimized cards for each screen size
- ✅ Implement animated skeleton loading
- ✅ Use flexible horizontal scrolling
- ✅ Provide better user experience

---

## Examples from Project

### Skeleton Loading:
1. **SliderSkeleton** (`slider_skeleton.dart`)
   - Full animated shimmer effect
   - Gradient animation
   - Theme-aware
   - Responsive (mobile/tablet)

2. **OfficesSection** (`offices_section.dart`)
   - Simple skeleton with CircularProgressIndicator
   - Quick implementation

### Card Separation:
1. **Offices Feature**:
   - `office_card.dart` - Full card for list
   - `office_card_compact.dart` - Compact for horizontal scroll

2. **Properties Feature**:
   - `property_card.dart` - Full card
   - `property_card_compact.dart` - Compact card

---

## Testing Recommendations

When generating a new feature, verify:

1. **Card Separation**:
   - [ ] Mobile card exists and is optimized
   - [ ] Tablet card exists and is different from mobile
   - [ ] Compact card exists for home screen (if needed)
   - [ ] Each card uses appropriate sizing and spacing

2. **Skeleton Loading**:
   - [ ] Skeleton widget created
   - [ ] Animation controller implemented
   - [ ] Shimmer effect working (0.3 to 0.7 alpha)
   - [ ] Skeleton structure matches actual card
   - [ ] Used in loading states

3. **Horizontal Scrolling**:
   - [ ] Uses `SingleChildScrollView` + `Row`
   - [ ] No fixed height constraints
   - [ ] No overflow errors
   - [ ] Cards expand based on content

4. **User Experience**:
   - [ ] Loading shows skeleton (not just spinner)
   - [ ] Mobile layout looks good on phones
   - [ ] Tablet layout uses screen space well
   - [ ] Smooth animations
   - [ ] No visual glitches

---

## Summary

The FEATURE_GENERATION_PROMPT.md has been enhanced with:

1. **Skeleton Loading Requirements**
   - Complete implementation pattern
   - Animation guidelines
   - Usage examples

2. **Card Separation Requirements**
   - Separate cards for mobile/tablet
   - Design guidelines for each
   - Critical rules emphasized

3. **Layout Best Practices**
   - Flexible horizontal scrolling
   - No fixed height constraints
   - Content-based sizing

4. **Enhanced Checklists**
   - Validation checklist updated
   - Code review checklist expanded
   - Widget design section added

These updates will help AI agents generate features with:
- ✅ Better user experience
- ✅ Professional loading states
- ✅ Optimized layouts for each screen size
- ✅ No overflow issues
- ✅ Modern UI patterns

---

**Updated by**: Kiro AI  
**Date**: 2026-05-19  
**Based on**: Properties feature overflow issues and offices feature review
