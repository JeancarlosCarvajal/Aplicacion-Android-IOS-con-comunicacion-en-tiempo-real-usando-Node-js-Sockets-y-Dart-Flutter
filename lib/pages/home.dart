import 'dart:io';

import 'package:a_brand_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 2),
    Band(id: '3', name: 'Heroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
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
    return Dismissible(
      key: UniqueKey(),// tenia Key(band.id)
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('direction: $direction');
        print('direction: ${band.id}');
        // TODO llamar y borrar del server
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
          print(band.name);
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
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: null));
      setState(() { });

    }
    // para cerrar el dialogo
    Navigator.pop(context);
  }
}