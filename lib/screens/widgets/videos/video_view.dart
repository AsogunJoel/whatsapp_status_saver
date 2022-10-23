import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key, required this.videoPath});
  final String videoPath;
  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> with TickerProviderStateMixin {
  AnimationController? _animationController;
  bool isPlaying = false;
  Animation<double>? _animation;

  AnimationController? _animationControllerrrr;
  VideoPlayerController? _controller;

  _playVideo({required String file}) {
    localFile().then((value) {
      _controller = VideoPlayerController.file(
        value,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )
        ..addListener(() {
          setState(() {});
        })
        ..setLooping(false)
        ..initialize();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.videoPath),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize();
    _animationControllerrrr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationControllerrrr!,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdState.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              loadInterstitialAd();
            },
          );
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  Future<File> localFile() async {
    return File(widget.videoPath);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    _animationController!.dispose();
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  void _handleOnPressed() {
    setState(() {
      _controller!.pause();
      isPlaying = !isPlaying;
      isPlaying
          ? _controller!.play().then((value) {
              _animationController!.forward();
            })
          : _controller!.pause().then((value) {
              _animationController!.reverse();
            });
    });
  }

  void _fastForward() async {
    await _controller!.seekTo(
      (await _controller!.position)! + const Duration(seconds: 3),
    );
  }

  void _rewindback() async {
    await _controller!.seekTo(
      (await _controller!.position)! - const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _controller!.value.isInitialized
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(
                          _controller!,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: _controller!,
                                  builder: (context, value, child) {
                                    return Text(
                                      _videoDuration(value.position),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Expanded(
                                  child: VideoProgressIndicator(
                                    _controller!,
                                    allowScrubbing: true,
                                    padding: const EdgeInsets.all(10),
                                    colors: const VideoProgressColors(
                                      playedColor: Colors.green,
                                    ),
                                  ),
                                ),
                                Text(
                                  _videoDuration(_controller!.value.duration),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FloatingActionButton.small(
                                  heroTag: 'back',
                                  key: const ValueKey('back'),
                                  onPressed: () {
                                    _rewindback();
                                  },
                                  child: const Icon(
                                    Icons.fast_rewind,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      iconSize: 25,
                                      splashColor: Colors.grey,
                                      icon: AnimatedIcon(
                                        icon: AnimatedIcons.play_pause,
                                        progress: _animationController!,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _handleOnPressed(),
                                    ),
                                  ),
                                ),
                                FloatingActionButton.small(
                                  heroTag: 'forward',
                                  key: const ValueKey('forward'),
                                  onPressed: () {
                                    _fastForward();
                                  },
                                  child: const Icon(
                                    Icons.fast_forward,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : const Padding(
                padding: EdgeInsets.all(180.0),
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: Consumer<GetStatusProvider>(
        builder: (context, statusProvider, child) => Transform.translate(
          offset: const Offset(-10, -60),
          child: FloatingActionBubble(
            items: <Bubble>[
              Bubble(
                title: "Save",
                iconColor: Colors.white,
                bubbleColor: Colors.green,
                icon: Icons.save,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'Image will be saved to gallery',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    // if (_interstitialAd == null) {
                                    //   loadInterstitialAd();
                                    // }
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    _animationControllerrrr!.reverse();
                                    statusProvider.imageSaved
                                        ? ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            const SnackBar(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                'Video already saved',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          )
                                        : statusProvider
                                            .saveImagetoGallery(
                                                widget.videoPath)
                                            .then(
                                            (value) {
                                              if (_interstitialAd != null) {
                                                _interstitialAd?.show();
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .clearSnackBars();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    'Video saved',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                  },
                                  child: const Text('Continue'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Bubble(
                title: "Share",
                iconColor: Colors.white,
                bubbleColor: Colors.green,
                icon: Icons.share,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  if (_interstitialAd != null) {
                    _interstitialAd?.show();
                  }
                  statusProvider.shareImage(widget.videoPath).then((value) {
                    _animationControllerrrr!.reverse();
                  });
                },
              ),
            ],
            animation: _animation!,
            onPress: () => _animationControllerrrr!.isCompleted
                ? _animationControllerrrr!.reverse()
                : _animationControllerrrr!.forward(),
            iconColor: Colors.white,
            iconData: Icons.download_rounded,
            backGroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
