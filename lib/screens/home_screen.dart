import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 5),
    Band(id: '3', name: 'Artic Monkeys', votes: 4),
    Band(id: '4', name: 'The Beatles', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addNewBand, elevation: 1, child: const Icon(Icons.add)),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete me'),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing:
            Text('Votes ${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New Band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => addBandToList(textController.text),
              ),
            ],
          );
        },
      );
    } else if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList(textController.text),
                child: const Text('Add'),
              )
            ],
          );
        },
      );
    }
  }

  addBandToList(String name) {
    if (name.isNotEmpty) {
      setState(() {
        bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      });
    }
    Navigator.pop(context);
  }
}
