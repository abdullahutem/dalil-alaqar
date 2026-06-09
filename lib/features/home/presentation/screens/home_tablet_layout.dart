import 'package:dalil_alaqar/features/advertisements/presentation/cubit/slider_cubit.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/widgets/slider_widget.dart';
import 'package:dalil_alaqar/features/offices/presentation/widgets/offices_section.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/properties_section.dart';
import 'package:dalil_alaqar/features/property_types/presentation/widgets/property_types_section.dart';

class HomeTabletLayout extends StatefulWidget {
  const HomeTabletLayout({super.key});

  @override
  State<HomeTabletLayout> createState() => _HomeTabletLayoutState();
}

class _HomeTabletLayoutState extends State<HomeTabletLayout>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final SliderCubit _sliderCubit;
  late final PropertiesCubit _propertiesCubit;
  late final PropertyTypesCubit _propertyTypesCubit;

  @override
  void initState() {
    super.initState();
    _sliderCubit = SliderCubit.create()..getSlides();
    _propertiesCubit = PropertiesCubit.create()..getProperties();
    _propertyTypesCubit = PropertyTypesCubit.create()..getPropertyTypes();
  }

  @override
  void dispose() {
    _sliderCubit.close();
    _propertiesCubit.close();
    _propertyTypesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _sliderCubit),
        BlocProvider.value(value: _propertiesCubit),
        BlocProvider.value(value: _propertyTypesCubit),
      ],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                // Slider Section
                SliderWidget(isTablet: true),

                SizedBox(height: 40),

                // Property Types Section
                PropertyTypesSection(isTablet: true),

                SizedBox(height: 40),

                // Properties Section
                PropertiesSection(isTablet: true),
                SizedBox(height: 24),

                // Offices Section
                OfficesSection(),

                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
