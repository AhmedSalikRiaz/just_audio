// Reproduction: setting LoopMode.one as the player auto-advances to the next
// item makes iOS run currentIndex to the end of the playlist.
//
// Expected: item 1 starts and loops. iOS: currentIndex jumps 1 -> 2 -> 3.

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const MaterialApp(home: Repro()));

class Repro extends StatefulWidget {
  const Repro({super.key});

  @override
  State<Repro> createState() => _ReproState();
}

class _ReproState extends State<Repro> {
  final _player = AudioPlayer();
  final _log = <String>[];

  @override
  void initState() {
    super.initState();
    _player.currentIndexStream.listen((index) {
      setState(() => _log.add('currentIndex: $index'));
      // Loop item 1 as soon as the player moves onto it.
      if (index == 1) _player.setLoopMode(LoopMode.one);
    });
    _start();
  }

  Future<void> _start() async {
    await _player.setAudioSources([
      for (var i = 1; i <= 4; i++)
        AudioSource.uri(Uri.parse('https://everyayah.com/data/Alafasy_128kbps/00100$i.mp3')),
    ]);
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('LoopMode.one after auto-advance')),
        body: ListView(children: [for (final line in _log) ListTile(title: Text(line))]),
      );
}
