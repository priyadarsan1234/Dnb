import 'package:dnb/Screen1.dart';
import 'package:dnb/Screen2.dart';
import 'package:dnb/Screen3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:marquee/marquee.dart';

void main() {
  runApp(TVApp());
}

class TVApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.purple, // You can use accentColor if needed
        fontFamily: 'Roboto', // Example font family
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black),
          bodyText2: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      home: TVScreen(),
    );
  }
}

class TVScreen extends StatefulWidget {
  @override
  _TVScreenState createState() => _TVScreenState();
}

class _TVScreenState extends State<TVScreen> {
  List<String> upcomingData = [];

  Future<void> fetchUpcomingData() async {
    try {
      var url =
          Uri.parse("https://creativecollege.in/DNB/upcoming_retrive.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          upcomingData = List<String>.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchUpcomingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20, // Adjust the size of the logo
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Make it rounded
              child: Image.asset(
                'assets/ctc.jpg',
                fit: BoxFit.cover, // Ensure the image covers the entire area
              ),
            ),
          ),
        ),
        title: const Center(
          child: Text(
            'CREATIVE TECHNO COLLEGE',
            style: TextStyle( fontFamily: 'Times New Roman',fontWeight: FontWeight.bold,fontSize: 30)
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20, // Adjust the size of the logo
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24), // Make it rounded
                child: Image.asset(
                  'assets/technocrat.jpg',
                  fit: BoxFit.cover, // Ensure the image covers the entire area
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor, // Use primaryColor instead of accentColor
              border: Border.all(width: 1),
            ),
            child: const Center(
              child: Text(
                'DIGITAL NOTICE BOARD',
                style: TextStyle( fontFamily: 'Times New Roman'),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Screen1(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Screen2(),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Screen3(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor, // Use primaryColor instead of accentColor
              border: Border.all(width: 3),
            ),
            alignment: Alignment.center,
            child: upcomingData.isEmpty
                ? const Text(
                    'Creative Techno College First Professional Degree College In Angul',
                    style: TextStyle( fontFamily: 'Times New Roman'),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Marquee(
                        text: upcomingData.join(", "),
                        style: Theme.of(context).textTheme.bodyText2,
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 50.0,
                        pauseAfterRound: const Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: const Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}