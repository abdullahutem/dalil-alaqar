import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../cubit/property_location_cubit.dart';
import '../cubit/property_location_state.dart';

class PropertyLocationPicker extends StatefulWidget {
  final Function(LatLng, String?) onLocationSelected;

  const PropertyLocationPicker({super.key, required this.onLocationSelected});

  @override
  State<PropertyLocationPicker> createState() => _PropertyLocationPickerState();
}

class _PropertyLocationPickerState extends State<PropertyLocationPicker> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyLocationCubit, PropertyLocationState>(
      listener: (context, state) {
        if (state is PropertyLocationUpdated) {
          _mapController.move(state.position, _mapController.camera.zoom);
          widget.onLocationSelected(state.position, state.address);
        } else if (state is PropertyLocationPermissionDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (state is PropertyLocationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<PropertyLocationCubit>();
        final isLoading = state is PropertyLocationLoading;

        return Stack(
          children: [
            // Map View
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: cubit.currentPosition,
                  initialZoom: 15.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                  onTap: (tapPosition, point) {
                    cubit.updateMapPosition(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.dalilalaqar.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: cubit.currentPosition,
                        width: 50,
                        height: 50,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Instruction Banner
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'اضغط على الخريطة لتحديد موقع العقار',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Control Buttons
            Positioned(
              right: 16,
              top: 80,
              child: Column(
                children: [
                  // Zoom In
                  _buildControlButton(
                    icon: Icons.add,
                    onTap: () {
                      final currentZoom = _mapController.camera.zoom;
                      _mapController.move(
                        _mapController.camera.center,
                        currentZoom + 1,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Zoom Out
                  _buildControlButton(
                    icon: Icons.remove,
                    onTap: () {
                      final currentZoom = _mapController.camera.zoom;
                      _mapController.move(
                        _mapController.camera.center,
                        currentZoom - 1,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // My Location Button
                  _buildControlButton(
                    icon: Icons.my_location,
                    color: Colors.blue,
                    onTap: () {
                      if (cubit.hasLocationPermission) {
                        _mapController.move(cubit.currentPosition, 15.0);
                      } else {
                        cubit.requestLocationPermission();
                      }
                    },
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (isLoading)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('جاري تحديد الموقع...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color ?? Colors.black87, size: 24),
      ),
    );
  }
}
