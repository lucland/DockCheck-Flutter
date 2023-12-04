import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/ui/colors.dart';

class SyncButtonWidget extends StatelessWidget {
  const SyncButtonWidget({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                Icons.sync_rounded,
                color: CQColors.iron100,
                size: 24,
              ),
              Text('Sincronizar com portal',
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
