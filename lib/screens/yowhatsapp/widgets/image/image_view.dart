import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/providers/yowhatsapp_provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/image/single_page_image.dart';

class YoImagePageView extends StatefulWidget {
  const YoImagePageView({super.key, required this.imageIndex});
  final int imageIndex;
  @override
  State<YoImagePageView> createState() => _YoImagePageViewState();
}

class _YoImagePageViewState extends State<YoImagePageView>
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
    Provider.of<GetYoStatusProvider>(
      context,
      listen: false,
    ).imageSaved = false;
    imagePath = Provider.of<GetYoStatusProvider>(
      context,
      listen: false,
    ).yogetImages[widget.imageIndex].status.path;
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdState.yointerstitialAdUnitId,
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
      body: Consumer2<GetYoStatusProvider, GetStatusProvider>(
        builder: (context, yoFile, file, child) {
          return PageView.builder(
            controller: _pageController,
            itemCount: yoFile.yogetImages.length,
            itemBuilder: (context, index) {
              return SinglePageImage(
                filePath: yoFile.yogetImages[index].status.path,
              );
            },
            onPageChanged: (value) {
              file.resetimageSaved();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              setState(() {
                imagePath = yoFile.yogetImages[value].status.path;
                print(imagePath);
                pagenumber = value;
              });
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
                _animationController!.reverse();
                if (_interstitialAd != null) {
                  _interstitialAd?.show();
                }
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
