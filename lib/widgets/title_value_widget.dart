import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/ui/colors.dart';

class TitleValueWidget extends StatelessWidget {
  const TitleValueWidget({
    super.key,
    required this.title,
    required this.value,
    this.color = Colors.black,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: CQTheme.body.copyWith(
            color: CQColors.slate100,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: CQTheme.h3.copyWith(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
