import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;
  final int likeCount;
  final String description;

  const FullScreenVideoPage({
    required this.videoUrl,
    required this.likeCount,
    required this.description,
  });

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _videoController;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController
            .play(); // Start playing the video once it's initialized
      });
    _listener = () {
      if (mounted) setState(() {});
    };
    _videoController.addListener(_listener);
  }

  @override
  void dispose() {
    _videoController.pause(); // Pause the video before disposing
    _videoController.removeListener(_listener);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : CircularProgressIndicator(),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _ControlsOverlay(
              controller: _videoController,
              likeCount: widget.likeCount,
              description: widget.description,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  final int likeCount;
  final String description;

  const _ControlsOverlay({
    required this.controller,
    required this.likeCount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ExpandableText(
              text: description,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                color: Colors.white,
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  // Add your comment functionality here
                },
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      // Add your like functionality here
                    },
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '$likeCount',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Add your share functionality here
                },
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({required this.text});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;
  bool canExpand = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _checkExpandable();
    });
  }

  void _checkExpandable() {
    final span = TextSpan(text: widget.text);
    final tp = TextPainter(
      text: span,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width);
    setState(() {
      canExpand = tp.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxLines =
        isExpanded ? null : 1; // Show all lines if expanded, otherwise 1 line

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(color: Colors.white),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (canExpand)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'See less' : 'See more',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
