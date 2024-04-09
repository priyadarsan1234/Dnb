import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<String> upcomingData = [];
  ScrollController _controller = ScrollController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchUpcomingData();
    startAutoScroll();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
 Future<void> fetchUpcomingData() async {
    try {
      var url = Uri.parse("https://newsapi.org/v2/top-headlines?country=in&category=politics&apiKey=3f1b771f4e6540e2bb9674f42c5cded9");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> articles = data['articles'];
        setState(() {
          upcomingData = articles.map((article) => article['title'] as String).toList();
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
  int currentIndex = 0;
  bool scrollForward = true;

  timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    if (currentIndex >= upcomingData.length) {
      currentIndex = 0; // Reset to start scrolling from the beginning
      scrollForward = true;
    }

    if (scrollForward) {
      _controller.animateTo(
        currentIndex * 50.0, // Adjust the value according to your item height
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      currentIndex++;
    } else {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    if (currentIndex == upcomingData.length - 1) {
      scrollForward = false; // Change direction when reaching the end
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Corner",
            style: TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Times New Roman')),
        centerTitle: true, // Center the title
        backgroundColor: Colors.blue, // Change the background color
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: upcomingData.isEmpty
            ? const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            : ListView.builder(
                controller: _controller,
                itemCount: upcomingData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(upcomingData[index],style: const TextStyle( fontFamily: 'Times New Roman',fontSize: 16 ),),
                  );
                },
              ),
      ),
    );
  }
}
