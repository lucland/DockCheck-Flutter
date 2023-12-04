//Action Enum returning the action type as string
String actionEnumToString(int action) {
  switch (action) {
    case 0:
      return "Checkin";
    case 1:
      return "Checkout";
    case 2:
      return "Checkout Evento";
    case 3:
      return "Checkout Manual";
    case 4:
      return "Usuario Criado";
    case 5:
      return "Usuario Bloqueado";
    default:
      return "Unknown";
  }
}
