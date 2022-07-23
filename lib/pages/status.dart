import 'package:a_brand_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
   
  const StatusPage({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Center(child: Text('Server Status: ${socketService.serverStatus}'))
          ] 
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          socketService.emit(
            'emitir-mensaje', {
              'nombre':'Jeancarlos', 
              'apellido':'Carvajal'
            }
          );          
        }),
        child: const Icon(Icons.send),
      ),
    );
  }
}


