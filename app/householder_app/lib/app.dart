import 'package:flutter/material.dart';

class ItersapiensHouseholderApp extends StatefulWidget {
  const ItersapiensHouseholderApp({super.key});

  @override
  State<ItersapiensHouseholderApp> createState() =>
      _ItersapiensHouseholderAppState();
}

class _ItersapiensHouseholderAppState extends State<ItersapiensHouseholderApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
