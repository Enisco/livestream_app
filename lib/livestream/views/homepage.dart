// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

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
  late final TextEditingController streamIdController,
      userIdController,
      remoteUserIdController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    streamIdController = TextEditingController();
    userIdController = TextEditingController();
    remoteUserIdController = TextEditingController();
  }

  generateUserToken(
      {required String userId,
      required String remoteIdToView,
      required bool isCreating}) async {
    setState(() {
      loading = true;
    });
    ApiService apiService = ApiService();

    final response = await apiService.generateToken(userId);
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
      print(" ********** token gen: ${tokenData.token?.toString()}");
      _createOrJoinLivestream(
        isCreating: isCreating,
        userStreamToken: tokenData.token!,
        remoteIdToView: remoteIdToView,
      );
    }
  }

  String generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  _createOrJoinLivestream({
    required bool isCreating,
    required String userStreamToken,
    required String remoteIdToView,
  }) async {
    try {
      final apiKey = 'mgeuu28wmz7g',
          token = userStreamToken,
          userId = userIdController.text.trim(),
          userName = '$userId Tester',
          callId = streamIdController.text.trim();
      remoteIdToView = remoteUserIdController.text.trim();
      print(" `````` Call ID: $callId ");

      StreamVideo.reset();

      StreamVideo(
        apiKey,
        user: User.regular(
          userId: userId,
          role: isCreating ? 'gtubeadmin' : 'user',
          name: userName,
        ),
        userToken: token,
        options: const StreamVideoOptions(),
      );
      print("${StreamVideo.instance.currentUser}");

      // -------------------------------------------

      final call = StreamVideo.instance.makeCall(
        callType: StreamCallType.defaultType(),
        id: callId,
      );

      call.connectOptions = CallConnectOptions(
        camera: TrackOption.enabled(),
        microphone: TrackOption.enabled(),
      );

      final result = await call.getOrCreate();
      print(' ========== call result: $result');
      if (result.isSuccess) {
        await call.join();
        if (isCreating == true) {
          // Create call and go Live, as creator
          final goLive = await call.goLive();
          print("Live started: ${goLive.toString()}");
          print(' +++++++++++++ Creating call ${call.id}');
        } else {
          print(' >>>>>>>>> Joining call ${call.id}');
        }
        final recordingUpdate = await call.update(
          recording: const StreamRecordingSettings(
            mode: RecordSettingsMode.available,
            quality: RecordSettingsQuality.n1080p,
          ),
        );
        print("RecordingUpdate: ${recordingUpdate.toString()}");

        Navigator.of(context)
            .push(LiveStreamScreen.route(call, userId, remoteIdToView));
      } else {
        print(' --------- Not able to create or join a call.');
      }
    } catch (e) {
      print(' ????????? Error creating or joining a call: ${e.toString()}.');
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              labelText: "Your User ID",
              hintText: "Enter your preferred user ID",
            ),
            customVerticalSpacer(20),
            CustomTextField(
              textEditingController: remoteUserIdController,
              labelText: "View User ID",
              hintText: "Enter the ID to view",
            ),
            customVerticalSpacer(30),
            SizedBox(
              height: 115,
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final userID = userIdController.text.trim();
                            final remoteUserId =
                                remoteUserIdController.text.trim();
                            await generateUserToken(
                                userId: userID,
                                isCreating: true,
                                remoteIdToView: remoteUserId);
                          },
                          child: const Text('Create a Livestream'),
                        ),
                        customVerticalSpacer(15),
                        ElevatedButton(
                          onPressed: () async {
                            final userID = userIdController.text.trim();
                            final remoteUserId =
                                remoteUserIdController.text.trim();
                            await generateUserToken(
                              userId: userID,
                              isCreating: false,
                              remoteIdToView: remoteUserId,
                            );
                          },
                          child: const Text('Join a Livestream'),
                        ),
                      ],
                    ),
            ),
            customVerticalSpacer(65),
            ElevatedButton(
              onPressed: () async {
                final callQ = await StreamVideo.instance.queryCalls(
                  filterConditions: {},
                );
                print(" --------------- callQ: ${callQ.toString()} ");
              },
              child: const Text('Last Call Rec'),
            ),
          ],
        ),
      ),
    );
  }
}
