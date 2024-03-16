import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class VendorHeader extends StatefulWidget {
  const VendorHeader({super.key, required this.vendorId});

  final String vendorId;

  @override
  State<VendorHeader> createState() => _VendorHeader();
}

class _VendorHeader extends State<VendorHeader> {
  final vendorData = getIt.get<VendorService>().getVendor();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            children: [
              Image.asset(
                'assets/images/avatar.png',
                width: 60,
                height: 60,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendorData!.name),
                  RatingBar.builder(
                    initialRating: vendorData!.rating,
                    allowHalfRating: true,
                    itemSize: 20,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (_) {
                      debugPrint('rating update not allowed');
                    },
                    ignoreGestures: true,
                  ),
                  const Text(
                    'Plumber, Electrician',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(
                'chat',
                pathParameters: {'userId': widget.vendorId},
              );
            },
            icon: const Icon(
              Icons.message,
              size: 40,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
