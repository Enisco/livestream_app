// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:livestream_app/livestream/view.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamVideo(
    'hd8szvscpxvd',
    user: User.regular(userId: 'vasil', role: 'admin', name: 'Willard Hessel'),
    userToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmFzaWwifQ.N44i27-o800njeSlcvH2HGlBfTl8MH4vQl0ddkq5BVI',
  );
  print("${StreamVideo.instance.currentUser}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livestream App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Livestream App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController idController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
  }

  _createLivestream({String? joiningId}) async {
    final call = StreamVideo.instance.makeCall(
      type: 'livestream',
      id: joiningId ?? 'test_stream',
    );

    call.connectOptions = CallConnectOptions(
      camera: TrackOption.enabled(),
      microphone: TrackOption.enabled(),
    );

    final result = await call.getOrCreate();
    if (result.isSuccess) {
      await call.join();
      if (joiningId == null) {
        // Create call and go Live, as creator
        await call.goLive();
        print(' +++++++++++++ Creating call ${call.id}');
      } else {
        print(' >>>>>>>>> Joining call ${call.id}');
      }
      Navigator.of(context).push(LiveStreamScreen.route(call));
    } else {
      print(' --------- Not able to create or join a call.');
    }
  }

  _joinCall() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Enter your livestream ID'),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: idController,
                ),
              ),
              TextButton(
                onPressed: () {
                  _createLivestream(joiningId: idController.value.text);
                },
                child: const Text('Join'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to my livestreaming app',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _createLivestream(),
              child: const Text('Create a Livestream'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _joinCall(),
              child: const Text('Join a Livestream'),
            ),
          ],
        ),
      ),
    );
  }
}
