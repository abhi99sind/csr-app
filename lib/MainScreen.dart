import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _connectionStatus = 'Unknown';
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CSR App",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: Scaffold(
        appBar: AppBar(title:Text("CSR APP"),
        ),
        body: Center(child: Text('Connection Status: $_connectionStatus')),
      ),
    );
  }
}
// class MainScreen extends StatelessWidget {
//   @override
//   
// }