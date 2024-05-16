import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:done/widgets/TextFieldS.dart';

//import shared

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

    saveprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", _usernameController.text.trim());
    prefs.setString("password", _passwordController.text.trim());
    if (_usernameController.text.trim() == "Admin" && _passwordController.text.trim() == "12345"){
      prefs.setBool("R", true );
    }
    else{prefs.setBool("R", false );}
    // print(prefs.getString("username"));
    // print(prefs.getString("password"));

  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Replace URL with your API endpoint for login
    final url = Uri.parse('http://10.0.2.2/finalpro/logina.php');

    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Login successful, navigate to home page
        //Navigator.pushReplacementNamed(context, '/home');
         await saveprefs();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(title: 'Flutter Demo Home Page')));

      } else {
        // Login failed, show error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
         backgroundColor: Colors.blue[900],
          elevation: 2, // No shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login3.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

            TextFields(
              controller: _usernameController,
              hitext: 'Write user name',
              textinput: TextInputType.text,
              obsuc: false,
            ),
            TextFields(
              controller: _passwordController,
              hitext: 'Write user password',
              textinput: TextInputType.text,
              obsuc: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade900), // تغيير لون الخلفية
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
