import 'package:dalil_alaqar/features/advertisements/presentation/cubit/slider_cubit.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/widgets/slider_widget.dart';
import 'package:dalil_alaqar/features/offices/presentation/widgets/offices_section.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/properties_section.dart';

class HomeMobileLayout extends StatefulWidget {
  const HomeMobileLayout({super.key});

  @override
  State<HomeMobileLayout> createState() => _HomeMobileLayoutState();
}

class _HomeMobileLayoutState extends State<HomeMobileLayout>
    with AutomaticKeepAliveClientMixin {
  // الحفاظ على الحالة عند التنقل
  @override
  bool get wantKeepAlive => true;

  // إنشاء Cubits مرة واحدة فقط
  late final SliderCubit _sliderCubit;
  late final PropertiesCubit _propertiesCubit;
  // late final ServicesCubit _servicesCubit;
  // late final AboutCubit _aboutCubit;

  @override
  void initState() {
    super.initState();
    // إنشاء Cubits مرة واحدة فقط عند بناء الشاشة
    _sliderCubit = SliderCubit.create()..getSlides();
    _propertiesCubit = PropertiesCubit.create()..getProperties();
    // _servicesCubit = ServicesCubit.create()..fetchServices();
    // _aboutCubit = AboutCubit.create()..getAbout();
  }

  @override
  void dispose() {
    // تنظيف الموارد
    _sliderCubit.close();
    _propertiesCubit.close();
    // _servicesCubit.close();
    // _aboutCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مطلوب لـ AutomaticKeepAliveClientMixin

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _sliderCubit),
        BlocProvider.value(value: _propertiesCubit),
      ],
      child: const SingleChildScrollView(
        child: Column(
          children: [
            // Slider Section
            SliderWidget(isTablet: false),

            SizedBox(height: 24),

            // Properties Section
            PropertiesSection(isTablet: false),
            SizedBox(height: 24),

            // Properties Section
            OfficesSection(),

            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
