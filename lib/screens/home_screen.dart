import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
  }

  _handleActiveBands(dynamic payload) {
    this.bands =
        (payload['bands'] as List).map((band) => Band.fromMap(band)).toList();
  }

  @override
  void dispose() {
    super.dispose();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
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
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.cancel, color: Colors.blue[300]),
          )
        ],
      ),
      body: Column(
        children: [
          if (bands.isNotEmpty) _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (_, index) => _bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addNewBand, elevation: 1, child: const Icon(Icons.add)),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
      background: Container(
        color: Colors.red,
        //
        child: const Align(
          alignment: Alignment.centerLeft,
          //
          child: Text('Delete me'),
        ),
      ),
      //
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing:
            Text('Votes ${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () =>
            socketService.socket.emit('add-vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isIOS) {
      //
      return showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('New Band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              //
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
              //
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
      width: double.infinity,
      height: 250,
      child: PieChart(dataMap: dataMap),
    );
  }
}
