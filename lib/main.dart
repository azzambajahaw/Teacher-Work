import 'dart:io';
import 'package:flutter/material.dart';
import 'lesson.dart';
import 'assimgents/get_assimgents.dart';
import 'qeustion.dart/get_question.dart';
import 'login.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track the selected index

  final List<Widget> _pages = [
    LessonsPage(),
    HomeworkPage(),
    QeustionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Questions',
          ),
        ],
      ),
    );
  }
}


// // Import required widgets
// import 'package:flutter/material.dart';

// // Define each page as a widget
// class LessonsPage extends StatefulWidget {
//   const LessonsPage({Key? key}) : super(key: key);
//   @override
//   State<LessonsPage> createState() => _MyLessonsPageState();
// }

// class _MyLessonsPageState extends State<LessonsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lessons'),
//       ),
//       body: Center(
//         child: Text('Lessons'),
//       ),
//     );
//   }
// }

// class AssignmentsPage extends StatelessWidget {
//   const AssignmentsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Assignments'),
//     );
//   }
// }

// class QuestionsPage extends StatelessWidget {
//   const QuestionsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Questions'),
//     );
//   }
// }

// // Main app widget
// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _selectedIndex = 0; // Track the selected index

//   final List<Widget> _pages = [
//     LessonsPage(),
//     AssignmentsPage(),
//     QuestionsPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Navigation'),
//       ),
//       body: _pages[_selectedIndex], // Display the selected page
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.blue, // Selected item color
//         unselectedItemColor: Colors.grey, // Unselected item color
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Lessons',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assignment),
//             label: 'Assignments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.question_answer),
//             label: 'Questions',
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }
