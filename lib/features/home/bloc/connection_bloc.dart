import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// State
class ConnectionState {
  final bool isConnectionLost;
  const ConnectionState({this.isConnectionLost = false});
}

// Events
abstract class ConnectionEvent {}

class ConnectionLost extends ConnectionEvent {}

class ConnectionRestored extends ConnectionEvent {}

// Bloc
class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  ConnectionBloc() : super(const ConnectionState()) {
    on<ConnectionLost>((event, emit) {
      debugPrint('Connection lost event received');
      emit(const ConnectionState(isConnectionLost: true));
    });
    on<ConnectionRestored>(
      (event, emit) => emit(const ConnectionState(isConnectionLost: false)),
    );
  }
}
