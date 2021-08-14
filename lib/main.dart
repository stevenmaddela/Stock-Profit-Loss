import 'dart:convert';
import 'package:finance_quote/finance_quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tickerc = new TextEditingController();
  TextEditingController pricec = new TextEditingController();
  TextEditingController sharesc = new TextEditingController();
  TextEditingController amtc = new TextEditingController();
  TextEditingController valuec = new TextEditingController();
  TextEditingController percentc = new TextEditingController();
  String ticker = "";
  String? price = "";
  double shares = 0;
  double amt = 0;
  double value = 0;
  double percent = 0;
  String finalOutput = "";
  Color finalOutputColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFb0bdf7),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ticker != "" ? ticker : "",
                    style: GoogleFonts.spartan(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5,),
                  Text(
                    price != "" ? "\$" + price! : "",
                    style: GoogleFonts.spartan(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                height: 40,
                                width: 120,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    depth: NeumorphicTheme.embossDepth(context),
                                    color: Colors.white70,
                                    shadowDarkColor: Color(0xFFb0bdf7),
                                    shadowLightColor: Colors.white,
                                  ),
                                  child: TextField(
                                    controller: tickerc,
                                    decoration: InputDecoration(
                                      hintText: "Stock Ticker",
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 5, 5, 10),
                                    ),
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width / 9,
                              width: MediaQuery.of(context).size.width / 3,
                              child: NeumorphicButton(
                                onPressed: () async {
                                  NeumorphicTheme.isUsingDark(context)
                                      ? ThemeMode.light
                                      : ThemeMode.dark;
                                  tickerc.value.text == ""
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                                title: new Text(
                                                    "Stock Ticker is Empty"),
                                                content: new Text(
                                                    "Please Enter Valid Ticker"),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    child: Text("Ok"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ))
                                      : setState(() {
                                          ticker =
                                              tickerc.value.text.toUpperCase();
                                          pricec.clear();
                                          price = "";
                                        });
                                  final Map<String, Map<String, String>>
                                      quotePrice = await FinanceQuote.getPrice(
                                          quoteProvider: QuoteProvider.yahoo,
                                          symbols: <String>[ticker]);
                                  setState(() {
                                    try {
                                      price = quotePrice[ticker]!['price'];
                                    } catch (e) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                                title: new Text(
                                                    "Unable to Find Stock Value"),
                                                content: new Text(
                                                    "Please Enter Value Manually or Try Another Ticker"),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    child: Text("Ok"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ));
                                    }
                                  });

                                  setState(() {});
                                },
                                style: NeumorphicStyle(
                                  color: Colors.white70,
                                  surfaceIntensity: 1,
                                  shadowLightColor: Colors.white,
                                  shadowDarkColor: Color(0xFFb0bdf7),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(40)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'RETRIEVE',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black54),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.arrow_circle_down_sharp),
                                      color: Color(0xFF8298fa),
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      constraints: BoxConstraints(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'OR',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                height: 40,
                                width: 120,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    depth: NeumorphicTheme.embossDepth(context),
                                    color: Colors.white70,
                                    shadowDarkColor: Color(0xFFb0bdf7),
                                    shadowLightColor: Colors.white,
                                  ),
                                  child: TextField(
                                    controller: pricec,
                                    decoration: InputDecoration(
                                      hintText: "Stock Price",
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(5, 5, 5, 10),
                                    ),
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r'[,]'))
                                    ],
                                    keyboardType: TextInputType.number,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width / 9,
                              width: MediaQuery.of(context).size.width / 3,
                              child: NeumorphicButton(
                                onPressed: () {
                                  setState(() {
                                    NeumorphicTheme.isUsingDark(context)
                                        ? ThemeMode.light
                                        : ThemeMode.dark;
                                  });
                                  pricec.value.text == ""
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                                title: new Text(
                                                    "Stock Price is Empty"),
                                                content: new Text(
                                                    "Please Enter a Value"),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ))
                                      : setState(() {
                                          tickerc.clear();
                                          ticker = "";
                                          price = pricec.value.text;
                                        });
                                },
                                style: NeumorphicStyle(
                                  color: Colors.white70,
                                  surfaceIntensity: 1,
                                  shadowLightColor: Colors.white,
                                  shadowDarkColor: Color(0xFFb0bdf7),
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(40)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ENTER',
                                      style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black54),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.check_circle_outline),
                                      color: Color(0xFF8298fa),
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      constraints: BoxConstraints(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.black38,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'BUY # OF SHARES',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              height: 40,
                              width: 60,
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: NeumorphicTheme.embossDepth(context),
                                  color: Colors.white24,
                                  shadowDarkColor: Color(0xFFb0bdf7),
                                  shadowLightColor: Colors.white,
                                ),
                                child: TextField(
                                  controller: sharesc,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 5, 10),
                                  ),
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[,]'))
                                  ],
                                  keyboardType: TextInputType.number,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'OR',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'BUY WITH \$ AMOUNT',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              height: 40,
                              width: 60,
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: NeumorphicTheme.embossDepth(context),
                                  color: Colors.white24,
                                  shadowDarkColor: Color(0xFFb0bdf7),
                                  shadowLightColor: Colors.white,
                                ),
                                child: TextField(
                                  controller: amtc,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 5, 10),
                                  ),
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[,]'))
                                  ],
                                  keyboardType: TextInputType.number,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.black38,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SELL AT \$ VALUE',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              height: 40,
                              width: 60,
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: NeumorphicTheme.embossDepth(context),
                                  color: Colors.white24,
                                  shadowDarkColor: Color(0xFFb0bdf7),
                                  shadowLightColor: Colors.white,
                                ),
                                child: TextField(
                                  controller: valuec,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 5, 10),
                                  ),
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[,]'))
                                  ],
                                  keyboardType: TextInputType.number,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'OR',
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SELL AT % GREATER',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              height: 40,
                              width: 60,
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: NeumorphicTheme.embossDepth(context),
                                  color: Colors.white24,
                                  shadowDarkColor: Color(0xFFb0bdf7),
                                  shadowLightColor: Colors.white,
                                ),
                                child: TextField(
                                  controller: percentc,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 5, 5, 10),
                                  ),
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'[,]'))
                                  ],
                                  keyboardType: TextInputType.number,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: NeumorphicButton(
                      onPressed: () {
                        setState(() {
                          NeumorphicTheme.isUsingDark(context)
                              ? ThemeMode.light
                              : ThemeMode.dark;
                          if(checkForDialogs().title.toString()!="Text(\"Success\")") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    checkForDialogs());
                          }
                        });
                      },
                      style: NeumorphicStyle(
                        color: Colors.white70,
                        surfaceIntensity: 1,
                        shadowLightColor: Colors.white,
                        shadowDarkColor: Color(0xFF7f96fa),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(40)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CALCULATE',
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black54),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.monetization_on_outlined),
                            color: Colors.green,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            constraints: BoxConstraints(),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    finalOutput,
                    style: GoogleFonts.montserrat(
                        fontSize: 25, color: finalOutputColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CupertinoAlertDialog checkForDialogs() {
    if(price==""){
      return CupertinoAlertDialog(
        title: new Text(
            "Stock Value Not Inputted"),
        content: new Text(
            "Either Retrieve Stock Value or Manually Enter One"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }
    else if(sharesc.value.text!="" && amtc.value.text!=""){
              return CupertinoAlertDialog(
                title: new Text(
                    "Too Many Inputs"),
                content: new Text(
                    "Only Buy # of Shares or Buy With \$ Amount Should Be Filled"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
    }
    else if(valuec.value.text!="" && percentc.value.text!=""){
              return CupertinoAlertDialog(
                title: new Text(
                    "Too Many Inputs"),
                content: new Text(
                    "Only Sell at \$ Value or Sell at \% Greater Should Be Filled"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
    }
    else if(sharesc.value.text=="" && amtc.value.text==""){
      return CupertinoAlertDialog(
        title: new Text(
            "Not Enough Inputs"),
        content: new Text(
            "Please Fill Buy # of Shares or Buy With \$ Amount Should"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }
    else if(valuec.value.text=="" && percentc.value.text==""){
      return CupertinoAlertDialog(
        title: new Text(
            "Not Enough Inputs"),
        content: new Text(
            "Sell at \$ Value or Sell at \% Greater Should Be Filled"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }
    else{
      calculate();
    }
    return CupertinoAlertDialog(
      title: new Text(
          "Success"),
      content: new Text(
          "No Errors"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void calculate() {
    if(sharesc.value.text!="" && valuec.value.text!=""){
      shares = double.parse(sharesc.value.text);
      value = double.parse(valuec.value.text);
      double outcome = (shares*value) - (shares*(double.parse(price!)));
      double percentage = (outcome / (shares*(double.parse(price!))))*100;
      if(outcome > 0){
        setState(() {
          finalOutput = "Profit: \$" + outcome.toStringAsFixed(2) + " (△" + percentage.toStringAsFixed(2) + "%)";
          finalOutputColor = Color(0xFF2d6a4f);
        });
      }
      else{
        finalOutput = "Loss: -\$" + outcome.abs().toStringAsFixed(2) + " (▽" + percentage.toStringAsFixed(2) + "%)";
        finalOutputColor = Color(0xFFE63B2E);
      }
    }
    if(sharesc.value.text!="" && percentc.value.text!=""){
      double mPrice = double.parse(price!);
      shares = double.parse(sharesc.value.text);
      percent = double.parse(percentc.value.text);
      double val = percent/100.0;
      double outcome = (shares*(mPrice+(mPrice*val))) - (shares*mPrice);
      double percentage = (outcome / (shares*mPrice))*100;
      if(outcome > 0){
        setState(() {
          finalOutput = "Profit: \$" + outcome.toStringAsFixed(2) + " (△" + percentage.toStringAsFixed(2) + "%)";
          finalOutputColor = Color(0xFF2d6a4f);
        });
      }
      else{
        finalOutput = "Loss: -\$" + outcome.abs().toStringAsFixed(2) + " (▽" + percentage.toStringAsFixed(2) + "%)";
        finalOutputColor = Color(0xFFE63B2E);
      }
    }
    if(amtc.value.text!="" && valuec.value.text!=""){
      double mPrice = double.parse(price!);
      amt = double.parse(amtc.value.text);
      value = double.parse(valuec.value.text);
      double shares1 = amt/mPrice;
      double outcome = (shares1*value) - (shares1*mPrice);
      double percentage = (outcome / (shares1*mPrice))*100;
      if(outcome > 0){
        setState(() {
          finalOutput = "Profit: \$" + outcome.toStringAsFixed(2) + " (△" + percentage.toStringAsFixed(2) + "%)";
          finalOutputColor = Color(0xFF2d6a4f);
        });
      }
      else{
        finalOutput = "Loss: -\$" + outcome.abs().toStringAsFixed(2) + " (▽" + percentage.toStringAsFixed(2) + "%)";
        finalOutputColor = Color(0xFFE63B2E);
      }
    }
    if(amtc.value.text!="" && percentc.value.text!=""){
      amt = double.parse(amtc.value.text);
      percent = double.parse(percentc.value.text);
      double outcome = amt*((percent/100.0)+1);
      double percentage = percent;
      if(outcome > 0){
        setState(() {
          finalOutput = "Profit: \$" + outcome.toStringAsFixed(2) + " (△" + percentage.toStringAsFixed(2) + "%)";
          finalOutputColor = Color(0xFF2d6a4f);
        });
      }
      else{
        finalOutput = "Loss: -\$" + outcome.abs().toStringAsFixed(2) + " (▽" + percentage.toStringAsFixed(2) + "%)";
        finalOutputColor = Color(0xFFE63B2E);
      }
    }
  }
}
