import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Socket.io Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int dx = 500;
  int dy = 300;
  late Socket socket;

  @override
  void initState() {
    super.initState();
    _socketConnect();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$dx, $dy'),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/map.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: dy.toDouble(),
            left: dx.toDouble(),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _socketConnect() {
    socket = io(
      'http://192.168.137.78:5000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'message': 'bar'})
          .build(),
    );
    socket.connect();
    socket.onConnect((_) {
      print('Connected to socket.io server');
    });
    socket.onDisconnect((_) {
      print('Disconnected from socket.io server');
    });
    socket.on('fromServer', (data) {
      print('Received message from server: $data');
    });
    socket.on('dx', (data) {
      print('Received dx: $data');
      setState(() {
        dx = data;
      });
    });
    socket.on('dy', (data) {
      print('Received dy: $data');
      setState(() {
        dy = data;
      });
    });
  }
}
