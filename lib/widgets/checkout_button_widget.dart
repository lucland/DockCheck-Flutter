import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/ui/colors.dart';
import '../utils/ui/strings.dart';

class CheckOutButtonWidget extends StatelessWidget {
  const CheckOutButtonWidget({
    super.key,
    required this.onPressed,
    this.isDisabled = false,
  });

  final void Function()? onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isDisabled ? CQColors.iron30 : CQColors.iron100,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: CQColors.white,
                size: 24,
              ),
              Text(
                CQStrings.checkOut,
                overflow: TextOverflow.ellipsis,
                style: CQTheme.h3.copyWith(color: CQColors.white),
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
