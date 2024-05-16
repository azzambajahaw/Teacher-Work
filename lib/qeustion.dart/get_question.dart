// Import required widgets
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_question.dart';
import 'package:done/lesson.dart';


//Define a model class for the lesson data


class Qeustion {
  final String text;
  final String studentname;
  //final String studentQeustionDate;


  Qeustion({
    required this.text,
    required this.studentname,
  //  required this.studentQeustionDate,
  });

  factory Qeustion.fromJson(Map<String, dynamic> json) {
    return Qeustion(
      text: json['StudentQeustionText'],
      studentname: json['StdentName'],
      //studentQeustionDate: json['studentQeustionDate']
    );
  }
}

late SharedPreferences _prefs;
bool isAdmin = false;

// getprefs() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setBool("IsAdmin", true);
//   String? x = prefs.getString("username");
//   String? y = prefs.getString("password");
//   print(x);

//   isAdmin = "Admin" == x && "12345" == y;
// }



// Function to fetch lessons data from an API
Future<List<Qeustion>> fetchqeustuon() async {
  final response = await http.get(Uri.parse('http://10.0.2.2/finalpro/get_question.php'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Qeustion.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load qeustuon');
  }
}



class QeustionPage extends StatefulWidget {
  const QeustionPage({Key? key}) : super(key: key);

  @override
  State<QeustionPage> createState() => _QeustionPageState();
}

class _QeustionPageState extends State<QeustionPage> {
  Future<List<Qeustion>>? _qeustuon;

  @override
  void initState() {
    super.initState();
    _qeustuon = fetchqeustuon();
    _initSharedPreferences(); // Fetch qeustuon on initialization
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
        title: const Text('qeustuon'),
        backgroundColor: Colors.blue[900],
          actions: [
          // Opacity(
          //   opacity: isAdmin ? 1.0 : 0.0,
          //   child: ElevatedButton(
          //   onPressed: () {
          //     // Navigate to the PostLessonPage when the button is pressed
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => PostQuestionPage()),
          //     );
          //   },
          //   child: const Text('Post a Qeustion'),
          //         ),
          // ),
        ],
      ),
      body: FutureBuilder<List<Qeustion>>(
        future: _qeustuon,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final qeustionList = snapshot.data!;
            return ListView.builder(
              itemCount: qeustionList.length,
              itemBuilder: (context, index) {
                final qeustion = qeustionList[index];
                return QeustionCard(qeustion: qeustion); // Display each qeustuon in a card
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
                    MaterialPageRoute(builder: (context) => PostQuestionPage()),
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
class QeustionCard extends StatelessWidget {
  final Qeustion qeustion;

  const QeustionCard({Key? key, required this.qeustion}) : super(key: key);

  void _deleteqeustuon(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/finalpro/get_question.php'),
        body: {'StdentName': qeustion.studentname},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('question deleted successfully')),
        );
        // Refresh the page after deletion
        MaterialPageRoute(builder: (context) => QeustionPage());
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
                    '2024\\5\\4', style: const TextStyle(fontSize: 16)),
                    Container(
                      height: 40,
                      child: Opacity(
                      opacity: isAdmin ? 1.0 : 0.0,
                      child: ElevatedButton(
                        onPressed: () => _deleteqeustuon(context),
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
              child: Text('Question: ${qeustion.studentname}', style: const TextStyle(fontSize: 18))),
            SizedBox(height: 8.0),
            Container(
              width: 700,
              height: 40,
              decoration: BoxDecoration(
              color:Colors.grey[200]
              
              ),
              child:Text('Student name: ${qeustion.text}', style: const TextStyle(fontSize: 18))),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [

            //     Opacity(
            //       opacity: isAdmin ? 1.0 : 0.0,
            //       child: ElevatedButton(
            //         onPressed: () => _deleteqeustuon(context),
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all(Colors.red),
            //         ),
            //         child: const Text('Delete'),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

