import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('AI Assisted Music Production'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Language'),
                Tab(text: 'Genre'),
                Tab(text: 'Lyrics'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LanguageTab(),
              GenreTab(),
              LyricsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageTab extends StatelessWidget {
  const LanguageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Language',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class GenreTab extends StatelessWidget {
  const GenreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Genre',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class LyricsTab extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController lyricsController = TextEditingController();

  LyricsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Describe the song you would like to produce',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await generateLyrics(descriptionController.text, lyricsController);
            },
            child: Text('Create/Update Lyrics'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: lyricsController,
            maxLines: 10,
            decoration: InputDecoration(
              labelText: 'Generated Lyrics',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> generateLyrics(String prompt, TextEditingController lyricsController) async {
  print('Sending request to generate lyrics...');
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/lyrics/generate_lyrics/'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {'prompt': prompt},
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Lyrics: ${data['lyrics']}');
    lyricsController.text = data['lyrics'];
  } else {
    print('Failed to generate lyrics. Status code: ${response.statusCode}');
  }
}
