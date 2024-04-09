import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Screen3 extends StatefulWidget {
  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  List<String> upcomingThought = [];
  List<String> upcomingfwork= [];
  ScrollController _controller = ScrollController();
  Timer? timer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchThought();
    fetchFacultywork();
    startAutoScroll();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchThought() async {
    try {
      var url = Uri.parse("https://creativecollege.in/DNB/Thought.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          upcomingThought = List<String>.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> fetchFacultywork() async {
    try {
      var url = Uri.parse("https://creativecollege.in/DNB/Faculy_Work.php");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          upcomingfwork = List<String>.from(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  void startAutoScroll() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        if (currentIndex < upcomingThought.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }
        _controller.animateTo(
          currentIndex * 100.0, // Assuming each item has a height of 100.0
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue, // Set heading background color to blue
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                 child: Text(
                  "Thought Of The Day",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Times New Roman'), // Set heading text color to white
                ),
                ),
                const SizedBox(height: 8), // Add spacing between heading and data
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 7.0),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.blue)), // Add left border to separate heading and data
                    ),
                    child: upcomingThought.isEmpty
                        ? const Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(fontSize: 12.0, fontFamily: 'Times New Roman'),
                        ),
                    )
                        : ListView.builder(
                      controller: _controller,
                      itemCount: upcomingThought.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(upcomingThought[index],style: const TextStyle(color: Colors.white,fontSize: 12, fontFamily: 'Times New Roman'),),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(7.0),
            color: Colors.blue, // Set heading background color to blue
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Faculty's Work",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Times New Roman'), // Set heading text color to white
                  ),
                ),
                const SizedBox(height: 8), // Add spacing between heading and data
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 7.0),
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.blue)), // Add left border to separate heading and data
                    ),
                    child: upcomingfwork.isEmpty
                        ? const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 12.0, fontFamily: 'Times New Roman'),
                      ),
                    )
                        : ListView.builder(
                      controller: _controller,
                      itemCount: upcomingfwork.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(upcomingfwork[index],style: const TextStyle(color: Colors.white, fontFamily: 'Times New Roman'),),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
