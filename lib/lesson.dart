// Import required widgets
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import 'package:url_launcher/url_launcher.dart';
import 'post_lesson.dart';
import 'addusers/add_signup.dart';
import 'addusers/get_signup.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a model class for the lesson data
class Lesson {
  final String title;
  final String date;
  final String pdfUrl;
  final String youtubeUrl;

  const Lesson({
    required this.title,
    required this.date,
    required this.pdfUrl,
    required this.youtubeUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['LessonTitle'],
      date: json['LessonDate'],
      pdfUrl: json['LessonFile'],
      youtubeUrl: json['Lessonlink'],
    );
  }
}

late SharedPreferences _prefs;
bool isAdmin = false;


// Function to fetch lessons data from an API
Future<List<Lesson>> fetchLessons() async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2/finalpro/get_lessons.php')); // Replace with your actual API URL
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Lesson.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load lessons');
  }
}

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key? key}) : super(key: key);

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  Future<List<Lesson>>? _lessons;

  @override
  void initState() {
    super.initState();
    _lessons = fetchLessons(); // Fetch lessons on initialization
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
        title: const Text('get Lesson'),
        backgroundColor: Colors.blue[900],
        actions: [

          Opacity(
            opacity: isAdmin ? 1.0 : 0.0,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the PostLessonPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text('Students'),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Lesson>>(
        future: _lessons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lessons = snapshot.data!;
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return LessonCard(
                    lesson: lesson); // Display each lesson in a card
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
                    MaterialPageRoute(builder: (context) => PostLessonPage()),
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
class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({Key? key, required this.lesson}) : super(key: key);

  void _deleteLesson(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/finalpro/delete_lessons.php'),
        body: {
          'LessonTitle': lesson.title
        }, // Adjust based on your API requirements
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lesson deleted successfully')),
        );
        MaterialPageRoute(builder: (context) => LessonsPage());
      } else {
        throw Exception('Failed to delete lesson');
      }
    } catch (e) {
      print('Error deleting lesson: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete lesson: $e')),
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
              Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lesson.date, style: TextStyle(fontSize: 10)),
                Text(lesson.title, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
            // Text(lesson.title, style: const TextStyle(fontSize: 18)),
            // Text(lesson.date, style: const TextStyle(color: Colors.grey)),
            SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(border: Border(top:BorderSide(color: Colors.black , width: 2))),
              child: Image.asset("assets/login2.jpg" , fit: BoxFit.cover,)),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 170,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () =>
                        launchUrl(lesson.pdfUrl), // Open PDF in a web view
                    child: const Text('Open PDF'),
                    
                  ),
                ),
                Container(
                  width: 170,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () =>
                        launchUrl(lesson.youtubeUrl), // Open YouTube link
                    child: const Text('YouTube'),
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 8.0),
            Container(
              width: 400,
              height: 40,
              child: Opacity(
                    opacity: isAdmin ? 1.0 : 0.0,
                    child: ElevatedButton(
                      onPressed: () =>
                          _deleteLesson(context), // Call delete function
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}

// Function to launch a URL in a web view (replace with your preferred method)
void launchUrl(String url) async {
  if (!await canLaunchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
  // ignore: deprecated_member_use
  await launch(url);
}
