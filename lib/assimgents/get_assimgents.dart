// Import required widgets
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_assimgents.dart';

//Define a model class for the lesson data

class Homework {
  final String title;
  final String text;
  final String deadline;
  final String date;
  final String degree;

  Homework({
    required this.title,
    required this.text,
    required this.deadline,
    required this.date,
    required this.degree,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      title: json['HomeWorkTitle'],
      text: json['HomeWorkText'],
      deadline: json['HomeWorkDedline'],
      date: json['HomeWorkDate'],
      degree: json['HomeWorkDegree'],
    );
  }
}

late SharedPreferences _prefs;
bool isAdmin = false;

// Function to fetch lessons data from an API
Future<List<Homework>> fetchHomework() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2/finalpro/get_homework.php'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Homework.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load homework');
  }
}

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({Key? key}) : super(key: key);

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  Future<List<Homework>>? _homework;

  @override
  void initState() {
    super.initState();
    _homework = fetchHomework(); // Fetch homework on initialization
    _initSharedPreferences();
  }
    void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = _prefs.getBool("R") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework'),
        backgroundColor: Colors.blue[900],
        actions: [
          // Opacity(
          //   opacity: isAdmin ? 1.0 : 0.0,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Navigate to the PostLessonPage when the button is pressed
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => PostHomeworkPage()),
          //       );
          //     },
          //     child: const Text('Post a assigment'),
          //   ),
          // ),
        ],
      ),
      body: FutureBuilder<List<Homework>>(
        future: _homework,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final homeworkList = snapshot.data!;
            return ListView.builder(
              itemCount: homeworkList.length,
              itemBuilder: (context, index) {
                final homework = homeworkList[index];
                return HomeworkCard(
                    homework: homework); // Display each homework in a card
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}')); // Handle errors
          }
          // Display a loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        },
      ),
              floatingActionButton: Opacity(
          opacity:isAdmin ? 1.0 : 0.0 ,
          child: FloatingActionButton(
            onPressed: (){
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostHomeworkPage()),
                  );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
              ),
        ),
    );
  }
}

// Widget to display a single lesson card
class HomeworkCard extends StatelessWidget {
  final Homework homework;

  const HomeworkCard({Key? key, required this.homework}) : super(key: key);

  void _deleteHomework(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/finalpro/delete_homework.php'),
        body: {'HomeWorkTitle': homework.title},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Homework deleted successfully')),
        );
        // Refresh the page after deletion
        MaterialPageRoute(builder: (context) => HomeworkPage());
      } else {
        throw Exception('Failed to delete homework');
      }
    } catch (e) {
      print('Error deleting homework: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete homework: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
              color:Colors.blueGrey[200]
              ),
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homework.date, style: const TextStyle(fontSize: 12)),
                    Container(
                      height: 40,
                      child: Opacity(
                      opacity: isAdmin ? 1.0 : 0.0,
                      child: ElevatedButton(
                        onPressed: () => _deleteHomework(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                        ),
                        child:  const Icon(Icons.delete),
                      ),
                                      ),
                    ),
            
                ],
              ),
            ),
            
            SizedBox(height: 8.0),
            
            Container(
              width: 700,
              height: 40,
              decoration: BoxDecoration(
              color:Colors.grey[200]
              
              ),
              child: Text('Deadline: ${homework.deadline}',
                  style: const TextStyle( fontSize: 20),
                  ),    
            ),

            SizedBox(height: 8.0),

            Container(
              width: 700,
              height: 40,
              decoration: BoxDecoration(
              color:Colors.grey[200]
              
              ),
              child: Text('Description: ${homework.title}',
               style: const TextStyle(fontSize: 18))),
            
          ],
        ),
      ),
    );
  }
}
