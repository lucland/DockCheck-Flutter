import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final Map<DeviceIdentifier, StreamControllerReemit<bool>> _cglobal = {};
final Map<DeviceIdentifier, StreamControllerReemit<bool>> _dglobal = {};

/// connect & disconnect + update stream
extension Extra on BluetoothDevice {
  // convenience
  StreamControllerReemit<bool> get _cstream {
    _cglobal[remoteId] ??= StreamControllerReemit(initialValue: false);
    return _cglobal[remoteId]!;
  }

  // convenience
  StreamControllerReemit<bool> get _dstream {
    _dglobal[remoteId] ??= StreamControllerReemit(initialValue: false);
    return _dglobal[remoteId]!;
  }

  // get stream
  Stream<bool> get isConnecting {
    return _cstream.stream;
  }

  // get stream
  Stream<bool> get isDisconnecting {
    return _dstream.stream;
  }

  // connect & update stream
  Future<void> connectAndUpdateStream() async {
    _cstream.add(true);
    try {
      await connect(mtu: null);
    } finally {
      _cstream.add(false);
    }
  }

  // disconnect & update stream
  Future<void> disconnectAndUpdateStream({bool queue = true}) async {
    _dstream.add(true);
    try {
      await disconnect(queue: queue);
    } finally {
      _dstream.add(false);
    }
  }
}

class StreamControllerReemit<T> {
  T? _latestValue;

  final StreamController<T> _controller = StreamController<T>.broadcast();

  StreamControllerReemit({T? initialValue}) : _latestValue = initialValue;

  Stream<T> get stream {
    return _latestValue != null
        ? _controller.stream.newStreamWithInitialValue(_latestValue as T)
        : _controller.stream;
  }

  T? get value => _latestValue;

  void add(T newValue) {
    _latestValue = newValue;
    _controller.add(newValue);
  }

  Future<void> close() {
    return _controller.close();
  }
}

// return a new stream that imediately emits an initial value
extension _StreamNewStreamWithInitialValue<T> on Stream<T> {
  Stream<T> newStreamWithInitialValue(T initialValue) {
    return transform(_NewStreamWithInitialValueTransformer(initialValue));
  }
}

// Helper for 'newStreamWithInitialValue' method for streams.
class _NewStreamWithInitialValueTransformer<T>
    extends StreamTransformerBase<T, T> {
  final T initialValue;

  _NewStreamWithInitialValueTransformer(this.initialValue);

  @override
  Stream<T> bind(Stream<T> stream) {
    if (stream.isBroadcast) {
      return _bind(stream).asBroadcastStream();
    } else {
      return _bind(stream);
    }
  }

  Stream<T> _bind(Stream<T> stream) {
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;

    controller = StreamController<T>(
      onListen: () {
        // Emit the initial value
        controller?.add(initialValue);

        subscription = stream.listen(
          controller?.add,
          onError: (Object error) {
            controller?.addError(error);
            controller?.close();
          },
          onDone: controller?.close,
        );
      },
      onPause: ([Future<dynamic>? resumeSignal]) {
        subscription?.pause(resumeSignal);
      },
      onResume: () {
        subscription?.resume();
      },
      onCancel: () {
        return subscription?.cancel();
      },
      sync: true,
    );

    return controller.stream;
  }
}
