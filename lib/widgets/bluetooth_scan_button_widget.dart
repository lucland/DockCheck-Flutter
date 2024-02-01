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
        switch (state.beaconButtonState) {
          case BeaconButtonState.Search:
            return _buildButton(
                context,
                'Buscar Beacon',
                CQColors.iron100,
                Colors.white,
                CQColors.iron100,
                //
                true, () {
              context.read<CadastrarCubit>().startSearching();
            });
          case BeaconButtonState.Searching:
            return _buildButton(
                context,
                "Buscando Beacon",
                CQColors.iron100,
                Colors.white,
                CQColors.iron100,
                // ---
                false);
          case BeaconButtonState.Register:
            return _buildButton(
                context,
                "Registrar Beacon",
                Colors.white, // cor do texto
                CQColors.iron100, // cor do fundo
                CQColors.iron100, // cor da borda
                // ---
                true, () {
              context.read<CadastrarCubit>().updateiTag(state.scanResult!.id);
            });
          case BeaconButtonState.Invalid:
            return _buildButton(
                context,
                "Beacon Inválido",
                Colors.white,
                CQColors.danger100,
                CQColors.danger100,
                // ---
                false);
          case BeaconButtonState.Unlink:
            return _buildButton(
                context,
                "Desvincular Beacon",
                CQColors.danger100,
                Colors.white,
                CQColors.danger100,
                // ---
                true, () {
              context.read<CadastrarCubit>().resetBeacon();
            });
          default:
            return Container(); // Fallback for unhandled states
        }
      },
    );
  }

  Widget _buildButton(BuildContext context, String text, Color textColor,
      Color backgroundColor, Color borderColor, bool isEnabled,
      [VoidCallback? onPressed]) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8.0),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  text.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
              ),
              if (text == "Buscando Beacon")
                const SizedBox(
                  width: 8,
                ),
              if (text == "Buscando Beacon")
                const SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(
                    color: CQColors.iron80,
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
