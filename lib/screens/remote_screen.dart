import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon.dart' as MyIcon;
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
//import 'package:upnp/upnp.dart';


class TVRemoteDemo extends StatefulWidget {
  const TVRemoteDemo ({Key? key, required this.hostIP }) : super(key: key);
  final String hostIP;
  
  @override
  State<TVRemoteDemo> createState() => _TVRemoteDemoState();
}

class _TVRemoteDemoState extends State<TVRemoteDemo> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      setState(() {
        _lastWords = result.recognizedWords;
        print('** Final Result **' + _lastWords);
      });
    var words = _lastWords.toLowerCase().split(" ");
    if (words.contains("launch")) {
      if (words.contains("youtube")) {
        var client = HttpClient();
        http.post(
            Uri.parse('http://' + widget.hostIP + ':56889/apps/YouTube/'),
            headers: {"Origin": "https://www.youtube.com"}
        );
      }
      else if (words.contains("netflix")) {
        var client = HttpClient();
        http.post(
            Uri.parse('http://' + widget.hostIP + ':56889/apps/Netflix/')
        );
      }
      else {
        print("nothing detected");
      }
    }
    if (words.contains("mute")) {
      Socket.connect(widget.hostIP, 5650).then((socket) {
        socket.write('113');
      });
    }
    if (words.contains("unmute")) {
      Socket.connect(widget.hostIP, 5650).then((socket) {
        socket.write('113');
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF153451),
      //backgroundColor:Color(0xFF373737),
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: MyIcon.Icon(Icons.tv,
          color: Colors.black45,
        ),
        title: Text('RDK REMOTE',
          style: TextStyle(fontSize: 20,
            color: Colors.black87,
          ),),
        titleSpacing: 2.0,
        //backgroundColor: Color(0xFF54A0B0),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ClipOval(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.white24,
                        child: SizedBox(
                          height: 56,
                          width: 56,
                          child: MyIcon.Icon(Icons.home),
                        ),
                        onTap: () {
                          Socket.connect(widget.hostIP, 5650).then((socket) {
                            socket.write('102');
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.white24,
                        child: SizedBox(
                          height: 56,
                          width: 56,
                          child: MyIcon.Icon(Icons.volume_off),
                        ),
                        onTap: () {
                          Socket.connect(widget.hostIP, 5650).then((socket) {
                            socket.write('113');
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Material(
                      //color: Colors.red,
                      child: InkWell(
                        splashColor: Colors.white24,
                        child: SizedBox(
                          height: 56,
                          width: 56,
                          child: Center(
                              child: Text('OK',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)),
                        ),
                        onTap: () {
                          Socket.connect(widget.hostIP, 5650).then((socket) {
                            socket.write('353');
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  child: ClipOval(
                    child: Material(
                      color: Colors.red,
                      child: InkWell(
                        splashColor: Colors.white24,
                        child: SizedBox(
                          height: 56,
                          width: 56,
                          child: MyIcon.Icon(Icons.power_settings_new),
                        ),
                        onTap: () {
                          Socket.connect(widget.hostIP, 5650).then((socket) {
                            socket.write('527');
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 156,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: ClipOval(
                          child: Material(
                            child: InkWell(
                              splashColor: Colors.white24,
                              child: SizedBox(
                                height: 56,
                                width: 56,
                                child: MyIcon.Icon(Icons.arrow_drop_up),
                              ),
                              onTap: () {
                                Socket.connect(widget.hostIP, 5650)
                                    .then((socket) {
                                  socket.write('115');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'VOL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: ClipOval(
                            child: Material(
                          child: InkWell(
                            splashColor: Colors.white24,
                            child: SizedBox(
                              height: 56,
                              width: 56,
                              child: MyIcon.Icon(Icons.arrow_drop_down),
                            ),
                            onTap: () {
                              Socket.connect(widget.hostIP, 5650)
                                  .then((socket) {
                                socket.write('114');
                              });
                            },
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.blueGrey, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () {
                              Socket.connect(widget.hostIP, 5650)
                                  .then((socket) {
                                socket.write('103');
                              });
                            },
                            icon: MyIcon.Icon(Icons.arrow_upward)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.blueGrey, shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                Socket.connect(widget.hostIP, 5650)
                                    .then((socket) {
                                  socket.write('105');
                                });
                              },
                              icon: MyIcon.Icon(Icons.arrow_back_outlined),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.blueGrey, shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                Socket.connect(widget.hostIP, 5650)
                                    .then((socket) {
                                  socket.write('106');
                                });
                              },
                              icon: MyIcon.Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.blueGrey, shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {
                            Socket.connect(widget.hostIP, 5650)
                                .then((socket) {
                              socket.write('108');
                            });
                          },
                          icon: MyIcon.Icon(Icons.arrow_downward),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 156,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: ClipOval(
                          child: Material(
                            child: InkWell(
                              splashColor: Colors.white24,
                              child: SizedBox(
                                height: 56,
                                width: 56,
                                child: MyIcon.Icon(Icons.arrow_left_sharp),
                              ),
                              onTap: () {
                                Socket.connect(widget.hostIP, 5650)
                                    .then((socket) {
                                  socket.write('105');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'CH',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: ClipOval(
                          child: Material(
                            child: InkWell(
                              splashColor: Colors.white24,
                              child: SizedBox(
                                height: 56,
                                width: 56,
                                child: MyIcon.Icon(Icons.arrow_right_sharp),
                              ),
                              onTap: () {
                                Socket.connect(widget.hostIP, 5650)
                                    .then((socket) {
                                  socket.write('106');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.white70,
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Image.asset('assets/netflix.png'),
                    ),
                    onTap: () async {
                      var client = HttpClient();
                      http.post(
                          Uri.parse('http://'+widget.hostIP+':56889/apps/Netflix/')
                      );
                    },
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.white70,
                    //color:Colors.blue.shade400,
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset('assets/youtube.png'),
                    ),
                    onTap: () async {
                      var client = HttpClient();
                      http.post(
                          Uri.parse('http://'+widget.hostIP+':56889/apps/YouTube/'),
                          headers: {"Origin": "https://www.youtube.com"}
                      );
                    },
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(18.0),
                    color:Colors.white70,
                    //color: Color(0xFFE2474C),
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      //child: MyIcon.Icon(Icons.mic),
                      child: Image.asset('assets/prime.png'),
                    ),
                    onTap: () {
                    },
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        // If not yet listening for speech start, otherwise stop
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        //child: Icon(_speechToText.isNotListening ? Icons.bubble_chart : Icons.bubble_chart),
      ),
    );
  }

  void _parseVoice() {
    _speechToText.isListening
        ? '$_lastWords'
        : _speechEnabled
        ? 'Tap the microphone to start listening...'
        : 'Speech not available';
  }
}
