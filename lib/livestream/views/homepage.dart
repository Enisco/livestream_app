// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livestream_app/extras/custom_textfield.dart';
import 'package:livestream_app/extras/spacer.dart';
import 'package:livestream_app/livestream/views/livestream_page.dart';
import 'package:livestream_app/models/stream_token_model.dart';
import 'package:livestream_app/services/api_services.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController streamIdController, userIdController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    streamIdController = TextEditingController();
    userIdController = TextEditingController();
  }

  generateUserToken({required String userId, required bool isCreating}) {
    setState(() {
      loading = true;
    });
    ApiService apiService = ApiService();

    final response = apiService.generateToken(userId);
    if (response.toString() == "error") {
      Fluttertoast.showToast(msg: "Error occured");
      setState(() {
        loading = false;
      });
    } else {
      UserLivestreamTokenModel tokenData = UserLivestreamTokenModel.fromJson(
        json.decode(
          response.toString(),
        ),
      );
      print(" ********** tokenData: ${tokenData.toJson()}");
      _createOrJoinLivestream(
        isCreating: isCreating,
        userStreamToken: tokenData.token!,
      );
    }
  }

  _createOrJoinLivestream({
    required bool isCreating,
    required String userStreamToken,
  }) async {
    try {
      final apiKey = 'hd8szvscpxvd',
          token = userStreamToken,
          // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmFzaWwifQ.N44i27-o800njeSlcvH2HGlBfTl8MH4vQl0ddkq5BVI',
          userId = userIdController.text.trim(),
          // userName = 'Willard Hessel',
          callId = streamIdController.text.trim();

      StreamVideo(
        apiKey,
        user: User.regular(
          userId: userId,
          role: isCreating ? 'admin' : 'user',
        ),
        userToken: token,
      );
      print("${StreamVideo.instance.currentUser}");

      // -------------------------------------------
      final call = StreamVideo.instance.makeCall(
        type: 'livestream',
        id: callId,
      );

      call.connectOptions = CallConnectOptions(
        camera: TrackOption.enabled(),
        microphone: TrackOption.enabled(),
      );

      final result = await call.getOrCreate();
      if (result.isSuccess) {
        await call.join();
        if (isCreating == true) {
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
    } catch (e) {
      print(' ????????? Error creating or joining a call.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to my livestreaming app',
            ),
            customVerticalSpacer(40),
            CustomTextField(
              textEditingController: streamIdController,
              labelText: "Livestream ID",
              hintText: "Enter the livestream ID",
            ),
            customVerticalSpacer(20),
            CustomTextField(
              textEditingController: userIdController,
              labelText: "Your Username",
              hintText: "Enter your preferred username",
              maxLength: 12,
            ),
            customVerticalSpacer(30),
            ElevatedButton(
              onPressed: () async {
                final userID = userIdController.text.trim();
                await generateUserToken(userId: userID, isCreating: true);
              },
              child: const Text('Create a Livestream'),
            ),
            customVerticalSpacer(15),
            ElevatedButton(
              onPressed: () async {
                final userID = userIdController.text.trim();
                await generateUserToken(userId: userID, isCreating: false);
              },
              child: const Text('Join a Livestream'),
            ),
          ],
        ),
      ),
    );
  }
}
