import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<String> imageStrings = [];
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchImages();
    startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchImages() async {
    var url = Uri.parse("https://creativecollege.in/img_retrive.php");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        try {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            imageStrings = List<String>.from(data.reversed);
            _totalPages = imageStrings.length;
          });
        } catch (e) {
          print('Error decoding JSON: $e');
          throw Exception('Failed to load images');
        }
      } else {
        print('HTTP ${response.statusCode} ${response.body}');
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error fetching images: $e');
      throw Exception('Failed to fetch images');
    }
  }

  void startAutoScroll() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageStrings.length,
            itemBuilder: (context, index) {
              return Center(
                child: Image.memory(
                  base64Decode(imageStrings[index]),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}