import 'dart:math';

import 'package:KelimeWord/myWords.dart';
import 'package:KelimeWord/ortak.dart';
import 'package:KelimeWord/sqflite.dart';
import 'package:KelimeWord/word_add.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

var kelimeHaznem = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelime Deposu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InterstitialAd myInterstitial;
  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()..load();
    myInterstitial = buildInterstitialAd()..load();
  }

  @override
  void dispose() {
    myInterstitial.dispose();
    myBanner.dispose();
    super.dispose();
  }

  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final TodoHelper th = TodoHelper();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0,
          centerTitle: true,
          title: Text('Kelime Deposu'),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Image.asset('asset/english.png'),
                  ),
                  Divider(
                    height: 20,
                    indent: 500.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green),
                    child: FlatButton(
                      child: Text(
                        '  Yeni Kelime Ekle  ',
                        style: textStyle,
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WordAdd()),
                        );
                      },
                    ),
                  ),
                  Divider(
                    height: 30,
                    indent: 500.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange),
                    child: FlatButton(
                      child: Text(
                        'Kelimelerim',
                        style: textStyle,
                      ),
                      onPressed: () async {
                        List<TaskModel> listx = await th.getAllTask();
                        setState(() {
                          kelimeHaznem = listx;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyWords()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
