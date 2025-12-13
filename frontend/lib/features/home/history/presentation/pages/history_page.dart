import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key); // no token

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> sessions = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/game-sessions'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sessions = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load sessions. Status: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : sessions.isEmpty
          ? const Center(child: Text("No sessions found"))
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(session['game_name'] ?? 'Unknown Game'),
                    subtitle: Text(
                      "Played on: ${session['played_at'] ?? 'Unknown'}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
