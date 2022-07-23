import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO; 

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService extends ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this.socket.emit;

  SocketService(){
    // Dart client... ipconfig en la cmd: aqui busque mi ipv4 y cambie el localhost por mi ip 192.168.1.5
    // IPv4 Address. . . . . . . . . . . : 192.168.1.5
    _socket = IO.io('http://192.168.1.5:3000/',{
      'transports': ['websocket'],
      'autoConnect': true
    }); 
    this._initConfig();
  }

    void _initConfig() {  

      print('Hola desde el socket');  

      _socket.onConnect((_) {
        print('connect');
        this._serverStatus = ServerStatus.Online;
        notifyListeners();
      });

      _socket.onDisconnect((_) {
        print('onDisconnect');
        this._serverStatus = ServerStatus.Offline;
        notifyListeners();
      });

      // _socket.on('evento')  es una forma de hacerlo 
      _socket.on('emitir-mensaje', (payload) {
        print('emitir-mensaje: $payload');
        print('emitir-mensaje: ' + payload['nombre']);
        print( payload.containsKey('nombre') ? 'Tengo Nombre' : 'No tengo Nombre' );
      });




      _socket.onConnectTimeout((data) => print('timeout'));
      _socket.onError((_) => print('error'));
      _socket.onConnectError((_) => print('connect Error'));
      _socket.on('connect_error', (value) {print('connect error: ${value.toString()}');});
      
  
    }
 
}