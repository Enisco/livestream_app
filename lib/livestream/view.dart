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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: currentStream.state.valueStream,
        initialData: currentStream.state.value,
        builder: (context, snapshot) {
          final callState = snapshot.data!;
          print(" -------- ${callState.callParticipants}");
          final participant = callState.callParticipants.first;
          // .firstWhere((element) => element.isVideoEnabled);
          return Stack(
            children: [
              if (snapshot.hasData)
                StreamVideoRenderer(
                  call: currentStream,
                  videoTrackType: SfuTrackType.video,
                  participant: participant,
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
                    child: GestureDetector(
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
                    child: GestureDetector(
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
                )
            ],
          );
        },
      ),
    );
  }
}
