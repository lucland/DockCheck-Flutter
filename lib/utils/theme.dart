import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';

const double _kBorderRadius = 2.0;
const double _kDefaultElevation = 4.0;

class CQTheme {
  CQTheme._();

  static ThemeData theme = ThemeData(
    fontFamily: defaultFontName,
    textTheme: defaultTextTheme,
    appBarTheme: defaultAppBarTheme,
    tabBarTheme: defaultTabBarTheme,
    bottomAppBarTheme: defaultBottomAppBarTheme,
    scaffoldBackgroundColor: CQColors.background,
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: CQColors.iron100,
        onPrimary: CQColors.iron100,
        secondary: CQColors.slate100,
        onSecondary: CQColors.white,
        error: CQColors.danger100,
        onError: CQColors.danger100,
        background: CQColors.background,
        onBackground: CQColors.background,
        surface: CQColors.white,
        onSurface: CQColors.slate100),
  );

  static const String defaultFontName = 'ProximaNova';

  static const TextTheme defaultTextTheme = TextTheme(
    labelLarge: buttonTextStyle,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle title = TextStyle(
    color: CQColors.iron100,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle h1 = TextStyle(
    color: CQColors.iron100,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  );

  static const TextStyle h2 = TextStyle(
    color: CQColors.iron100,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle caption1 = TextStyle(
    color: CQColors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption2 = TextStyle(
    color: CQColors.iron60,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle body = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyIron100 = TextStyle(
    color: CQColors.iron100,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle selectedLabelTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: CQColors.iron100,
    fontFamily: 'ProximaNova',
  );

  static const TextStyle unselectLabelTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: CQColors.iron60,
    fontFamily: 'ProximaNova',
  );

  static const TextStyle headLineForange120 = TextStyle(
    color: CQColors.forange120,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const subhead1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static const subhead2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const TextStyle headLine = TextStyle(
    color: CQColors.iron100,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const TextStyle bodyGrey = TextStyle(
    color: CQColors.iron80,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle largeText = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  );

  static const TextStyle tabStyle = TextStyle(
    color: CQColors.iron80,
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );

  static const TextStyle tabStyleRed = TextStyle(
    color: CQColors.danger100,
    fontWeight: FontWeight.w600,
  );

  static const TextHeightBehavior textHeightBehavior = TextHeightBehavior(
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TabBarTheme defaultTabBarTheme = TabBarTheme(
    labelColor: CQColors.iron100,
    labelStyle: selectedLabelTextStyle,
    unselectedLabelColor: CQColors.iron60,
    unselectedLabelStyle: unselectLabelTextStyle,
    indicator: const BoxDecoration(
      border: Border(top: BorderSide(width: 2.0, color: CQColors.iron100)),
    ),
    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
    splashFactory: NoSplash.splashFactory,
  );

  static final AppBarTheme defaultAppBarTheme = AppBarTheme(
    backgroundColor: CQColors.white,
    surfaceTintColor: Colors.transparent,
    shadowColor: CQColors.slate110.withOpacity(0.18),
    titleTextStyle: title,
    elevation: _kDefaultElevation,
    scrolledUnderElevation: _kDefaultElevation,
  );

  static final AppBarTheme timesheetAppBarTheme = defaultAppBarTheme.copyWith(
    scrolledUnderElevation: 1.0,
    elevation: _kDefaultElevation,
  );

  static const BottomAppBarTheme defaultBottomAppBarTheme = BottomAppBarTheme(
    elevation: 1.0,
  );

  static final ButtonStyle buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 11.5,
      ),
    ),
  );

  static final ButtonStyle cancelButtonStyle = buttonStyle.copyWith(
    side: MaterialStateProperty.all(
      const BorderSide(color: CQColors.iron100),
    ),
  );

  static ButtonStyle animatedLoadingButtonStyle = buttonStyle.copyWith(
    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return CQColors.iron100.withOpacity(0.3);
        }
        return CQColors.slate100;
      },
    ),
  );

  static final ButtonStyle confirmationButtonStyle = buttonStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(CQColors.iron100),
  );

  static final ButtonStyle destructiveButtonStyle = buttonStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(CQColors.danger110),
  );

  static final ButtonStyle forangeCTAButtonStyle = buttonStyle.copyWith(
    backgroundColor: MaterialStateProperty.all(CQColors.forange20),
    side: MaterialStateProperty.all(
      const BorderSide(color: CQColors.forange110),
    ),
  );

  static final ButtonStyle clockButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CQColors.iron100),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    ),
  );

  static final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: CQColors.slate100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
    side: const BorderSide(width: 1, color: CQColors.slate100),
  );

  static final ButtonStyle textLinkOutlineButtonStyle =
      OutlinedButton.styleFrom(
    side: const BorderSide(color: CQColors.iron30),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2.0),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 9,
    ),
  );

  static final ButtonStyle phoneCallButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: CQColors.iron30,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
    side: const BorderSide(width: 1, color: CQColors.iron30),
  );

  static final BoxShadow defaultShadow = BoxShadow(
    color: CQColors.slate100.withOpacity(0.18),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(2, 0),
  );

  static final BoxShadow elevatedShadow = BoxShadow(
    color: CQColors.slate100.withOpacity(0.2),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(0, 2),
  );

  static final BoxShadow noteInputFieldShadow = BoxShadow(
    color: CQColors.slate100.withOpacity(0.1),
    spreadRadius: 0,
    blurRadius: 12,
    offset: const Offset(2, 0),
  );

  static const BoxShadow expandDescriptionButtonShadow = BoxShadow(
    color: CQColors.white,
    spreadRadius: 0,
    blurRadius: 13,
    offset: Offset(0, -5),
  );

  static const viewOnlyTagDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(_kBorderRadius)),
  );

  static final timesheetTimestampBadgeDecoration = BoxDecoration(
    color: CQColors.forange20,
    border: Border.all(color: CQColors.forange40),
    borderRadius: const BorderRadius.all(Radius.circular(_kBorderRadius)),
  );

  static const scheduleTentativeBadgeDecoration = BoxDecoration(
    color: CQColors.iron20,
    borderRadius: BorderRadius.all(Radius.circular(_kBorderRadius)),
  );

  static final cardDecoration = BoxDecoration(
    color: CQColors.white,
    borderRadius: const BorderRadius.all(Radius.circular(_kBorderRadius)),
    boxShadow: [CQTheme.defaultShadow],
  );

  static final outlinedCardDecoration = BoxDecoration(
    color: CQColors.white,
    border: Border.all(color: CQColors.iron20, width: 1),
    borderRadius: const BorderRadius.all(Radius.circular(_kBorderRadius)),
    boxShadow: [CQTheme.defaultShadow],
  );

  static final outlinedErrorCardDecoration = BoxDecoration(
    border: Border.all(color: CQColors.danger100, width: 1),
    borderRadius: const BorderRadius.all(Radius.circular(2)),
  );

  static const timesheetPinnedHeaderDecoration = BoxDecoration(
    color: CQColors.white,
    border: Border(
      bottom: BorderSide(
        color: CQColors.iron10,
        width: 1.0,
      ),
    ),
  );

  static final inputDecoration = InputDecoration(
    hintStyle: CQTheme.body.copyWith(
      color: CQColors.iron60,
      height: 1.4,
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: CQColors.iron30,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  );

  static const inputFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
    hintText: ' ',
    border: OutlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
  );

  static final inputCardDecoration = BoxDecoration(
    border: Border.all(color: CQColors.iron20),
    borderRadius: const BorderRadius.all(Radius.circular(2)),
  );

  static final kebabMenuStyle = MenuStyle(
    elevation: const MaterialStatePropertyAll(8),
    shadowColor: MaterialStatePropertyAll(
      CQColors.slate100.withOpacity(0.3),
    ),
    surfaceTintColor: MaterialStatePropertyAll(
      CQColors.slate100.withOpacity(0.3),
    ),
    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
    minimumSize: const MaterialStatePropertyAll(Size.zero),
    shape: const MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(_kBorderRadius)),
      ),
    ),
  );
}
