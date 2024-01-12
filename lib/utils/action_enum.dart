//Action Enum returning the action type as string
String actionEnumToString(int action) {
  switch (action) {
    case 0:
      return "Usuário Criado";
    case 1:
      return "Check-in";
    case 2:
      return "Check-out";
    case 3:
      return "Avistado";
    case 4:
      return "Bloqueado";
    case 5:
      return "Entrada Manual";
    case 6:
      return "Saída Manual";
    case 7:
      return "Perdido";
    case 8:
      return "Indefinido";

    default:
      return "Desconhecido";
  }
}
