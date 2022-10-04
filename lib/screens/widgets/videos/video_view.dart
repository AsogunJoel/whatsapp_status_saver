import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _VideoViewState extends State<VideoView>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    Provider.of<GetStatusProvider>(
      context,
      listen: false,
    ).imageSaved = false;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController!,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _controller = VideoPlayerController.file(
      File(widget.videoPath),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.file(
        File(widget.videoPath),
      ),
      allowFullScreen: true,
      allowMuting: true,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      allowPlaybackSpeedChanging: true,
      errorBuilder: (context, errorMessage) {
        return Dialog(
          child: Text(errorMessage),
        );
      },
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    _chewieController!.addListener(
      () {
        if (!_chewieController!.isFullScreen) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
        if (!_chewieController!.isPlaying) {}
      },
    );
    _loadInterstitialAd();
    _chewieController!.autoInitialize;
  }

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdState.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _loadInterstitialAd();
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

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
    _controller.dispose();
    _chewieController!.pause();
    _chewieController!.dispose();
  }

  ChewieController? _chewieController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : const Center(
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                      strokeWidth: 1.0,
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: Consumer<GetStatusProvider>(
        builder: (context, statusProvider, child) => FloatingActionBubble(
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
                                  //   _loadInterstitialAd();
                                  // }
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  _animationController!.reverse();
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
                                          .saveImagetoGallery(widget.videoPath)
                                          .then(
                                          (value) {
                                            if (_interstitialAd != null) {
                                              _interstitialAd?.show();
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
                                            } else {
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
                                            }
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
                if (_interstitialAd == null) {
                  _loadInterstitialAd();
                }
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
                  _animationController!.reverse();
                });
              },
            ),
            Bubble(
              title: "Delete",
              iconColor: Colors.white,
              bubbleColor: Colors.red,
              icon: Icons.delete,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController!.reverse();
              },
            ),
          ],

          animation: _animation!,

          onPress: () => _animationController!.isCompleted
              ? _animationController!.reverse()
              : _animationController!.forward(),
          // Floating Action button Icon color
          iconColor: Colors.white,
          // Flaoting Action button Icon
          iconData: Icons.download_rounded,
          backGroundColor: Colors.green,
        ),
      ),
    );
  }
}
