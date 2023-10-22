import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // audioplayers
  final audioplayers.AudioPlayer _audioPlayer = audioplayers.AudioPlayer();
  final Map<String, audioplayers.AssetSource> _audioPlayerSourceMap = {};

  // just_audio
  final just_audio.AudioPlayer _justAudioPlayer = just_audio.AudioPlayer();
  String _justAudioAssetName = "";

  // 再生するフォーマット
  static const _formatList = [
    'MP3',
    'M4A',
    'OGG',
    'WAV'
  ];

  // アプリケーション名
  static const String _applicationName = "AudioPlayerSample";

  // 初期化済みフラグ
  bool _isInitialize = false;

  @override
  void initState() {
    super.initState();
  }

  // 初期化
  void _initialize() async{
    try{
      developer.log("audioplayers initialize start.", name: _applicationName);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(audioplayers.ReleaseMode.loop);
      for(var format in _formatList){
        _audioPlayerSourceMap[format] = audioplayers.AssetSource('SampleBGM.${format.toLowerCase()}');
      }
      developer.log("audioplayers initialize end.", name: _applicationName);
    }catch(e){
      developer.log("$e", name: _applicationName);
      return;
    }

    try{
      developer.log("just_audio initialize start.", name: _applicationName);
      await _justAudioPlayer.setVolume(1.0);
      await _justAudioPlayer.setLoopMode(just_audio.LoopMode.all);
      //await _justAudioPlayer.setAsset('assets/SampleBGM.mp3');
      developer.log("just_audio initialize end.", name: _applicationName);
    }catch(e){
      developer.log("$e", name: _applicationName);
      return;
    }

    setState(() {
      _isInitialize = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Audio Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: _isInitialize ? null :  (){
                        _initialize();
                      },
                      icon: const Icon(Icons.run_circle, size: 64),
                      label: const Text(
                          'Initialize',
                          style: TextStyle(fontSize: 64)
                      )
                  ),
                  Container(
                    color: Colors.blue,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'audioplayers',
                      style: TextStyle(fontSize: 64, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var value in _formatList) ...{
                        TextButton.icon(
                          onPressed: !_isInitialize ? null :  (){
                            _audioPlayer.play(_audioPlayerSourceMap[value]!);
                          },
                          icon: const Icon(Icons.play_circle, size: 24),
                          label: Text(
                              value,
                              style: const TextStyle(fontSize: 24)
                          ),
                        ),
                      },
                    ]
                  ),
                  TextButton.icon(
                      onPressed: !_isInitialize ? null :  (){
                        _audioPlayer.stop();
                      },
                      icon: const Icon(Icons.stop_circle, size: 24),
                      label: const Text(
                          'Stop',
                          style: TextStyle(fontSize: 24)
                      )
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  Container(
                    color:Colors.blue,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'just_audio',
                      style: TextStyle(fontSize: 64, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var value in _formatList) ...{
                        TextButton.icon(
                            onPressed: !_isInitialize ? null : () {
                              String assetName = 'assets/SampleBGM.${value.toLowerCase()}';
                              if(_justAudioAssetName == assetName){
                                 //この場合、stop()メソッドで停止した位置からの再生になる。
                                 _justAudioPlayer.play();

                                 // 戦闘から再生したい場合
                                 //_justAudioPlayer.seek(const Duration(seconds: 0, minutes: 0, hours: 0)).then((value) => _justAudioPlayer.play());
                                 //_justAudioPlayer.seek(Duration.zero).then((value) => _justAudioPlayer.play());

                              }else{
                                _justAudioPlayer.setAsset(assetName).then((value){
                                  _justAudioAssetName = assetName;
                                  _justAudioPlayer.play();
                                });
                              }
                            },
                            icon: const Icon(Icons.play_circle, size: 24),
                            label: Text(
                                value,
                                style: const TextStyle(fontSize: 24)
                            )
                        ),
                      },
                    ]
                  ),
                  TextButton.icon(
                      onPressed: !_isInitialize ? null :  (){
                        _justAudioPlayer.stop();
                      },
                      icon: const Icon(Icons.stop_circle, size: 24),
                      label: const Text(
                          'Stop',
                          style: TextStyle(fontSize: 24)
                      )
                  ),
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}
