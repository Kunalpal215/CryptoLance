import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:readmore/readmore.dart';

class CryptoNewsList extends StatefulWidget {
  const CryptoNewsList({Key? key}) : super(key: key);

  @override
  _CryptoNewsListState createState() => _CryptoNewsListState();
}

class _CryptoNewsListState extends State<CryptoNewsList> {
  List<dynamic> newsItems = [];
  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    var response = await http.get(Uri.parse('https://n59der.deta.dev/'));
    String jsonBody = response.body;
    Map<String, dynamic> items = jsonDecode(jsonBody);
    setState(() {
      newsItems = items['newsItems'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget CryptoNewsHeading() {
      return Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.02),
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
            color: Color(0xffC4C4C4),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        height: screenWidth * 0.12,
        child: Center(
            child: Text(
          'Latest Cryptocurrency News',
          style: TextStyle(
              fontFamily: 'comfortaa',
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold),
        )),
      );
    }

    Widget cryptoNewsWidgetMaker(cryptoNewsObject toShow) {
      return Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(toShow.imageUrl), fit: BoxFit.cover),
                  ),
                ),
                Positioned(left : 10,bottom: 7,child: Container(padding: EdgeInsets.symmetric(horizontal: 5),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),child: Text(toShow.source.substring(toShow.source.indexOf('|')+2),style: TextStyle(fontSize: screenWidth*0.035),),)),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.015, horizontal: screenWidth * 0.02),
              child: Text(
                toShow.heading,
                style: TextStyle(
                    fontFamily: 'mulish',
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    bottom: screenWidth * 0.02),
                child: ReadMoreText(
                  toShow.description,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'mulish',
                      fontWeight: FontWeight.w500),
                )),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: getNews,
      child: newsItems.length == 0
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CryptoNewsHeading(),
                Expanded(
                  child: ListView.builder(
                    itemCount: newsItems.length,
                    itemBuilder: (context, index) {
                      cryptoNewsObject toShow = cryptoNewsObject(
                          heading: newsItems[index]["heading"],
                          imageUrl: newsItems[index]["imageURL"],
                          source: newsItems[index]["source"],
                          description: newsItems[index]["description"]);
                      // print(toShow.heading);
                      // print(toShow.imageUrl);
                      // print(toShow.source);
                      // print(toShow.description);
                      return cryptoNewsWidgetMaker(toShow);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class cryptoNewsObject {
  final String heading;
  final String imageUrl;
  final String source;
  final String description;
  cryptoNewsObject(
      {required this.heading,
      required this.imageUrl,
      required this.source,
      required this.description});
}
