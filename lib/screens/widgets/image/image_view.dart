import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
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
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.file(
          File(
            widget.imagePath,
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Text(
              'Unavailable, please refresh',
              textAlign: TextAlign.center,
            ),
          ),
          fit: BoxFit.contain,
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
                                              'Picture already saved',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        )
                                      : statusProvider
                                          .saveImagetoGallery(widget.imagePath)
                                          .then(
                                          (value) {
                                            if (_interstitialAd != null) {
                                              _interstitialAd?.show();
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
                                                    'Picture saved',
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
                statusProvider.shareImage(widget.imagePath).then((value) {
                  _animationController!.reverse();
                });
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
                    widget.imagePath, widget.imagePath.split('/').last);
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
          iconColor: Colors.white,
          iconData: Icons.download_rounded,
          backGroundColor: Colors.green,
        ),
      ),
    );
  }
}
