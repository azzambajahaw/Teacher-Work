import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:done/widgets/TextFieldS.dart';

// Define a model class for posting a new lesson
class NewQuestion {
  final String text;
  final String studentname; // Treating this as text for simplicity
// Treating this as text for simplicity

  NewQuestion({
    required this.text,
    required this.studentname,

  });

  Map<String, dynamic> toJson() {
    return {
      'LessonTitle': text,
      'LessonFile': studentname,

    };
  }
}

// Function to post a new lesson
Future<void> postLesson(NewQuestion newQuestion) async {


  final uri = Uri.parse(
      'http://10.0.2.2/finalpro/add_question.php'); // Replace with your API URL
  //final headers = {'Content-Type': 'application/json'};
  //final body = jsonEncode(NewQuestion.toJson());
  final body = {
    'StudentQeustionText': newQuestion.text,
    //'LessonDate': NewQuestion.date,
    'StdentName': newQuestion.studentname,

  };
  //final x = jsonDecode(body);
  print(body);

  final response = await http.post(uri, /*headers: headers,*/ body: body);

  if (response.statusCode == 200) {
    print('Question posted successfully!');
  } else {
    throw Exception('Failed to post Question');
  }
}

class PostQuestionPage extends StatefulWidget {
  const PostQuestionPage({Key? key}) : super(key: key);

  @override
  State<PostQuestionPage> createState() => _PostQuestionPageState();
}

class _PostQuestionPageState extends State<PostQuestionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Lesson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFields(
              controller: _titleController,
              hitext: 'Write Question',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 12.0),
            TextFields(
              controller: _fileController,
              hitext: 'Write your name',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                print('Title: ${_titleController.text}');
                print('File: ${_fileController.text}');
                final newQuestion = NewQuestion(
                  text: _titleController.text,
                  studentname: _fileController.text,
                );
                postLesson(newQuestion).then((_) {
                  // Clear text fields after posting
                  _titleController.clear();
                  _fileController.clear();
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
    _titleController.dispose();
    _fileController.dispose();
    super.dispose();
  }
}
