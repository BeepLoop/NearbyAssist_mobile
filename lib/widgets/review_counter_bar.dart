import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/vendor_service.dart';

class ReviewCounterBar extends StatefulWidget {
  const ReviewCounterBar({super.key});

  @override
  State<ReviewCounterBar> createState() => _ReviewCounterBar();
}

class _ReviewCounterBar extends State<ReviewCounterBar> {
  final serviceData = getIt.get<VendorService>().getServiceInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20, child: Text('5')),
            Expanded(
              child: LinearProgressIndicator(
                value: serviceData != null
                    ? computeEquivalence(serviceData!.reviewCountMap[5]!)
                    : 0,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('4')),
            Expanded(
              child: LinearProgressIndicator(
                value: serviceData != null
                    ? computeEquivalence(serviceData!.reviewCountMap[4]!)
                    : 0,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('3')),
            Expanded(
              child: LinearProgressIndicator(
                value: serviceData != null
                    ? computeEquivalence(serviceData!.reviewCountMap[3]!)
                    : 0,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('2')),
            Expanded(
              child: LinearProgressIndicator(
                value: serviceData != null
                    ? computeEquivalence(serviceData!.reviewCountMap[2]!)
                    : 0,
                minHeight: 8,
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 20, child: Text('1')),
            Expanded(
              child: LinearProgressIndicator(
                value: serviceData != null
                    ? computeEquivalence(serviceData!.reviewCountMap[1]!)
                    : 0,
                minHeight: 8,
              ),
            )
          ],
        ),
      ],
    );
  }

  double computeEquivalence(int reviewCount) {
    return reviewCount * 1.0 / 5.0;
  }
}
