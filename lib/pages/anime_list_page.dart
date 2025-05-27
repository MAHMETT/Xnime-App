import 'package:flutter/material.dart';

class AnimeListPage extends StatefulWidget {
  const AnimeListPage({super.key});

  @override
  State<AnimeListPage> createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Explore Page')));
  }
}
