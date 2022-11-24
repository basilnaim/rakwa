import 'package:flutter/material.dart';
import 'package:rakwa/main.dart';
import 'package:video_player/video_player.dart';

class VideoContainer extends StatefulWidget {
  const VideoContainer({Key? key, this.video}) : super(key: key);
  final String? video;
  @override
  _VideoContainerState createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.video??"",
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller?.addListener(() {
      setState(() {});
    });
    _controller?.setLooping(true);
    _controller?.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: MyApp.resources.color.borderColor),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: _controller!.value.isInitialized
          ? Stack(children: [
              GestureDetector(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    print('playing now');
                    _controller!.pause();
                  } else {
                    print('stopped now');
                    _controller!.play();
                  }
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: VideoPlayer(_controller!),
                ),
              ),
              Visibility(
                visible: (_controller!.value.isPlaying) ? false : true,
                child: Center(
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: InkWell(
                        onTap: () {
                          if (_controller!.value.isPlaying) {
                            print('playing now');
                            _controller!.pause();
                          } else {
                            print('stopped now');
                            _controller!.play();
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(18))),
                  child: Row(children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: MyApp.resources.color.orange,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "230K",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    )
                  ]),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(18))),
                  child: Row(children: const [
                    Text(
                      "Checkout Cairo Restaurant and Cafe",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    )
                  ]),
                ),
              )
            ])
          : Center(
              child: CircularProgressIndicator(
                color: MyApp.resources.color.orange,
              ),
            ),
    );
  }
}
