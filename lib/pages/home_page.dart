import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Home Page HAiii')));
  }
}
