import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:done/widgets/TextFieldS.dart';

// Define a model class for posting a new lesson
class NewHomework {
  final String homeWorkTitle;
  final String homeWorkText; // Treating this as text for simplicity
  final String homeWorkDedline;
  final String homeWorkDegree;
 

  NewHomework({
    required this.homeWorkTitle,
    required this.homeWorkText,
    required this.homeWorkDedline,
    required this.homeWorkDegree,

  });

  Map<String, dynamic> toJson() {
    return {
      'homeWorkTitle': homeWorkTitle,
      'homeWorkText': homeWorkText,
      'homeWorkDedline': homeWorkDedline,
      'homeWorkDegree': homeWorkDegree,
    };
  }
}

// Function to post a new lesson
Future<void> postLesson(NewHomework newLesson) async {
  //print(newLesson.lessonTitle);

  final uri = Uri.parse(
      'http://10.0.2.2/finalpro/add_homework.php'); // Replace with your API URL
  //final headers = {'Content-Type': 'application/json'};
  //final body = jsonEncode(newLesson.toJson());
  final body = {
      'homeWorkTitle':   newLesson.homeWorkTitle,
      'homeWorkText':    newLesson.homeWorkText,
      'homeWorkDedline': newLesson.homeWorkDedline,
      'homeWorkDegree':  '55',
  };
  //final x = jsonDecode(body);
  print(body);

  final response = await http.post(uri, /*headers: headers,*/ body: body);

  if (response.statusCode == 200) {
    print('homework posted successfully!');
  } else {
    throw Exception('Failed to post homework');
  }
}

class PostHomeworkPage extends StatefulWidget {
  const PostHomeworkPage({Key? key}) : super(key: key);

  @override
  State<PostHomeworkPage> createState() => _PostHomeworkPageState();
}

class _PostHomeworkPageState extends State<PostHomeworkPage> {
  final TextEditingController _homeWorkTitleController = TextEditingController();
  final TextEditingController _homeWorkTextController = TextEditingController();
  final TextEditingController _homeWorkDedlineController = TextEditingController();
  final TextEditingController _homeWorkDegreeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Assignment'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFields(
              controller : _homeWorkTitleController,
              hitext: 'homeWorkTitle',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 12.0),
            TextFields(
              controller: _homeWorkTextController,
              hitext: 'homeWorkText',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 12.0),
            TextFields(
              controller: _homeWorkDedlineController,
              hitext: 'HomeWorkDeadLine',
              textinput: TextInputType.text,
              obsuc: false,

            ),
                        const SizedBox(height: 12.0),
            TextFields(
              controller: _homeWorkDegreeController,
              hitext: 'homeWorkDegree',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              
              onPressed: () {
                final newLesson = NewHomework(
                  homeWorkTitle: _homeWorkTitleController.text,
                  homeWorkText: _homeWorkTextController.text,
                  homeWorkDedline:  _homeWorkDedlineController.text,
                  homeWorkDegree: _homeWorkDegreeController.text,
                );
                postLesson(newLesson).then((_) {
                  // Clear text fields after posting
                  _homeWorkTitleController.clear();
                  _homeWorkTextController.clear();
                  _homeWorkDedlineController.clear();
                  _homeWorkDegreeController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Lesson posted successfully!')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to post lesson: $error')),
                  );
                });
              },
              child: const Text('Post Lesson'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _homeWorkTitleController.dispose();
    _homeWorkTextController.dispose();
    _homeWorkDedlineController.dispose();
    _homeWorkDegreeController.dispose();
    super.dispose();
  }
}
