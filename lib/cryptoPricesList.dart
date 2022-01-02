import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoPricesList extends StatefulWidget {
  const CryptoPricesList({Key? key}) : super(key: key);

  @override
  _CryptoPricesListState createState() => _CryptoPricesListState();
}

class _CryptoPricesListState extends State<CryptoPricesList> {
  List<dynamic> listOfData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final url = Uri.parse('https://usw7n3.deta.dev/');
    http.Response response = await http.get(url);
    Map jsonBody = jsonDecode(response.body);
    List<dynamic> toRtn = jsonBody['items'];
    listOfData=toRtn;
    // setState(() {
    //   listOfData = toRtn;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget CryptoPriceHeading(){
      return Container(margin: EdgeInsets.only(bottom: screenWidth*0.02),width:screenWidth*0.9,decoration: BoxDecoration(color: Color(0xffC4C4C4),borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))),height:screenWidth*0.12,child: Center(child: Text('Current Cryptocurrency Prices',style: TextStyle(fontFamily: 'comfortaa',fontSize: screenWidth*0.055,fontWeight: FontWeight.bold),)),);
    }
    Widget cryptoPriceInfoWidgetMaker(CryptoPriceObject toShow) {
      return Container(
        margin: EdgeInsets.symmetric(
            vertical: screenWidth * 0.008, horizontal: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: screenWidth * 0.03,
                right: screenWidth * 0.01,
                top: screenWidth * 0.01,
                bottom: screenWidth * 0.01,
              ),
              child: Container(
                height: screenWidth * 0.14,
                width: screenWidth * 0.14,
                margin: EdgeInsets.all(screenWidth * 0.01),
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  toShow.imageLink,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: screenWidth * 0.12,
              margin: EdgeInsets.only(
                  top: screenWidth * 0.015, left: screenWidth * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${toShow.cryptoName}',
                      style: TextStyle(
                          fontSize: screenWidth * 0.052,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'mulish')),
                  Text(
                    '(${toShow.shortName})',
                    style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontFamily: 'mulish',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: screenWidth * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: Text(
                        '\u{20B9} ${toShow.cryptoPrice}',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'mulish'),
                      )),
                      Container(
                        width: screenWidth * 0.02,
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.008),
                        decoration: BoxDecoration(
                            color: toShow.dayChangePercent[0] == '+'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                            child: Text(
                          ' ${toShow.dayChangePercent} % ',
                          style: TextStyle(
                              fontFamily: 'mulish',
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.037),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenWidth * 0.013,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '24 hrs: ${toShow.dayChange[0]} \u{20B9} ${toShow.dayChange.substring(1)}',
                        style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontFamily: 'mulish'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              width: screenWidth * 0.05,
            )
          ],
        ),
      );
    }
    Stream streamOfPrices(){
        return Stream.periodic(Duration(seconds: 1),(count){
          loadData();
        });
    }
    return StreamBuilder(
        initialData: null,
        stream: streamOfPrices(),
        builder: (context,snapshot){
          return listOfData.length==0 ? Center(child: CircularProgressIndicator(),) : ListView.builder(
              itemCount: listOfData.length,
              itemBuilder: (context, index) {
                CryptoPriceObject toShow = CryptoPriceObject(
                  cryptoName: listOfData[index]['cryptoName'],
                  cryptoPrice: listOfData[index]['currentPrice'],
                  dayChange: listOfData[index]['DayChange'],
                  imageLink: listOfData[index]['imageLink'],
                  shortName: listOfData[index]['shortName'],
                  dayChangePercent: listOfData[index]['DayChangePercent'],
                );
                return cryptoPriceInfoWidgetMaker(toShow);
              });
        }
    );
  }
}

class CryptoPriceObject {
  final String cryptoName;
  final String cryptoPrice;
  final String imageLink;
  final String dayChange;
  final String dayChangePercent;
  final String shortName;
  CryptoPriceObject({
    required this.cryptoName,
    required this.cryptoPrice,
    required this.dayChange,
    required this.imageLink,
    required this.shortName,
    required this.dayChangePercent,
  });
}
