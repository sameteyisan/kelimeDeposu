import 'package:KelimeWord/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'main.dart';
import 'ortak.dart';

double rate = 1;
enum TtsState { playing, stopped, paused, continued }

FlutterTts flutterTts;
dynamic languages;
TtsState ttsState = TtsState.stopped;

initTts() {
  flutterTts = FlutterTts();

  _getLanguages();

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      _getEngines();
    }
  }
}

Future _getLanguages() async {
  languages = await flutterTts.getLanguages;
  await flutterTts.setLanguage('en-US');
}

Future _getEngines() async {
  var engines = await flutterTts.getEngines;
  if (engines != null) {
    for (dynamic engine in engines) {
      print(engine);
    }
  }
}

Future _speakSlowly(String deneme) async {
  _speak(deneme, 0.1);
}

Future _speakNormal(String speakText) async {
  _speak(speakText, 0.7);
}

Future _speak(String deneme, double rate) async {
  await flutterTts.setSpeechRate(rate);
  var result = await flutterTts.speak(deneme);
  if (result == 1) {
    ttsState = TtsState.playing;
  }
}

class MyWords extends StatefulWidget {
  @override
  _MyWordsState createState() => _MyWordsState();
}

class _MyWordsState extends State<MyWords> {
  @override
  initState() {
    super.initState();
    initTts();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _snackbarKey = new GlobalKey<ScaffoldState>();
    final TodoHelper th = TodoHelper();
    return Scaffold(
      key: _snackbarKey,
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          highlightColor: Colors.deepOrange,
          icon: Icon(LineAwesomeIcons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        title: Text('Kelimelerim'),
      ),
      body: kelimeHaznem.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Kayıtlı Kelime Bulunamadı.',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          : Padding(
              padding: paddingAll,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(
                                alignment: Alignment.center,
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              onDismissed: (direction) async {
                                th.deleteTask(kelimeHaznem[index].id);
                                List<TaskModel> list = await th.getAllTask();
                                setState(() {
                                  kelimeHaznem = list;
                                  flutterTts.stop();
                                });
                              },
                              key: ObjectKey(kelimeHaznem[index]),
                              child: Container(
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.grey[200],
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        // ignore: missing_required_param
                                        FloatingActionButton(
                                            heroTag: 'hero1$index',
                                            backgroundColor: Colors.deepOrange,
                                            mini: true,
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Kelime',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                            Divider(
                                              height: 5,
                                            ),
                                            Text(
                                              kelimeHaznem[index].kelime,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[700],
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        // ignore: missing_required_param
                                        FloatingActionButton(
                                          elevation: 0,
                                          heroTag: 'hero2$index',
                                          backgroundColor: index % 2 == 0
                                              ? Colors.white
                                              : Colors.grey[200],
                                          mini: true,
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 10,
                                      indent: 500.0,
                                    ),
                                    Text(
                                      '1. Anlam',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          decoration: TextDecoration.underline),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          highlightColor: Colors.red,
                                          splashRadius: 20,
                                          icon: SizedBox(
                                              width: 20,
                                              child: Image.asset(
                                                  'asset/audio.png')),
                                          onPressed: () {
                                            _speakNormal((kelimeHaznem[index]
                                                .karsilik1));
                                          },
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                          kelimeHaznem[index].karsilik1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[700],
                                              fontSize: 16),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        IconButton(
                                          highlightColor: Colors.red,
                                          splashRadius: 20,
                                          icon: SizedBox(
                                              width: 20,
                                              child: Image.asset(
                                                  'asset/volume.png')),
                                          onPressed: () {
                                            _speakSlowly((kelimeHaznem[index]
                                                .karsilik1));
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 10,
                                      indent: 500.0,
                                    ),
                                    kelimeHaznem[index].karsilik2 != ''
                                        ? Column(
                                            children: [
                                              Text(
                                                '2. Anlamı',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    highlightColor: Colors.red,
                                                    splashRadius: 20,
                                                    icon: SizedBox(
                                                        width: 20,
                                                        child: Image.asset(
                                                            'asset/audio.png')),
                                                    onPressed: () {
                                                      _speakNormal(
                                                          (kelimeHaznem[index]
                                                              .karsilik2));
                                                    },
                                                  ),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                  Text(
                                                    kelimeHaznem[index]
                                                        .karsilik2,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.green[700],
                                                        fontSize: 16),
                                                  ),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                  IconButton(
                                                    highlightColor: Colors.red,
                                                    splashRadius: 20,
                                                    icon: SizedBox(
                                                        width: 20,
                                                        child: Image.asset(
                                                            'asset/volume.png')),
                                                    onPressed: () {
                                                      _speakSlowly(
                                                          (kelimeHaznem[index]
                                                              .karsilik2));
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        : Container(
                                            color: Colors.white,
                                          )
                                  ])),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                height: 0,
                                indent: 500,
                              ),
                          itemCount: kelimeHaznem.length),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Divider buildDivider() => Divider(
        height: 10,
        indent: 500.0,
      );
}
