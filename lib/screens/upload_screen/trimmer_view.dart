import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rubidya/screens/upload_screen/Upload_Details_page.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  const TrimmerView(this.file, {Key? key}) : super(key: key);

  @override
  State<TrimmerView> createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0;
  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() async {
    await _trimmer.loadVideo(videoFile: widget.file);
    final videoDuration =
        _trimmer.videoPlayerController!.value.duration.inSeconds;
    setState(() {
      _endValue = videoDuration.toDouble() > 60 ? 60.0 : videoDuration.toDouble();
    });
  }

  void _saveVideo() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue*2000000,
      onSave: (String? videoUrl) {
        setState(() {
          _progressVisibility = false;
        });

        // print(videoUrl);

        if (videoUrl != null) {
          print(_startValue);
          print(_endValue);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => uploadedetails(videoUrl: videoUrl),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error saving video')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (Navigator.of(context).userGestureInProgress) {
        return false;
      } else {
        return true;
      }
    },
    child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Video',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            TextButton(
              onPressed: _progressVisibility ? null : _saveVideo,
              child: const Text('Next'),
            )
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _progressVisibility,
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
              Expanded(child: VideoViewer(trimmer: _trimmer)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    durationStyle: DurationStyle.FORMAT_MM_SS,
                    maxVideoLength: const Duration(seconds: 60),
                    editorProperties: TrimEditorProperties(
                      borderPaintColor: Colors.yellow,
                      borderWidth: 4,
                      borderRadius: 5,
                      circlePaintColor: Colors.yellow.shade800,
                    ),
                    areaProperties:
                    TrimAreaProperties.edgeBlur(thumbnailQuality: 10),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => setState(() {
                      _endValue = value > 60 ? 60 : value;
                    }),
                    onChangePlaybackState: (value) => setState(
                          () => _isPlaying = value,
                    ),
                  ),
                ),
              ),
              TextButton(
                child: _isPlaying
                    ? const Icon(
                  Icons.pause,
                  size: 80.0,
                  color: Colors.white,
                )
                    : const Icon(
                  Icons.play_arrow,
                  size: 80.0,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final playbackState = await _trimmer.videoPlaybackControl(
                    startValue: _startValue,
                    endValue: _endValue,
                  );
                  setState(() => _isPlaying = playbackState);
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}