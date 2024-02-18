// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatelessWidget {
  static route(Call call) => MaterialPageRoute(
        builder: (context) {
          return LiveStreamScreen(currentStream: call);
        },
      );

  const LiveStreamScreen({
    super.key,
    required this.currentStream,
  });

  final Call currentStream;

  bool checkViewToUse(List<CallParticipantState> callParticipants,
      String desiredParticipantId) {
    for (var callParticipant in callParticipants) {
      if (callParticipant.userId == "enisco00") {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder(
        stream: currentStream.state.valueStream,
        initialData: currentStream.state.value,
        builder: (context, snapshot) {
          final callState = snapshot.data!;
          print(" -------- ${callState.callParticipants}");
          // final participant = callState.callParticipants.firstWhere(
          //   (element) => element.userId == 'enisco00',
          //   // (element) => element.userId == 'enisco',
          // );

          bool check = checkViewToUse(callState.callParticipants, "enisco00");
          final CallParticipantState participant;
          if (check) {
            participant = callState.callParticipants.firstWhere(
              (element) => element.userId == 'enisco00',
            );
          } else {
            participant = callState.callParticipants.firstWhere(
              (element) => element.userId == 'eniola2',
            );
          }

          print(
              " /////////////// userId: ${participant.userId} \n isVideoEnabled: ${participant.isVideoEnabled} \nisSpeaking: ${participant.isSpeaking} \naudioLevel: ${participant.audioLevel}");
          return Stack(
            children: [
              if (snapshot.hasData)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                    ),
                    height: size.height * 0.5,
                    width: size.width * 0.8,
                    child: StreamVideoRenderer(
                      call: currentStream,
                      videoTrackType: SfuTrackType.video,
                      participant: participant,
                      videoFit: VideoFit.cover,
                      onSizeChanged: (value) {
                        print("New Video Size: $value");
                      },
                    ),
                  ),
                ),
              if (!snapshot.hasData)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (snapshot.hasData && callState.status.isDisconnected)
                const Center(
                  child: Text('Stream not live'),
                ),
              Positioned(
                top: 12.0,
                left: 12.0,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.red,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Viewers: ${callState.callParticipants.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (callState.localParticipant?.userId ==
                  callState.createdByUserId)
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.black,
                    child: InkWell(
                      onTap: () {
                        currentStream.end();
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'End Call',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (callState.localParticipant?.userId !=
                  callState.createdByUserId)
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.black,
                    child: InkWell(
                      onTap: () {
                        currentStream.leave();
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Leave Call',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
