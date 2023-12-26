import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';

class ManualSwitcherWidget extends StatelessWidget {
  final VoidCallback onEntradaTap;
  final VoidCallback onSaidaTap;
  final bool isEntradaSelected;
  final bool isSaidaSelected;

  const ManualSwitcherWidget({
    Key? key,
    required this.onEntradaTap,
    required this.onSaidaTap,
    required this.isEntradaSelected,
    required this.isSaidaSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 8, 16),
      child: Row(
        children: [
          Flexible(
            child: GestureDetector(
              onTap: onEntradaTap,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isEntradaSelected ? CQColors.iron100 : Colors.white,
                  border: Border.all(
                    color: CQColors.iron100,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Entrada',
                  overflow: TextOverflow.ellipsis,
                  style: CQTheme.h3.copyWith(
                    color: isEntradaSelected ? Colors.white : CQColors.iron100,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: onSaidaTap,
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isSaidaSelected ? CQColors.iron100 : Colors.white,
                  border: Border.all(
                    color: CQColors.iron100,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Saída',
                  overflow: TextOverflow.ellipsis,
                  style: CQTheme.h3.copyWith(
                    color: isSaidaSelected ? Colors.white : CQColors.iron100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
