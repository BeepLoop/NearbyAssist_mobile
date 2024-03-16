import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/feature_flag_service.dart';
import 'package:nearby_assist/services/vendor_service.dart';
import 'package:nearby_assist/widgets/review_counter_bar.dart';
import 'package:nearby_assist/widgets/vendor_header.dart';
import 'package:nearby_assist/widgets/vendor_photos.dart';

class Vendor extends StatefulWidget {
  const Vendor({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<Vendor> createState() => _Vendor();
}

class _Vendor extends State<Vendor> {
  @override
  void initState() {
    super.initState();

    if (getIt.get<FeatureFlagService>().backendConnection) {
      getIt.get<VendorService>().fetchServiceInfo(widget.serviceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          Center(
            child: ListenableBuilder(
              listenable: getIt.get<VendorService>(),
              builder: (context, child) {
                final isVisible = !getIt.get<VendorService>().isLoading();
                final serviceData = getIt.get<VendorService>().getServiceInfo();

                return Visibility(
                  replacement: const CircularProgressIndicator(),
                  visible: isVisible,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VendorHeader(
                          vendorId: serviceData != null ? serviceData.id : 1,
                        ),
                        VendorPhotos(
                          vendorId: serviceData != null ? serviceData.id : 1,
                        ),
                        const SizedBox(height: 20),
                        const Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean non placerat sapien, vel dictum ante. Suspendisse nec lectus pretium, tempor nulla quis, varius libero. Quisque porta arcu id feugiat fringilla. Nulla non gravida lacus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Wrap(
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            ReviewCounterBar(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
