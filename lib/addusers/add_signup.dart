import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:done/widgets/TextFieldS.dart';

// Define a model class for posting a new lesson
class NewUser {
  final String username;
  final String password; // Treating this as text for simplicity
// Treating this as text for simplicity

  NewUser({
    required this.username,
    required this.password,

  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,

    };
  }
}

// Function to post a new lesson
Future<void> postLesson(NewUser newUser) async {


  final uri = Uri.parse(
      'http://10.0.2.2/finalpro/signup.php'); // Replace with your API URL
  //final headers = {'Content-Type': 'application/json'};
  //final body = jsonEncode(NewQuestion.toJson());
  final body = {
    'username': newUser.username,
    //'LessonDate': NewQuestion.date,
    'password': newUser.password,

  };
  //final x = jsonDecode(body);
  print(body);

  final response = await http.post(uri, /*headers: headers,*/ body: body);

  if (response.statusCode == 200) {
    print('user posted successfully!');
  } else {
    throw Exception('Failed to post user');
  }
}

class PostUserPage extends StatefulWidget {
  const PostUserPage({Key? key}) : super(key: key);

  @override
  State<PostUserPage> createState() => _PostUserPageState();
}

class _PostUserPageState extends State<PostUserPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a user'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFields(
              controller: _titleController,
              hitext: 'Write user name',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 12.0),
            TextFields(
              controller: _fileController,
              hitext: 'Write your passord',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                print('Title: ${_titleController.text}');
                print('File: ${_fileController.text}');
                final newQuestion = NewUser(
                  username: _titleController.text,
                  password: _fileController.text,
                );
                postLesson(newQuestion).then((_) {
                  // Clear text fields after posting
                  _titleController.clear();
                  _fileController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('user posted successfully!')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to post user: $error')),
                  );
                });
              },
              child: const Text('Post user'),
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
