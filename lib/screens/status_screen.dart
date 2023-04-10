import 'package:band_names/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Text('Servers Status ${socketService.serverStatus}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket
              .emit('message', {'message': 'Hola desde flutter'});
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
