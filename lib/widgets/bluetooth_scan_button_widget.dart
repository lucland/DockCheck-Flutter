import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/cadastrar/cubit/cadastrar_cubit.dart';
import '../pages/cadastrar/cubit/cadastrar_state.dart';
import '../utils/enums/beacon_button_enum.dart';
import '../utils/theme.dart';
import '../utils/ui/colors.dart';

class BluetoothScanButton extends StatelessWidget {
  final CadastrarCubit cubit;

  const BluetoothScanButton({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CadastrarCubit, CadastrarState>(
      builder: (context, state) {
        return _buildButton(context, state);
      },
    );
  }

  Widget _buildButton(BuildContext context, CadastrarState state) {
    String buttonText = '';
    Color buttonTextColor = Colors.black;
    Color buttonBackgroundColor = Colors.grey;
    Color buttonBorderColor = Colors.grey;
    VoidCallback? onPressed;

    switch (state.beaconButtonState) {
      case BeaconButtonState.Searching:
        buttonText = "Buscando Beacon";
        buttonTextColor = CQColors.iron100;
        buttonBackgroundColor = Colors.white;
        buttonBorderColor = CQColors.iron100;
        break;
      case BeaconButtonState.Register:
        buttonText = "Registrar Beacon";
        buttonTextColor = Colors.white;
        buttonBackgroundColor = CQColors.iron100;
        buttonBorderColor = CQColors.iron100;
        onPressed = () {
          context.read<CadastrarCubit>().updateiTag(state.selectedITagDevice);
        };
        break;
      case BeaconButtonState.Invalid:
        buttonText = "Beacon Inválido";
        buttonTextColor = Colors.white;
        buttonBackgroundColor = CQColors.danger100;
        buttonBorderColor = CQColors.danger100;
        break;
      case BeaconButtonState.Unlink:
        buttonText = "Desvincular Beacon";
        buttonTextColor = Colors.white;
        buttonBackgroundColor = CQColors.danger100;
        buttonBorderColor = CQColors.danger100;
        onPressed = () {
          context.read<CadastrarCubit>().resetBeaconScan();
        };
        break;
      default:
        return Container(); // Fallback for unhandled states
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: buttonBorderColor),
            borderRadius: BorderRadius.circular(8.0),
            color: buttonBackgroundColor,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(buttonText.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: CQTheme.h3.copyWith(color: buttonTextColor)),
              if (buttonText == "Buscando Beacon")
                const SizedBox(
                  width: 8,
                ),
              if (buttonText == "Buscando Beacon")
                const SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(
                    color: CQColors.iron100,
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
