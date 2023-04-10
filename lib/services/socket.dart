import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  final IO.Socket _socket = IO.io('http://localhost:3000/', {
    'transports': ['websocket'],
    'autoConnect': true,
  });

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    _setup();
  }

  void _setup() {
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('message', (payload) {
      print('nombre: ${payload['nombre']}');
      print('mensaje: ${payload['mensaje']}');
      print(payload.containsKey('mensaje2')
          ? payload['mensaje2']
          : 'no hay un mensaje 2');
      notifyListeners();
    });

    _socket.on('active-bands', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
