# Comprehensive Update Property Screen - TODO

## Current Update Screen Has:
- ✅ Title
- ✅ Property Type
- ✅ Offer Type  
- ✅ Description
- ✅ Governorate
- ✅ Price

## Missing Fields (from Create Property):
- ❌ Currency selection
- ❌ Price Negotiable checkbox
- ❌ District dropdown
- ❌ Neighborhood dropdown
- ❌ Address field
- ❌ Location picker (map with coordinates)
- ❌ Multi-step form with validation

## Recommendation:

Given the complexity, there are two approaches:

### Option 1: Quick Fix (Add Most Important Fields)
Add to current single-page form:
- Currency
- Price Negotiable
- District
- Neighborhood
- Address (text field, no map)

### Option 2: Full Solution (Replicate Create Flow)
Create a complete multi-step update form like the create form:
- Step 1: Basic Info (same as current)
- Step 2: Price (add currency, negotiable)
- Step 3: Location (add district, neighborhood, address, map)
- Step 4: Review

## Quick Implementation (Option 1 - Recommended)

I'll implement Option 1 now since it's practical and covers the essential fields without over-complicating the UI.
