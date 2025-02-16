// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatelessWidget {
  static route(Call call, String myUserId, String remoteIdToView) =>
      MaterialPageRoute(
        builder: (context) {
          return LiveStreamScreen(
              currentStream: call,
              myUserId: myUserId,
              remoteIdToView: remoteIdToView);
        },
      );
  final String myUserId, remoteIdToView;

  const LiveStreamScreen({
    super.key,
    required this.currentStream,
    required this.remoteIdToView,
    required this.myUserId,
  });

  final Call currentStream;

  bool checkViewToUse(List<CallParticipantState> callParticipants,
      String desiredParticipantId) {
    for (var callParticipant in callParticipants) {
      if (callParticipant.userId == remoteIdToView) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: currentStream.state.valueStream,
          initialData: currentStream.state.value,
          builder: (context, snapshot) {
            final callState = snapshot.data!;
            print(" -------- ${callState.callParticipants}");
            print(" No of participants: ${callState.callParticipants.length}");

            bool check =
                checkViewToUse(callState.callParticipants, remoteIdToView);
            final CallParticipantState participant;
            if (check) {
              participant = callState.callParticipants.firstWhere(
                (element) => element.userId == remoteIdToView,
              );
            } else {
              participant = callState.callParticipants.firstWhere(
                (element) => element.userId == myUserId,
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
                        border: Border.all(
                          color: Colors.lightGreen,
                          width: 2,
                        ),
                      ),
                      height: size.height,
                      width: size.width,
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
                          'Count: ${callState.callParticipants.length - 1}',
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
                        onTap: () async {
                          // final listRecordings =
                          //     await currentStream.listRecordings();
                          // print(
                          //     " --------------- listRecordings: ${listRecordings.toString()} ");
                          // final listRecordingsCall =
                          //     await currentStream.listRecordings.call();
                          // print(
                          //     " **************** listRecordingsCall: ${listRecordingsCall.toString()} ");

                          // final endCall = currentStream.end();
                          // print(
                          //     " ================ endCall: ${endCall.toString()} /n After endcall ");

                          // final listRecordingsEnd =
                          //     await currentStream.listRecordings();
                          // print(
                          //     " --------------- listRecordingsEnd: ${listRecordingsEnd.toString()} ");
                          // final listRecordingsCallEnd =
                          //     await currentStream.listRecordings.call();
                          // print(
                          //     " **************** listRecordingsCallEnd: ${listRecordingsCallEnd.toString()} ");

                          // Navigator.pop(context);
                          
                          currentStream.leave();
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
      ),
    );
  }
}
