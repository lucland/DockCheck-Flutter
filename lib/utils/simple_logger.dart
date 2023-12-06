// Based on https://github.com/mono0926/simple_logger

import 'dart:developer' as developer;
import 'package:clock/clock.dart';
import 'package:logging/logging.dart' show Level;

class SimpleLogger {
  static final shared = SimpleLogger._();

  SimpleLogger._();

  LoggerLevel _level = LoggerLevel.off;
  LoggerMode _mode = LoggerMode.print;

  void set({
    LoggerLevel? level,
    LoggerMode? mode,
  }) {
    _level = level ?? _level;
    _mode = mode ?? _mode;
  }

  final Map<Level, String> _levelPrefixes = {
    Level.FINEST: '👾 ',
    Level.FINER: '👀 ',
    Level.FINE: '🎾 ',
    Level.CONFIG: '🐶 ',
    Level.INFO: '👻 ',
    Level.WARNING: '⚠️ ',
    Level.SEVERE: '‼️ ',
    Level.SHOUT: '😡 ',
  };

  bool _isLoggable(LoggerLevel value) {
    return value.value >= _level.value;
  }

  String _format(LoggerInfo info) {
    return '${_levelInfo(info.level)}'
        '${_timeInfo(info.time)}'
        '${info.message}';
  }

  String _levelInfo(LoggerLevel level) {
    switch (_mode) {
      case LoggerMode.log:
        return '';
      case LoggerMode.print:
        return '${_levelPrefixes[level] ?? ''}$level ';
    }
  }

  String _timeInfo(DateTime time) {
    switch (_mode) {
      case LoggerMode.log:
        return '';
      case LoggerMode.print:
        return '$time ';
    }
  }

  void log(LoggerLevel level, Object message) {
    if (!_isLoggable(level)) {
      return;
    }

    String msg;
    if (message is Function()) {
      msg = message().toString();
    } else if (message is String) {
      msg = message;
    } else {
      msg = message.toString();
    }

    final info = LoggerInfo(
      level: level,
      time: clock.now(),
      message: msg,
    );

    final log = _format(info);
    switch (_mode) {
      case LoggerMode.log:
        developer.log(
          log,
          level: level.value,
          name: 'dock_check',
          time: info.time,
        );
        break;
      case LoggerMode.print:
        // ignore: avoid_print
        print(log);
    }
  }

  static void fine(Object message) =>
      SimpleLogger.shared.log(LoggerLevel.fine, message);

  static void info(Object message) =>
      SimpleLogger.shared.log(LoggerLevel.info, message);

  static void warning(Object message) =>
      SimpleLogger.shared.log(LoggerLevel.warning, message);

  static void severe(Object message) =>
      SimpleLogger.shared.log(LoggerLevel.severe, message);
}

enum LoggerMode {
  log,
  print,
}

class LoggerLevel {
  final Level _level;

  const LoggerLevel._(Level level) : _level = level;

  static const LoggerLevel all = LoggerLevel._(Level.ALL);
  static const LoggerLevel off = LoggerLevel._(Level.OFF);
  static const LoggerLevel finest = LoggerLevel._(Level.FINEST);
  static const LoggerLevel finer = LoggerLevel._(Level.FINER);
  static const LoggerLevel fine = LoggerLevel._(Level.FINE);
  static const LoggerLevel config = LoggerLevel._(Level.CONFIG);
  static const LoggerLevel info = LoggerLevel._(Level.INFO);
  static const LoggerLevel warning = LoggerLevel._(Level.WARNING);
  static const LoggerLevel severe = LoggerLevel._(Level.SEVERE);
  static const LoggerLevel shout = LoggerLevel._(Level.SHOUT);

  String get name => _level.name;
  int get value => _level.value;

  @override
  String toString() => _level.name;
}

class LoggerInfo {
  LoggerInfo({
    required this.level,
    required this.time,
    required this.message,
  });

  final LoggerLevel level;
  final DateTime time;
  final String message;
}
