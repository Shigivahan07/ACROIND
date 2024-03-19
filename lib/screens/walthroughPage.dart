import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'income_calculator_screen.dart';

class WalkthroughPage extends StatefulWidget {
  @override
  _WalkthroughPageState createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  final List<Map<String, dynamic>> walkthroughs = [
    {
      'text': "The App for an Individual tax Payer",
      'image': "",
    },
    {
      'text': "Tax Issues No worries we got you covered!",
      'image': "https://www.instagram.com/p/C4ntO1DgsiJ/?igsh=MXNkNjJmdHh0bDY4cg==",
    },
    {
      'text': "Deductions by the way!",
      'image': "https://pin.it/c1ETOMNw8",
    },
    {
      'text': "Get the tax on the go",
      'image': "https://ibb.co/s2yRcd9",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x7D7D8A8A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            items: walkthroughs.map((item) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(item['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      item['text'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    if (item['additionalText'] != null)
                      Text(
                        item['additionalText'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.6,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: walkthroughs.map((item) {
              int index = walkthroughs.indexOf(item);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Colors.blueAccent
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_currentIndex < walkthroughs.length - 1) {
                _carouselController.nextPage();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomeCalculatorScreen(),
                  ),
                );
              }
            },
            child: Text(
              _currentIndex == walkthroughs.length - 1 ? 'Finish' : 'Next',
            ),
          ),
        ],
      ),
    );
  }
}
