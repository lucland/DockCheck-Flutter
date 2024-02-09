import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/ui/colors.dart';

class HomeListItemWidget extends StatelessWidget {
  const HomeListItemWidget({
    super.key,
    required this.name,
    required this.company,
    required this.number,
    required this.area,
    this.color = Colors.black,
  });

  final String name;
  final String area;
  final String company;
  final Color color;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                number.toUpperCase(),
                style: CQTheme.body.copyWith(
                  color: CQColors.iron100,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: CQTheme.body.copyWith(
                      color: CQColors.iron100,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    company.toUpperCase(),
                    style: CQTheme.body.copyWith(
                      color: CQColors.slate100,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(area,
                  style: CQTheme.h1
                      .copyWith(fontSize: 14, color: CQColors.success100)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: const Divider(),
        ),
      ],
    );
  }
}
