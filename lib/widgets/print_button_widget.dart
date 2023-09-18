import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/ui/colors.dart';
import '../utils/ui/strings.dart';

class PrintButtonWidget extends StatelessWidget {
  const PrintButtonWidget({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: CQColors.iron100),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.upload_file,
                color: CQColors.iron100,
                size: 24,
              ),
              Text(CQStrings.imprimirQRCode,
                  overflow: TextOverflow.ellipsis, style: CQTheme.h3),
              SizedBox(
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
