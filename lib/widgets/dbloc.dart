import 'package:bloc/bloc.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final String itag;

  DeviceLoaded(this.itag);
}

class DeviceError extends DeviceState {
  final String errorMessage;

  DeviceError(this.errorMessage);
}

class DeviceCubit extends Cubit<DeviceState> {
  DeviceCubit() : super(DeviceInitial());

  void updateDeviceId(String itag) {
    emit(DeviceLoaded(itag));
  }

  void setError(String errorMessage) {
    emit(DeviceError(errorMessage));
  }
}
