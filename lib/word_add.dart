import 'package:KelimeWord/ortak.dart';
import 'package:KelimeWord/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

TaskModel gonderilen;
TextEditingController kelime = TextEditingController();
TextEditingController birinciAnlam = TextEditingController();
TextEditingController ikinciAnlam = TextEditingController();

final FocusNode kelimeFocus = FocusNode();
final FocusNode birinciAnlamFocus = FocusNode();
final FocusNode ikinciAnlamFocus = FocusNode();
GlobalKey<ScaffoldState> _snackbarKey = new GlobalKey<ScaffoldState>();

class WordAdd extends StatefulWidget {
  @override
  _WordAddState createState() => _WordAddState();
}

class _WordAddState extends State<WordAdd> {
  @override
  Widget build(BuildContext context) {
    final TodoHelper _todoHelper = TodoHelper();
    return Scaffold(
      key: _snackbarKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          splashRadius: 20,
          highlightColor: Colors.deepOrange,
          icon: Icon(LineAwesomeIcons.chevron_left),
          onPressed: () {
            setState(() {
              kelime.clear();
              birinciAnlam.clear();
              ikinciAnlam.clear();
            });
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepOrange,
        title: Text('Kelime Ekle'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('asset/english.png')),
            Divider(
              height: 20,
              indent: 500.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSpacer(),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 70,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            kelime = kelime;
                          });
                        },
                        focusNode: kelimeFocus,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (a) {
                          _focusGecis(context, kelimeFocus, birinciAnlamFocus);
                        },
                        controller: kelime,
                        decoration: InputDecoration(
                            icon: icon,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  width: 0.5,
                                )),
                            hintText: 'Türkçe Karşılığı',
                            labelText: 'Kelime*'),
                      ),
                    ),
                    Text('  '),
                    buildAnimatedCrossFade(kelime.text),
                    buildSpacer(),
                  ],
                ),
                buildDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSpacer(),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 70,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            birinciAnlam = birinciAnlam;
                          });
                        },
                        focusNode: birinciAnlamFocus,
                        controller: birinciAnlam,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (a) {
                          _focusGecis(
                              context, birinciAnlamFocus, ikinciAnlamFocus);
                        },
                        decoration: InputDecoration(
                            icon: icon,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(width: 0.5)),
                            hintText: 'İngilizce Karşılığı',
                            labelText: 'İngilizcesi*'),
                      ),
                    ),
                    Text('  '),
                    buildAnimatedCrossFade(birinciAnlam.text),
                    buildSpacer(),
                  ],
                ),
                buildDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSpacer(),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 70,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            ikinciAnlam = ikinciAnlam;
                          });
                        },
                        focusNode: ikinciAnlamFocus,
                        controller: ikinciAnlam,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            icon: icon,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(width: 0.5)),
                            hintText: 'Diğer İngilizce Karşılığı',
                            labelText: 'Varsa Diğer Karşılığı'),
                      ),
                    ),
                    Text('  '),
                    buildAnimatedCrossFade(ikinciAnlam.text),
                    buildSpacer(),
                  ],
                ),
                buildDivider(),
                AnimatedCrossFade(
                    firstChild: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          '  Kelime Haznenize Ekleyin  ',
                          style: textStyle,
                        ),
                        onPressed: () async {
                          gonderilen = TaskModel(
                            kelime: kelime.text,
                            karsilik1: birinciAnlam.text,
                            karsilik2: ikinciAnlam.text,
                          );
                          await _todoHelper.insertTask(gonderilen);
                          _snackbarKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Row(
                              children: [
                                Icon(LineAwesomeIcons.check),
                                Text(
                                  ' Kelime Haznenize Eklendi.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            duration: Duration(seconds: 1),
                          ));
                          setState(() {
                            kelime.clear();
                            birinciAnlam.clear();
                            ikinciAnlam.clear();
                          });
                        },
                      ),
                    ),
                    secondChild: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        padding: const EdgeInsets.all(15),
                        child: Text('Gerekli Alanları Doldurunuz',
                            style: textStyle),
                        onPressed: () {
                          _snackbarKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Gerekli Alanları Doldurunuz.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(milliseconds: 200),
                          ));
                        },
                      ),
                    ),
                    duration: const Duration(milliseconds: 500),
                    crossFadeState: kelime.text.length == 0 ||
                            birinciAnlam.text.length == 0 ||
                            kelime.text.length > 15 ||
                            birinciAnlam.text.length > 15 ||
                            ikinciAnlam.text.length > 15
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Spacer buildSpacer() {
    return Spacer(
      flex: 1,
    );
  }

  AnimatedCrossFade buildAnimatedCrossFade(String word) {
    return AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        firstChild: Icon(
          Icons.check,
          color: Colors.green,
        ),
        secondChild: Icon(
          LineAwesomeIcons.exclamation,
          color: Colors.red,
        ),
        crossFadeState: word.length == 0 || word.length > 15
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst);
  }

  Divider buildDivider() {
    return Divider(
      height: 20,
      indent: 500.0,
    );
  }

  _focusGecis(BuildContext context, FocusNode simdiki, FocusNode siradaki) {
    simdiki.unfocus();
    FocusScope.of(context).requestFocus(siradaki);
  }
}
