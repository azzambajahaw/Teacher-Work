// Import required widgets
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import 'package:url_launcher/url_launcher.dart';
import 'add_signup.dart';


//Define a model class for the lesson data


class Signup {
  final String userName;
  //final String passwor;
  //final String studentQeustionDate;


  Signup({
    required this.userName,
    //required this.passwor,
  //  required this.studentQeustionDate,
  });

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      userName: json['UserName'],
      //passwor: json['password'],
      //studentQeustionDate: json['studentQeustionDate']
    );
  }
}

// Function to fetch lessons data from an API
Future<List<Signup>> fetchqeustuon() async {
  final response = await http.get(Uri.parse('http://10.0.2.2/finalpro/get_user.php'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Signup.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load Users');
  }
}



class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Future<List<Signup>>? _signup;

  @override
  void initState() {
    super.initState();
    _signup = fetchqeustuon(); // Fetch qeustuon on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.blue[900],
          actions: [
        //   ElevatedButton(
        //   onPressed: () {
        //     // Navigate to the PostLessonPage when the button is pressed
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => PostUserPage()),
        //     );
        //   },
        //   child: const Text('add user'),
        // ),
        ],
      ),
      body: FutureBuilder<List<Signup>>(
        future: _signup,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final signupList = snapshot.data!;
            return ListView.builder(
              itemCount: signupList.length,
              itemBuilder: (context, index) {
                final qeustion = signupList[index];
                return SignupCard(signup: qeustion); // Display each qeustuon in a card
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
          opacity:true ? 1.0 : 0.0 ,
          child: FloatingActionButton(
            onPressed: (){
            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostUserPage()),
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
class SignupCard extends StatelessWidget {
  final Signup signup;

  const SignupCard({Key? key, required this.signup}) : super(key: key);

  void _deleteuser(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/finalpro/get_question.php'),
        body: {'qeustuonTitle': signup.userName},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('question deleted successfully')),
        );
        // Refresh the page after deletion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      } else {
        throw Exception('Failed to delete question');
      }
    } catch (e) {
      print('Error deleting question: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete question: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(signup.userName, style: const TextStyle(fontSize: 18)),
            ElevatedButton(
                  onPressed: () => _deleteuser(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Delete'),
                ),
          //  Text(signup.passwor, style: const TextStyle(fontSize: 18)),

          ],
        ),
      ),
    );
  }
}

