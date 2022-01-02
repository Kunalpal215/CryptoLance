import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_lance/cryptoNewsList.dart';
import 'cryptoPricesList.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget cryptoNews() {
    return Center(
      child: Text('News'),
    );
  }

  var selectedIndex = 0;
  List<Widget> screens = [
    CryptoPricesList(),
    CryptoNewsList(),
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffE9FCE9),
      appBar: AppBar(
        toolbarHeight: screenWidth * 0.20,
        leadingWidth: screenWidth * 0.17,
        backgroundColor: Color(0xffE9FCE9),
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenWidth * 0.015),
          child: CircleAvatar(
            backgroundColor: Colors.blue,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(color: Colors.black, fontFamily: 'mulish'),
                ),
                Text(
                  'Username',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'mulish',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Image.asset(
              'assets/images/app-icon.png',
              height: screenWidth * 0.13,
            )
          ],
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedIconTheme: IconThemeData(color: Colors.grey),
        selectedLabelStyle: TextStyle(fontFamily: 'mulish',color: Colors.grey),
        unselectedLabelStyle: TextStyle(fontFamily: 'mulish',color: Colors.grey),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined), label: 'Prices'),
          BottomNavigationBarItem(
              icon: Icon(Icons.anchor_outlined), label: 'News'),
        ],
      ),
    );
  }
}
