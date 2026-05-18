import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'app_name': 'Panorama Hotel',
      'app_slogan': 'Luxury and Elegance',

      // Bottom Navigation
      'nav_home': 'Home',
      'nav_units': 'Hotel Units',
      'nav_services': 'Services',
      'nav_events': 'Our Events',
      'nav_booking': 'Book Now',
      'nav_inquiries': 'Contact Us',

      // Home Screen
      'welcome_title': 'Welcome to Panorama Hotel',
      'welcome_subtitle':
          'Experience luxury and comfort in the heart of the city',
      'services_title': 'Welcome to Panorama Hotel',
      'services_subtitle':
          'An exceptional hotel experience in the heart of Aden',
      'about_title': 'About Panorama',
      'about_subtitle': 'Your home away from home',
      'about_description':
          'Panorama Hotel offers a unique experience combining luxury and comfort. Located in the heart of the city, we provide world-class services and amenities to make your stay unforgettable.',
      'features_title': 'Why Panorama Hotel?What Sets Us Apart',
      'features_subtitle':
          'We combine luxury, comfort, and exceptional service to provide you with an unforgettable experience',

      // Services
      'service_pool': 'Swimming Pool',
      'service_gym': 'Fitness Center',
      'service_restaurant': 'Restaurant',
      'service_cafe': 'Café',
      'service_wifi': 'Free WiFi',
      'service_parking': 'Parking',
      'service_spa': 'Spa',
      'service_halls': 'Event Halls',

      // Service Categories
      'category_accommodation': 'Accommodation',
      'category_transportation': 'Transportation',
      'category_dining': 'Dining',
      'category_recreation': 'Recreation',
      'category_wellness': 'Wellness',
      'category_business': 'Business',
      'all_services': 'All',
      'services_detail_title': 'Our Services',
      'services_detail_subtitle': 'Discover all our hotel services',
      'operating_hours': 'Operating Hours',
      'requires_booking': 'Requires Booking',
      'no_services_found': 'No services found',

      // Facilities
      'facilities_title': 'Our Facilities',
      'facilities_subtitle': 'World-class amenities',

      // Reviews
      'reviews_title': 'Guest Reviews',
      'reviews_subtitle': 'What our guests say about us',

      // Admin Control
      'admin_control_title': 'Admin',

      // Conversations
      'conversations_title': 'Conversations',
      'conversation_status_active': 'Active',
      'conversation_status_closed': 'Closed',
      'no_messages': 'No messages yet',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'retry': 'Retry',
      'message_sent_successfully': 'Message sent successfully',
      'type_message': 'Type a message...',
      'whatsapp_stats_title': 'WhatsApp Statistics',
      'admin_reviews_title': 'Manage Reviews',
      'admin_bookings_title': 'Manage Bookings',
      'booking_details_title': 'Booking Details',

      // Features
      'feature_pool': 'Swimming Pool',
      'feature_gym': 'Gym',
      'feature_restaurant': 'Restaurant',
      'feature_halls': 'Event Halls',
      'feature_cafe': 'Café',
      'feature_spa': 'Spa & Wellness',

      // Quick Actions
      'quick_actions': 'Quick Actions',
      'quick_actions_subtitle': 'Fast access to important services',

      // Actions
      'contact_us': 'Contact Us',
      'book_now': 'Book Now',
      'learn_more': 'Learn More',
      'view_all': 'View All',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',

      // Contact
      'contact_title': 'Contact Us',
      'contact_subtitle': 'We are here to help you',
      'contact_description':
          'Send us your inquiry and we will respond as soon as possible',
      'contact_personal_info': 'Personal Information',
      'contact_request_details': 'Request Details',
      'contact_name': 'Name',
      'contact_name_hint': 'Enter your name',
      'contact_phone': 'Phone Number',
      'contact_phone_hint': 'Enter your phone number',
      'contact_message': 'Message',
      'contact_message_hint': 'Enter your message',
      'contact_submit': 'Submit',
      'request_type': 'Request Type',
      'request_inquiry': 'Inquiry',
      'request_complaint': 'Complaint',
      'request_suggestion': 'Suggestion',
      'field_required': 'This field is required',

      // Event Info
      'event_info_title': 'Event Information',
      'event_date': 'Date',
      'event_start_time': 'Start Time',
      'event_end_time': 'End Time',
      'event_location': 'Location',
      'event_venue': 'Venue',

      // Booking
      'booking_title': 'Book Your Stay',
      'booking_header_title': 'Book Your Stay',
      'booking_header_subtitle':
          'Choose the right unit and book your stay easily',
      'booking_unit_selection': 'Unit Selection',
      'booking_unit_type': 'Type',
      'booking_dates': 'Stay Dates',
      'booking_check_in': 'Check-in Date',
      'booking_check_out': 'Check-out Date',
      'booking_guest_info': 'Guest Information',
      'booking_first_name': 'First Name',
      'booking_first_name_hint': 'Enter first name',
      'booking_last_name': 'Last Name',
      'booking_last_name_hint': 'Enter last name',
      'booking_phone': 'Phone / WhatsApp',
      'booking_email': 'Email',
      'booking_nationality': 'Nationality',
      'booking_guests': 'Number of Guests',
      'booking_special_requests': 'Special Requests',
      'booking_requests_label': 'Notes',
      'booking_requests_hint': 'Any special requests or notes...',
      'booking_agree': 'I agree to the hotel policies',
      'booking_view_policy': 'View Policies',
      'booking_submit': 'Confirm Booking',
      'unit_room': 'Room',
      'unit_suite': 'Suite',
      'unit_hall': 'Hall',
      'unit_tiramana': 'Tiramana',
      'country_yemen': 'Yemen',
      'country_saudi': 'Saudi Arabia',
      'country_uae': 'UAE',
      'country_other': 'Other',

      // Login
      'login_welcome': 'Welcome',
      'login_subtitle': 'Click to enter',
      'login_button': 'Login',

      // Units
      'no_units_found': 'No units found',
      'unit_details': 'Unit Details',
      'capacity': 'Capacity',
      'persons': 'Persons',
      'beds': 'Beds',
      'price_per_night': 'Price per Night',
      'size': 'Size',
      'sar': 'SAR',
      'features': 'Features',
      'description': 'Description',
      'available': 'Available',
      'not_available': 'Not Available',
      'gallery': 'Gallery',

      // Events
      'events_title': 'Panorama Hotel Events',
      'events_subtitle':
          'Discover the latest events and activities at our hotel',
      'featured_event': 'Featured Event',
      'no_events_found': 'No events found',
      'view_details': 'View Details',
    },
    'ar': {
      // App
      'app_name': 'فندق بانوراما',
      'app_slogan': 'الفخامة والأناقة',

      // Bottom Navigation
      'nav_home': 'الرئيسية',
      'nav_units': 'الوحدات الفندقية',
      'nav_services': 'الخدمات',
      'nav_events': 'فعالياتنا',
      'nav_booking': 'احجز الآن',
      'nav_inquiries': 'الاستفسارات',

      // Home Screen
      'welcome_title': 'مرحباً بكم في فندق بانوراما',
      'welcome_subtitle': 'استمتع بتجربة فاخرة ومريحة في قلب المدينة',
      'services_title': 'مرحباً بكم فيفندق بانوراما',
      'services_subtitle': 'تجربة فندقية إستثنائية في قلب مدينة عدن',
      'about_title': 'عن بانوراما',
      'about_subtitle': 'بيتك الثاني',
      'about_description':
          'يقدم فندق بانوراما تجربة فريدة تجمع بين الفخامة والراحة. يقع في قلب المدينة، ونوفر خدمات ومرافق عالمية المستوى لجعل إقامتك لا تُنسى.',
      'features_title': 'لماذا فندق بانوراما؟ما يميزنا عن الآخرين',
      'features_subtitle':
          'نجمع بين الفخامة والراحة والخدمة المتميزة لنقدم لكم تجربة لا تُنسى',

      // Services
      'service_pool': 'مسبح',
      'service_gym': 'نادي رياضي',
      'service_restaurant': 'مطعم',
      'service_cafe': 'كافيه',
      'service_wifi': 'واي فاي مجاني',
      'service_parking': 'موقف سيارات',
      'service_spa': 'سبا',
      'service_halls': 'قاعات فعاليات',

      // Service Categories
      'category_accommodation': 'الإقامة',
      'category_transportation': 'النقل',
      'category_dining': 'المطاعم',
      'category_recreation': 'الترفيه',
      'category_wellness': 'الصحة والعافية',
      'category_business': 'الأعمال',
      'all_services': 'الكل',
      'services_detail_title': 'خدماتنا',
      'services_detail_subtitle': 'اكتشف جميع خدمات الفندق',
      'operating_hours': 'ساعات العمل',
      'requires_booking': 'يتطلب حجز مسبق',
      'no_services_found': 'لا توجد خدمات',

      // Facilities
      'facilities_title': 'مرافقنا',
      'facilities_subtitle': 'مرافق عالمية المستوى',

      // Reviews
      'reviews_title': 'تقييمات النزلاء',
      'reviews_subtitle': 'ماذا يقول ضيوفنا عنا',

      // Admin Control
      'admin_control_title': 'الإدارة',

      // Conversations
      'conversations_title': 'المحادثات',
      'conversation_status_active': 'نشط',
      'conversation_status_closed': 'مغلق',
      'no_messages': 'لا توجد رسائل بعد',
      'today': 'اليوم',
      'yesterday': 'أمس',
      'retry': 'إعادة المحاولة',
      'message_sent_successfully': 'تم إرسال الرسالة بنجاح',
      'type_message': 'اكتب رسالة...',
      'whatsapp_stats_title': 'إحصائيات واتساب',
      'admin_reviews_title': 'إدارة التقييمات',
      'admin_bookings_title': 'إدارة الحجوزات',
      'booking_details_title': 'تفاصيل الحجز',

      // Features
      'feature_pool': 'مسبح',
      'feature_gym': 'نادي رياضي',
      'feature_restaurant': 'مطعم',
      'feature_halls': 'قاعات',
      'feature_cafe': 'كافيه',
      'feature_spa': 'سبا واستجمام',

      // Quick Actions
      'quick_actions': 'إجراءات سريعة',
      'quick_actions_subtitle': 'وصول سريع للخدمات المهمة',

      // Actions
      'contact_us': 'اتصل بنا',
      'book_now': 'احجز الآن',
      'learn_more': 'اعرف المزيد',
      'view_all': 'عرض الكل',
      'logout': 'تسجيل الخروج',
      'logout_confirmation': 'هل أنت متأكد من تسجيل الخروج؟',
      'cancel': 'إلغاء',

      // Contact
      'contact_title': 'تواصل معنا',
      'contact_subtitle': 'نحن هنا لمساعدتك',
      'contact_description': 'أرسل لنا استفسارك وسنرد عليك في أقرب وقت ممكن',
      'contact_personal_info': 'المعلومات الشخصية',
      'contact_request_details': 'تفاصيل الطلب',
      'contact_name': 'الاسم',
      'contact_name_hint': 'أدخل اسمك',
      'contact_phone': 'رقم الهاتف',
      'contact_phone_hint': 'أدخل رقم هاتفك',
      'contact_message': 'الرسالة',
      'contact_message_hint': 'أدخل رسالتك',
      'contact_submit': 'إرسال',
      'request_type': 'نوع الطلب',
      'request_inquiry': 'استفسار',
      'request_complaint': 'شكوى',
      'request_suggestion': 'اقتراح',
      'field_required': 'هذا الحقل مطلوب',

      // Event Info
      'event_info_title': 'معلومات الفعالية',
      'event_date': 'التاريخ',
      'event_start_time': 'وقت البدء',
      'event_end_time': 'وقت الانتهاء',
      'event_location': 'الموقع',
      'event_venue': 'المكان',

      // Booking
      'booking_title': 'احجز إقامتك',
      'booking_header_title': 'احجز إقامتك',
      'booking_header_subtitle': 'اختر الوحدة المناسبة واحجز إقامتك بسهولة',
      'booking_unit_selection': 'اختيار الوحدة',
      'booking_unit_type': 'النوع',
      'booking_dates': 'تواريخ الإقامة',
      'booking_check_in': 'تاريخ الوصول',
      'booking_check_out': 'تاريخ المغادرة',
      'booking_guest_info': 'معلومات الضيف',
      'booking_first_name': 'الاسم الأول',
      'booking_first_name_hint': 'أدخل الاسم الأول',
      'booking_last_name': 'اسم العائلة',
      'booking_last_name_hint': 'أدخل اسم العائلة',
      'booking_phone': 'رقم الهاتف / واتساب',
      'booking_email': 'البريد الإلكتروني',
      'booking_nationality': 'الجنسية',
      'booking_guests': 'عدد الضيوف',
      'booking_special_requests': 'طلبات خاصة',
      'booking_requests_label': 'ملاحظات',
      'booking_requests_hint': 'أي طلبات خاصة أو ملاحظات...',
      'booking_agree': 'أوافق على سياسات الفندق',
      'booking_view_policy': 'عرض السياسات',
      'booking_submit': 'تأكيد الحجز',
      'unit_room': 'غرفة',
      'unit_suite': 'جناح',
      'unit_hall': 'قاعة',
      'unit_tiramana': 'طيرمانة',
      'country_yemen': 'اليمن',
      'country_saudi': 'السعودية',
      'country_uae': 'الإمارات',
      'country_other': 'أخرى',

      // Login
      'login_welcome': 'مرحباً بكم',
      'login_subtitle': 'اضغط للدخول',
      'login_button': 'تسجيل الدخول',

      // Units
      'no_units_found': 'لا توجد وحدات',
      'unit_details': 'تفاصيل الوحدة',
      'capacity': 'السعة',
      'persons': 'أشخاص',
      'beds': 'أسرّة',
      'price_per_night': 'السعر لليلة',
      'size': 'المساحة',
      'sar': 'ريال',
      'features': 'المميزات',
      'description': 'الوصف',
      'available': 'متاح',
      'not_available': 'غير متاح',
      'gallery': 'معرض الصور',

      // Events
      'events_title': 'فعاليات فندق بانوراما',
      'events_subtitle': 'اكتشف أحدث الفعاليات والأنشطة في فندقنا',
      'featured_event': 'فعالية مميزة',
      'no_events_found': 'لا توجد فعاليات',
      'view_details': 'عرض التفاصيل',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
