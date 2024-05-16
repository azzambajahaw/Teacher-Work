import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Card Example'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: MyCustomCard(),
        ),
      ),
    );
  }
}

class MyCustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('العنوان', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Image.network(
            'https://via.placeholder.com/150', // URL للصورة
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // إضافة التعليمات عند الضغط على الزر الأول
                },
                child: Text('زر أول'),
              ),
              ElevatedButton(
                onPressed: () {
                  // إضافة التعليمات عند الضغط على الزر الثاني
                },
                child: Text('زر ثاني'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  // إضافة التعليمات عند الضغط على زر الحذف
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
