import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lg_starter_kit/screens/connection_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late FlutterTts _flutterTts;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  Future<void> _initSplash() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // TTS Setup
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    
    // Video Setup
    // Ensure you add 'assets/intro.mp4' to your project!
    _controller = VideoPlayerController.asset('assets/intro.mp4'); 

    try {
      await _controller.initialize();
      if (mounted) {
        setState(() => _initialized = true);
        await _controller.play();
        _flutterTts.speak("Welcome to the Liquid Galaxy Starter Kit.");
        
        _controller.addListener(() {
           if (_controller.value.position >= _controller.value.duration) {
             _nav();
           }
        });
      }
    } catch (e) {
      // Fallback
      if (mounted) _nav();
    }
  }

  void _nav() {
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
     Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (_) => const ConnectionPage()),
     );
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _initialized 
        ? Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : const SizedBox.shrink(),
    );
  }
}
