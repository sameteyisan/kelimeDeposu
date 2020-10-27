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
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    nonPersonalizedAds: true,
  );
  InterstitialAd myInterstitial;
  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-4589290119610129/7791901552',
      targetingInfo: targetingInfo,
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

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4589290119610129~6255620307');
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
        targetingInfo: targetingInfo,
        adUnitId: 'ca-app-pub-4589290119610129/8889183198',
        size: AdSize.fullBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic abs = buildInterstitialAd()..load();
    final TodoHelper th = TodoHelper();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0,
          centerTitle: true,
          title: Text('Kelime Deposu'),
        ),
        body: Padding(
          padding: paddingAll,
          child: Center(
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
                          abs..show();
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
                          abs..show();
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
          ),
        ));
  }
}
/*buildInterstitialAd()
                          ..load()
                          ..show() */
