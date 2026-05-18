import 'package:dalil_alaqar/features/advertisements/presentation/cubit/slider_cubit.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/home/presentation/widgets/features_section.dart';

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
  // late final ServicesCubit _servicesCubit;
  // late final AboutCubit _aboutCubit;

  @override
  void initState() {
    super.initState();
    // إنشاء Cubits مرة واحدة فقط عند بناء الشاشة
    _sliderCubit = SliderCubit.create()..getSlides();
    // _servicesCubit = ServicesCubit.create()..fetchServices();
    // _aboutCubit = AboutCubit.create()..getAbout();
  }

  @override
  void dispose() {
    // تنظيف الموارد
    _sliderCubit.close();
    // _servicesCubit.close();
    // _aboutCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // مطلوب لـ AutomaticKeepAliveClientMixin

    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _sliderCubit)],
      child: const SingleChildScrollView(
        child: Column(
          children: [
            // Slider Section
            SliderWidget(isTablet: false),

            SizedBox(height: 24),

            // Features Section (Static - لا يحتاج Cubit)
            FeaturesSection(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
