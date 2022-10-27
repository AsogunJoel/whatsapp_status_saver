import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.file(
        File(
          imagePath,
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Text(
            'Unavailable, please refresh',
            textAlign: TextAlign.center,
          ),
        ),
        fit: BoxFit.contain,
      ),
    );
  }
}

class ImagePageView extends StatefulWidget {
  const ImagePageView({super.key, required this.imageIndex});
  final int imageIndex;
  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  InterstitialAd? _interstitialAd;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.imageIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController!,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _loadInterstitialAd();
    Provider.of<GetStatusProvider>(
      context,
      listen: false,
    ).imageSaved = false;
    imagePath = Provider.of<GetStatusProvider>(
      context,
      listen: false,
    ).getImages[widget.imageIndex].status.path;
  }

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
            print('new adk,mnbv');
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  Future<File> localFile() async {
    return File('$imagePath');
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _interstitialAd?.dispose();
  }

  String? imagePath;
  int? pagenumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<GetStatusProvider>(
        builder: (context, file, child) {
          return PageView.builder(
            controller: _pageController,
            itemCount: file.getImages.length,
            itemBuilder: (context, index) {
              return ImageView(
                imagePath: file.getImages[index].status.path,
              );
            },
            onPageChanged: (value) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              setState(() {
                imagePath = file.getImages[value].status.path;
                pagenumber = value;
              });
              file.resetimageSaved();
              _animationController!.reverse();
              if (_interstitialAd == null) {
                _loadInterstitialAd();
              }
            },
          );
        },
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
                      borderRadius: BorderRadius.circular(5),
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
                              style: TextStyle(fontSize: 16),
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
                                              'Picture already saved',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        )
                                      : statusProvider
                                          .saveImagetoGallery(imagePath)
                                          .then(
                                          (file) {
                                            if (_interstitialAd != null) {
                                              _interstitialAd?.show();
                                            }
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
                                                  'Picture saved',
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
                _animationController!.reverse();
                statusProvider.shareImage(imagePath);
              },
            ),
            Bubble(
              title: "Print",
              iconColor: Colors.white,
              bubbleColor: Colors.green,
              icon: Icons.print,
              titleStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              onPress: () {
                _animationController!.reverse();
                statusProvider.printImage(
                  imagePath,
                  imagePath!.split('/').last,
                );
              },
            ),
          ],
          animation: _animation!,
          onPress: () => _animationController!.isCompleted
              ? _animationController!.reverse()
              : _animationController!.forward(),
          iconColor: Colors.white,
          iconData: Icons.download_rounded,
          backGroundColor: Colors.green,
        ),
      ),
    );
  }
}
