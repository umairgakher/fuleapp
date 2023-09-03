// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_function_literals_in_foreach_calls, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';

class TrendingPetrolPump {
  final String imageUrl;
  final String name;
  final int rating;
  int totalSales;
  int salesToday;

  TrendingPetrolPump({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.totalSales,
    required this.salesToday,
  });
}

class TrendingPumpsScreen extends StatefulWidget {
  @override
  _TrendingPumpsScreenState createState() => _TrendingPumpsScreenState();
}

class _TrendingPumpsScreenState extends State<TrendingPumpsScreen> {
  final List<TrendingPetrolPump> trendingPumps = [
    TrendingPetrolPump(
      imageUrl:
          'https://i5.walmartimages.com/asr/d3796860-f948-4ea7-b7f4-21278fca7707_1.4408abdaf1d43a866308fcc1d24503f8.jpeg',
      name: 'SHELL THE LEADER',
      rating: 5,
      totalSales: 1000,
      salesToday: 150,
    ),
    TrendingPetrolPump(
      imageUrl:
          'https://ilcdnstatic.investorslounge.com//ResearchImages/FullImage//74915755-c111-49ae-ae22-8e30ba4a2abb.png',
      name: 'ATTOCK PETROLE PUMP',
      rating: 4,
      totalSales: 800,
      salesToday: 120,
    ),
    TrendingPetrolPump(
      imageUrl:
          'https://live.staticflickr.com/4018/5159201474_91cf44024e_c.jpg',
      name: 'PSO(Pakistan state oil)',
      rating: 3,
      totalSales: 600,
      salesToday: 80,
    ),
    TrendingPetrolPump(
      imageUrl:
          'https://play-lh.googleusercontent.com/Sygg9ymbRG5B3ZMCjYUwI_xHtd1XM6wkFEJ-VSyBSLhb39PovvKYToJ9dYuSifWkJj8',
      name: 'TOTAL PARCO',
      rating: 4,
      totalSales: 900,
      salesToday: 200,
    ),
    TrendingPetrolPump(
      imageUrl:
          'https://i5.walmartimages.com/asr/d3796860-f948-4ea7-b7f4-21278fca7707_1.4408abdaf1d43a866308fcc1d24503f8.jpeg',
      name: 'SHELL THE LEADER',
      rating: 5,
      totalSales: 1200,
      salesToday: 180,
    ),
    TrendingPetrolPump(
      imageUrl:
          'https://ilcdnstatic.investorslounge.com//ResearchImages/FullImage//74915755-c111-49ae-ae22-8e30ba4a2abb.png',
      name: 'ATTOCK PETROLE PUMP',
      rating: 4,
      totalSales: 1000,
      salesToday: 150,
    ),

    // ... rest of the pumps
  ];

  void _refreshSales() {
    setState(() {
      // Increase the sales of each pump by a random number between 100 and 500
      trendingPumps.forEach((pump) {
        final randomSales = Random().nextInt(401) + 100;
        pump.totalSales += randomSales;
        pump.salesToday = randomSales;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trending Petrol Pumps',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Trending Petrol Pumps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.white,
              onPressed: _refreshSales,
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: trendingPumps.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 130,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Image.network(
                        trendingPumps[index].imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trendingPumps[index].name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Text(
                              'Total Sales: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            Text(
                              '${trendingPumps[index].totalSales}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Text(
                              'Sales Today: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            Text(
                              '${trendingPumps[index].salesToday}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: List.generate(
                            trendingPumps[index].rating,
                            (index) => Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
