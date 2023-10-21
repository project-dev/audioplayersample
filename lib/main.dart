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

  final audioplayers.AudioPlayer _audioPlayer = audioplayers.AudioPlayer();
  audioplayers.AssetSource? _audioPlayerSource;

  final just_audio.AudioPlayer _justAudioPlayer = just_audio.AudioPlayer();

  static const String _applicationName = "AudioPlayerSample";

  bool _isInitialize = false;

  @override
  void initState() {
    super.initState();
  }

  void _initialize() async{
    try{
      developer.log("audioplayers initialize start.", name: _applicationName);
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.setReleaseMode(audioplayers.ReleaseMode.loop);
      _audioPlayerSource = audioplayers.AssetSource('SampleBGM.mp3');
      developer.log("audioplayers initialize end.", name: _applicationName);
    }catch(e){
      developer.log("$e", name: _applicationName);
      return;
    }

    try{
      developer.log("just_audio initialize start.", name: _applicationName);
      await _justAudioPlayer.setVolume(1.0);
      await _justAudioPlayer.setLoopMode(just_audio.LoopMode.all);
      await _justAudioPlayer.setAsset('assets/SampleBGM.mp3');
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
                      TextButton.icon(
                        onPressed: !_isInitialize ? null :  (){
                          _audioPlayer.play(_audioPlayerSource!);
                        },
                        icon: const Icon(Icons.play_circle, size: 64),
                        label: const Text(
                          'Play',
                          style: TextStyle(fontSize: 64)
                        ),
                      ),
                      TextButton.icon(
                        onPressed: !_isInitialize ? null :  (){
                          _audioPlayer.stop();
                        },
                        icon: const Icon(Icons.stop_circle, size: 64),
                        label: const Text(
                          'Stop',
                          style: TextStyle(fontSize: 64)
                        )
                      ),
                    ]
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
                      TextButton.icon(
                        onPressed: !_isInitialize ? null :  (){
                          _justAudioPlayer.play();
                        },
                        icon: const Icon(Icons.play_circle, size: 64),
                        label: const Text(
                          'Play',
                          style: TextStyle(fontSize: 64)
                        )
                      ),
                      TextButton.icon(
                        onPressed: !_isInitialize ? null :  (){
                          _justAudioPlayer.stop();
                        },
                        icon: const Icon(Icons.stop_circle, size: 64),
                        label: const Text(
                          'Stop',
                          style: TextStyle(fontSize: 64)
                        )
                      ),
                    ]
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
