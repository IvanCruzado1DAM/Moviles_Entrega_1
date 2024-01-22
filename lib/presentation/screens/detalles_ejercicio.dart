import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:mindcare/models/exercises.dart';
import 'package:mindcare/presentation/screens/mind_fulness_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mindcare/services/exercise.services.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as av;
import 'package:mindcare/services/user_services.dart';
import 'package:mindcare/presentation/screens/mind_fulness_screen.dart';
import 'package:mindcare/presentation/screens/user_screen.dart';

class DetalleEjercicio extends StatefulWidget {
  final ExerciseData ejercicio;

  DetalleEjercicio({required this.ejercicio});

  @override
  _DetalleEjercicioState createState() => _DetalleEjercicioState();
}

class _DetalleEjercicioState extends State<DetalleEjercicio> {
  final _player = just_audio.AudioPlayer();
  final ExerciseService exerciseService = ExerciseService();
  late bool isExerciseCompleted = true;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setUpAudioPlayer();
  }

  Future<void> _setUpAudioPlayer() async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stracktrace) {
      print("$e");
    });
    try {
      _player.setAudioSource(
          just_audio.AudioSource.uri(Uri.parse(widget.ejercicio.audio!)));
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Widget _playbackControlButton() {
    return StreamBuilder<just_audio.PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final processingState = snapshot.data?.processingState;
          final playing = snapshot.data?.playing;
          if (processingState == just_audio.ProcessingState.loading ||
              processingState == just_audio.ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 64,
              height: 64,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 64,
              onPressed: _player.play,
            );
          } else if (processingState != just_audio.ProcessingState.completed) {
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 64,
              onPressed: _player.pause,
            );
          } else {
            return IconButton(
              icon: const Icon(Icons.replay),
              iconSize: 64,
              onPressed: () => _player.seek(Duration.zero),
            );
          }
        });
  }

  Widget _progressBar() {
    return StreamBuilder<Duration?>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return av.ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          total: _player.duration ?? Duration.zero,
          onSeek: (duration) {
            _player.seek(duration);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ExerciseService es = ExerciseService();
    return WillPopScope(
        onWillPop: () async {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(16, 239, 109, 8),
                      Colors.blue.shade900
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.ejercicio.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.grey,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          decorationThickness: 2.0,
                          fontFamily: 'Pacifico',
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    if (widget.ejercicio.video != null &&
                        widget.ejercicio.audio == null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.ejercicio.video != null)
                                YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId:
                                        YoutubePlayer.convertUrlToId(
                                                widget.ejercicio.video!) ??
                                            '',
                                    flags: const YoutubePlayerFlags(
                                      autoPlay: false,
                                      mute: false,
                                      controlsVisibleAtStart: false,
                                    ),
                                  ),
                                  showVideoProgressIndicator: true,
                                ),
                              const SizedBox(height: 16.0),
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.ejercicio.explanation,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    es.newExerciseMade(
                                      int.parse(UserService.userId),
                                      widget.ejercicio.id,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Ejercicio realizado correctamente'),
                                      ),
                                    );

                                    await Future.delayed(Duration(seconds: 3));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UserScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check, color: Colors.white),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Hecho',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (widget.ejercicio.audio != null &&
                        widget.ejercicio.video == null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    _progressBar(),
                                    Row(
                                      children: [
                                        _playbackControlButton(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                widget.ejercicio.explanation,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  es.newExerciseMade(
                                    int.parse(UserService.userId),
                                    widget.ejercicio.id,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Ejercicio realizado correctamente'),
                                    ),
                                  );

                                  await Future.delayed(Duration(seconds: 3));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          UserScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check, color: Colors.white),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'Hecho',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    if (widget.ejercicio.audio == null &&
                        widget.ejercicio.video == null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Image.network(
                                widget.ejercicio.image,
                                height: 130.0,
                                width: 350.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Text(
                                widget.ejercicio.explanation,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: isExerciseCompleted
                                    ? null // Si el ejercicio ya está realizado, el botón estará desactivado.
                                    : () async {
                                        es.newExerciseMade(
                                          int.parse(UserService.userId),
                                          widget.ejercicio.id,
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Ejercicio realizado correctamente'),
                                          ),
                                        );

                                        await Future.delayed(
                                            Duration(seconds: 3));
                                        setState(() {
                                          isExerciseCompleted = true;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UserScreen(),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check, color: Colors.white),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      isExerciseCompleted
                                          ? 'Ejercicio Realizado'
                                          : 'Hecho',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: const Text('Detalles del Ejercicio'),
          ),
        ));
  }
}
