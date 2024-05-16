

// Define a model class for the lesson data
class Lesson {
  final String title;
  final String date;
  final String pdfUrl;
  final String youtubeUrl;

  Lesson({
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

// Function to fetch lessons data from an API
Future<List<Lesson>> fetchLessons() async {
  final response = await http.get(Uri.parse('http://10.0.2.2/finalpro/get_lessons.php')); // Replace with your actual API URL
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((item) => Lesson.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load lessons');
  }
}

// Function to post a new lesson to the API
Future<void> postNewLesson(Lesson newLesson) async {
  final url = Uri.parse('http://10.0.2.2/finalpro/add_lessons.php'); // Replace with your API endpoint
  final response = await http.post(
    url,
    body: {
      'LessonTitle': newLesson.title,
      'LessonDate': newLesson.date,
      'LessonFile': newLesson.pdfUrl,
      'Lessonlink': newLesson.youtubeUrl,
    },
  );

  if (response.statusCode == 200) {
    // Successfully posted
    print('Lesson posted successfully!');
  } else {
    // Error posting lesson
    throw Exception('Failed to post lesson');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson App',
      home: const LessonsPage(),
    );
  }
}

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key? key}) : super(key: key);

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  late Future<List<Lesson>> _lessons;

  @override
  void initState() {
    super.initState();
    _lessons = fetchLessons(); // Fetch lessons on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
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
                return LessonCard(lesson: lesson); // Display each lesson in a card
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}')); // Handle errors
          }
          // Display a loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Post a new lesson when FAB is pressed
          final newLesson = Lesson(
            title: 'New Lesson Title',
            date: '2024-05-14',
            pdfUrl: 'https://example.com/new_lesson.pdf',
            youtubeUrl: 'https://youtube.com/new_lesson',
          );
          postNewLesson(newLesson).then((_) {
            // Refresh lessons after posting a new one
            setState(() {
              _lessons = fetchLessons();
            });
          }).catchError((error) {
            print('Error posting lesson: $error');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Widget to display a single lesson card
class LessonCard extends StatelessWidget {
  final Lesson lesson;

  const LessonCard({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(lesson.title, style: const TextStyle(fontSize: 18)),
            Text(lesson.date, style: const TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => launchUrl(lesson.pdfUrl), // Open PDF in a web view
                  child: const Text('Open PDF'),
                ),
                ElevatedButton(
                  onPressed: () => launchUrl(lesson.youtubeUrl), // Open YouTube link
                  child: const Text('YouTube'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Function to launch a URL in a web view (replace with your preferred method)
void launchUrl(String url) async {
  // ignore: deprecated_member_use
  if (!await canLaunch(url)) {
    throw 'Could not launch $url';
  }
  // ignore: deprecated_member_use
  await launch(url);
}
