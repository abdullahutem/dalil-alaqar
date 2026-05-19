# Property Details UI Guide

## 🎨 Visual Component Breakdown

### Mobile Layout Components

#### 1. **Collapsible App Bar with Image Gallery**
```
┌─────────────────────────────────┐
│  [←]              [Share] [♡]   │ ← Floating buttons
│                                 │
│                                 │
│      Image Gallery              │
│      (Swipeable)                │
│                                 │
│         1 / 4                   │ ← Page indicator
└─────────────────────────────────┘
```
- **Height**: 300px when expanded
- **Background**: Property images
- **Controls**: Back, Share, Favorite buttons
- **Indicator**: Current page / Total pages

#### 2. **Title Section**
```
┌─────────────────────────────────┐
│ 🏡 فيلا للبيع في حي السلام      │
│                                 │
│ [رقم المرجع: AQ-2026-001]      │
│ [متاح]                          │
└─────────────────────────────────┘
```
- **Icon**: Property type emoji
- **Title**: Bold, large text
- **Reference**: Badge with primary color
- **Status**: Green badge for available

#### 3. **Price Section** (Gradient Card)
```
┌─────────────────────────────────┐
│ 💰 للبيع                        │
│                                 │
│ 729,000,000 IQD                 │
│                                 │
│ [السعر قابل للتفاوض]            │
└─────────────────────────────────┘
```
- **Background**: Teal gradient with shadow
- **Text**: White on gradient
- **Price**: Large, bold numbers
- **Badge**: Negotiable indicator

#### 4. **Info Cards** (Side by Side)
```
┌──────────────┬──────────────────┐
│   👁️         │    📅            │
│ المشاهدات    │  تاريخ النشر     │
│   524        │  2026/03/27      │
└──────────────┴──────────────────┘
```
- **Layout**: Two equal columns
- **Icons**: Centered at top
- **Values**: Bold, centered

#### 5. **Location Section**
```
┌─────────────────────────────────┐
│ 📍 الموقع                       │
│                                 │
│ 🏙️ المحافظة: ذمار              │
│ 🗺️ المديرية: ذمار المدينة      │
│ 📌 الحي: حي السلام              │
│ 🏠 العنوان: شارع الرئيسي        │
│                                 │
│ [عرض على الخريطة]               │
└─────────────────────────────────┘
```
- **Header**: Icon + Title
- **Items**: Icon + Label + Value
- **Button**: Full-width, primary color

#### 6. **Description Section**
```
┌─────────────────────────────────┐
│ 📄 الوصف                        │
│                                 │
│ فيلا مستقلة في مجمع سكني راقي،  │
│ أمن وحراسة 24 ساعة. الموقع:     │
│ حي السلام، ذمار المدينة، ذمار   │
│                                 │
└─────────────────────────────────┘
```
- **Text**: Multi-line with line height 1.8
- **Style**: Body text, justified

#### 7. **Property Details**
```
┌─────────────────────────────────┐
│ ℹ️ تفاصيل العقار                │
│                                 │
│ نوع العقار          فيلا       │
│ ─────────────────────────────   │
│ نوع العرض           للبيع      │
│ ─────────────────────────────   │
│ الحالة              متاح        │
└─────────────────────────────────┘
```
- **Layout**: Label on right, value on left
- **Dividers**: Between rows

#### 8. **Office Information**
```
┌─────────────────────────────────┐
│ 🏢 معلومات المكتب               │
│                                 │
│ 💼 اسم المكتب                   │
│    مكتب دار السلام العقاري      │
│                                 │
│ 📧 البريد الإلكتروني            │
│    mktb-dar-alslam@dalilaqar.iq │
│                                 │
│ 📞 رقم الهاتف                   │
│    +96477693354520              │
└─────────────────────────────────┘
```
- **Items**: Icon + Label + Value (stacked)

#### 9. **Contact Buttons**
```
┌─────────────────────────────────┐
│ [📞 اتصل الآن]                  │ ← Primary button
│                                 │
│ [💬 واتساب]                     │ ← Outlined button
└─────────────────────────────────┘
```
- **Call Button**: Teal background, full-width
- **WhatsApp Button**: Green border, outlined

---

### Tablet Layout Components

#### Layout Structure
```
┌────────────────────────────────────────────────┐
│  [←] فيلا للبيع في حي السلام    [Share] [♡]  │
├──────────────────────┬─────────────────────────┤
│                      │                         │
│                      │  Title Section          │
│   Image Gallery      │  Price Section          │
│   (60% width)        │  Info Cards             │
│   Fixed height       │  Location Section       │
│                      │  Description            │
│                      │  Property Details       │
│                      │  Office Info            │
│                      │  Contact Buttons        │
│                      │  (Scrollable)           │
│                      │                         │
└──────────────────────┴─────────────────────────┘
```

**Key Differences from Mobile:**
- Two-column layout (60/40 split)
- Standard app bar (not collapsible)
- Image gallery on left, details on right
- Navigation arrows on image gallery
- More horizontal space utilization

---

## 🎨 Color Scheme

### Light Mode
```
Background:     #F8F9FA (Light Gray)
Surface:        #FFFFFF (White)
Primary:        #038086 (Teal)
Text:           #1A1A1A (Dark Gray)
Text Secondary: #6B7280 (Medium Gray)
```

### Dark Mode
```
Background:     #121212 (Almost Black)
Surface:        #1E1E1E (Dark Gray)
Card:           #242424 (Lighter Dark)
Primary:        #038086 (Teal - same)
Text:           #FFFFFF (White)
Text Secondary: #B3B3B3 (Light Gray)
Divider:        #2C2C2C (Dark Border)
```

---

## 📐 Spacing & Sizing

### Padding
- **Screen edges**: 16px (mobile), 24px (tablet)
- **Card padding**: 20px
- **Section spacing**: 24px
- **Item spacing**: 8-12px

### Border Radius
- **Cards**: 12-16px
- **Buttons**: 8px
- **Badges**: 8-20px (pill shape)
- **Images**: 12px

### Typography
```
Display Large:  32px, Bold
Display Medium: 28px, Bold
Display Small:  24px, Semi-Bold
Headline:       20px, Semi-Bold
Title Large:    18px, Semi-Bold
Title Medium:   16px, Medium
Body Large:     16px, Regular
Body Medium:    14px, Regular
Body Small:     12px, Regular
```

### Icons
- **Large icons**: 28px (section headers)
- **Medium icons**: 20px (list items)
- **Small icons**: 14-16px (inline)

---

## 🎭 Interactive States

### Buttons
```
Normal:   Primary color background
Hover:    Slightly darker (web/desktop)
Pressed:  Ripple effect
Disabled: Gray with reduced opacity
```

### Cards
```
Normal:   Elevation 2, subtle shadow
Hover:    Elevation 4 (web/desktop)
Pressed:  Ripple effect
```

### Images
```
Loading:  Circular progress indicator
Error:    Broken image icon
Loaded:   Fade-in animation
```

---

## 🔄 Animations

### Page Transitions
- **Duration**: 300ms
- **Curve**: easeInOut
- **Type**: Slide from right (RTL)

### Image Gallery
- **Swipe**: Smooth page transition
- **Zoom**: Pinch gesture in full-screen
- **Indicator**: Fade in/out

### Loading States
- **Spinner**: Circular, primary color
- **Duration**: Infinite until loaded

### Error States
- **Icon**: Fade in
- **Message**: Slide up

---

## 📱 Responsive Breakpoints

```
Mobile:     < 600px  (Single column)
Tablet:     ≥ 600px  (Two columns)
Desktop:    ≥ 900px  (Same as tablet)
```

### Adaptive Features
- **< 600px**: Collapsible app bar, vertical layout
- **≥ 600px**: Standard app bar, horizontal layout, navigation arrows

---

## ♿ Accessibility

### Touch Targets
- **Minimum size**: 48x48 dp
- **Spacing**: 8dp between targets
- **Buttons**: Full-width on mobile

### Contrast Ratios
- **Normal text**: 4.5:1 minimum
- **Large text**: 3:1 minimum
- **Icons**: 3:1 minimum

### Screen Reader
- **Labels**: All interactive elements
- **Descriptions**: Images and icons
- **Announcements**: State changes

---

## 🎯 User Interactions

### Tap Actions
1. **Back button** → Navigate back
2. **Share button** → Share property (TODO)
3. **Favorite button** → Add to favorites (TODO)
4. **Image** → Open full-screen gallery
5. **Map button** → Open Google Maps
6. **Call button** → Open phone dialer
7. **WhatsApp button** → Open WhatsApp chat

### Swipe Actions
1. **Image gallery** → Next/previous image
2. **Full-screen gallery** → Next/previous image

### Pinch Actions
1. **Full-screen image** → Zoom in/out

---

## 🌐 Localization

### Arabic (RTL)
- **Text direction**: Right to left
- **Layout**: Mirrored
- **Numbers**: Arabic numerals with Arabic formatting
- **Dates**: Arabic date format (yyyy/MM/dd)
- **Currency**: IQD (Iraqi Dinar)

### Number Formatting
```
729000000 → 729,000,000
```

### Date Formatting
```
2026-03-27T10:38:36.000000Z → 2026/03/27
```

---

## 🎨 Component States

### Loading State
```
┌─────────────────────────────────┐
│                                 │
│                                 │
│         ⟳ Loading...            │
│                                 │
│                                 │
└─────────────────────────────────┘
```

### Error State
```
┌─────────────────────────────────┐
│                                 │
│            ⚠️                   │
│                                 │
│    حدث خطأ في تحميل البيانات    │
│                                 │
│         [العودة]                │
│                                 │
└─────────────────────────────────┘
```

### Empty State (No Images)
```
┌─────────────────────────────────┐
│                                 │
│            🖼️                   │
│                                 │
│         لا توجد صور             │
│                                 │
└─────────────────────────────────┘
```

---

## 🎬 Full-Screen Gallery

```
┌─────────────────────────────────┐
│ [✕]           1 / 4              │ ← App bar
├─────────────────────────────────┤
│                                 │
│                                 │
│                                 │
│        Zoomable Image           │
│     (Pinch to zoom)             │
│                                 │
│                                 │
│                                 │
└─────────────────────────────────┘
```
- **Background**: Black
- **Controls**: Close button, page counter
- **Interaction**: Swipe, pinch-to-zoom, pan

---

## 📊 Performance Metrics

### Target Metrics
- **Initial load**: < 2 seconds
- **Image load**: < 1 second per image
- **Navigation**: < 300ms
- **Smooth scrolling**: 60 FPS
- **Memory usage**: < 100MB

### Optimization Techniques
1. **Image caching** - Cached network images
2. **Lazy loading** - Load images on demand
3. **State management** - Efficient BLoC pattern
4. **Widget optimization** - Const constructors
5. **Build optimization** - Minimal rebuilds

---

This UI guide provides a comprehensive visual reference for the Property Details feature implementation! 🎉
