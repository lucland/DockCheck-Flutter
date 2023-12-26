import 'package:flutter/material.dart';

class _ScheduleConstants {
  const _ScheduleConstants();

  final EdgeInsets sectionPadding = const EdgeInsets.symmetric(vertical: 19);
  final EdgeInsets iconPadding = const EdgeInsets.only(left: 16);
  final EdgeInsets titlePadding = const EdgeInsets.symmetric(horizontal: 16);
}

class AreasEnum {
  static const String saida = 'Saída';
  static const String entrada = 'Entrada';
  static const String conves = 'Convés';
  static const String pracaDeMaquinas = 'Praça de Máquinas';
  static const String casario = 'Casario';

  static const List<String> areas = [conves, pracaDeMaquinas, casario];

  static String getArea(int index) {
    return areas[index];
  }
}
