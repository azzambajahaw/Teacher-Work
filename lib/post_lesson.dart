import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:done/widgets/TextFieldS.dart';

// Define a model class for posting a new lesson
class NewLesson {
  final String lessonTitle;
  final String lessonFile; // Treating this as text for simplicity
  final String lessonLink; // Treating this as text for simplicity

  NewLesson({
    required this.lessonTitle,
    required this.lessonFile,
    required this.lessonLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'LessonTitle': lessonTitle,
      'LessonFile': lessonFile,
      'Lessonlink': lessonLink,
    };
  }
}

// Function to post a new lesson
Future<void> postLesson(NewLesson newLesson) async {
  print(newLesson.lessonTitle);

  final uri = Uri.parse(
      'http://10.0.2.2/finalpro/add_lessons.php'); // Replace with your API URL
  //final headers = {'Content-Type': 'application/json'};
  //final body = jsonEncode(newLesson.toJson());
  final body = {
    'LessonTitle': newLesson.lessonTitle,
    //'LessonDate': newLesson.date,
    'LessonFile': newLesson.lessonFile,
    'Lessonlink': newLesson.lessonLink,
  };
  //final x = jsonDecode(body);
  //print(x);

  final response = await http.post(uri, /*headers: headers,*/ body: body);

  if (response.statusCode == 200) {
    print('Lesson posted successfully!');
  } else {
    throw Exception('Failed to post lesson');
  }
}

class PostLessonPage extends StatefulWidget {
  const PostLessonPage({Key? key}) : super(key: key);

  @override
  State<PostLessonPage> createState() => _PostLessonPageState();
}

class _PostLessonPageState extends State<PostLessonPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Qustion'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFields(
              controller: _titleController,
              hitext: 'Lesson Title',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 12.0),
            TextFields(
              controller: _fileController,
              hitext: 'File (e.g., PDF)',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 12.0),
            TextFields(
              controller: _linkController,
              hitext: 'Youtube url',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                print('Title: ${_titleController.text}');
                print('File: ${_fileController.text}');
                print('Link: ${_linkController.text}');
                final newLesson = NewLesson(
                  lessonTitle: _titleController.text,
                  lessonFile: _fileController.text,
                  lessonLink: _linkController.text,
                );
                postLesson(newLesson).then((_) {
                  // Clear text fields after posting
                  _titleController.clear();
                  _fileController.clear();
                  _linkController.clear();
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
    _linkController.dispose();
    super.dispose();
  }
}
