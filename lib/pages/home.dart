import 'dart:io';

import 'package:a_brand_names/models/band.dart';
import 'package:a_brand_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
   
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1', name: 'Metalica', votes: 5),
    // Band(id: '2', name: 'Queen', votes: 2),
    // Band(id: '3', name: 'Heroes del Silencio', votes: 2),
    // Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload){
      print(payload);
      this.bands = (payload as List) // no se sabe que retorna pero con payload as List se establece una lista
        .map((band) => Band.fromMap(band)) // la lista tiene elementos que son mapas, y lo convertimos cada uno en una Banda
        .toList(); // lo llevamos a to list. para llevar de mapa a lista iterable en Flutter

      // redibujamos el widgte para obtener la lista de bandas desde el sockets
      setState(() {});
    });
    super.initState();
  }
  
  @override
  void dispose() {
    // hacer una limpieza
    // eliminar la conexion a bandas cuando ya no lo necesite
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online 
              ? const Icon(Icons.online_prediction , color: Color.fromARGB(255, 47, 0, 255), size: 40)
              : const Icon(Icons.wifi_tethering_off_outlined , color: Color.fromARGB(255, 252, 17, 0), size: 40) 
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTitle(bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBar,
        child: const Icon(Icons.add),
      //    () {
        
      // },
      ),
    );
  }

  Widget _bandTitle(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),// tenia Key(band.id)
      direction: DismissDirection.startToEnd,
      onDismissed: (_){ 
        print('Borrar : ${band.id}');
        //  llamar y borrar del server
        socketService.emit('delete-band', { 'id': band.id } );
        setState(() { });
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white))
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0,2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: (){
          print(band.id);
          socketService.emit('vote-band', { 'id': band.id });
          setState(() {});
        },
      ),
    );
  }



  addNewBar(){
    print('Mostrando Dialogo de texto');

    // para controlar lo que se escribe
    final TextEditingController textController = new TextEditingController();

    if(Platform.isAndroid){
      // Android
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band Name'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBarToList(textController.text),
                child: const Text('Add')
              )
            ],
          );
        }
      );
    }

    // sino es android corre este codigo para IOS
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('New Band Name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            // en IOS se hace click afuera y no se cierra el dialogo por lo tanto se debe colorcar otro boton para cerrar
            CupertinoDialogAction(
              isDefaultAction: true, // se mira mejor la accion del boton
              child: Text('Add'),
              onPressed: () => addBarToList(textController.text),
            ),
            CupertinoDialogAction(
              isDefaultAction: true, // se mira mejor la accion del boton
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      }
    );
  }

  void addBarToList( String name ){
    print(name);
    if( name.length > 1 ){
      // podemos agregarlo al sockets
      // this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: null)); // tenia en duro para pruebas
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', { 'name': name });
      setState(() { });

    }
    // para cerrar el dialogo
    Navigator.pop(context);
  }
}