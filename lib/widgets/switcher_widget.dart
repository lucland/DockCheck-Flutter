import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../utils/ui/ui.dart';

class SwitcherWidget extends StatelessWidget {
  final void Function(String) onTap;
  final String activeArea;

  const SwitcherWidget(
      {super.key, required this.onTap, required this.activeArea});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () => onTap(AreasEnum.conves),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: activeArea == AreasEnum.conves
                    ? CQColors.iron100
                    : CQColors.white,
                border: Border.all(
                  color: CQColors.iron100,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AreasEnum.conves,
                overflow: TextOverflow.ellipsis,
                style: CQTheme.h3.copyWith(
                  color: activeArea == AreasEnum.conves
                      ? Colors.white
                      : CQColors.iron100,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () => onTap(AreasEnum.pracaDeMaquinas),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: activeArea == AreasEnum.pracaDeMaquinas
                    ? CQColors.iron100
                    : CQColors.white,
                border: Border.all(
                  color: CQColors.iron100,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AreasEnum.pracaDeMaquinas,
                overflow: TextOverflow.ellipsis,
                style: CQTheme.h3.copyWith(
                  color: activeArea == AreasEnum.pracaDeMaquinas
                      ? Colors.white
                      : CQColors.iron100,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () => onTap(AreasEnum.casario),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: activeArea == AreasEnum.casario
                    ? CQColors.iron100
                    : CQColors.white,
                border: Border.all(
                  color: CQColors.iron100,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                AreasEnum.casario,
                overflow: TextOverflow.ellipsis,
                style: CQTheme.h3.copyWith(
                  color: activeArea == AreasEnum.casario
                      ? Colors.white
                      : CQColors.iron100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
