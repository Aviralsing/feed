import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:starter/screens/like_icon.dart';
import 'package:starter/screens/options_screen.dart';
import 'package:video_player/video_player.dart';

class ContentScreen extends StatefulWidget {
  final String src;
  const ContentScreen({required Key key, required this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _liked = false;
  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  initializePlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.src);
    _videoPlayerController.initialize().then((value) => {
          _chewieController = new ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            showControls: false,
            looping: true,
          )
        });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
                _chewieController.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _liked = !_liked;
                  });
                },
                child: Chewie(
                  controller: _chewieController,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading...')
                ],
              ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionsScreen()
      ],
    );
  }
}
