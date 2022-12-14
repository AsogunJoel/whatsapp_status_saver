import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/providers/gb_provider.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/image/single_page_image.dart';

import '../../../../providers/business_provider.dart';

class BusinessImagePageView extends StatefulWidget {
  const BusinessImagePageView({super.key, required this.imageIndex});
  final int imageIndex;
  @override
  State<BusinessImagePageView> createState() => _BusinessImagePageViewState();
}

class _BusinessImagePageViewState extends State<BusinessImagePageView>
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
    Provider.of<GBStatusProvider>(
      context,
      listen: false,
    ).imageSaved = false;
    imagePath = Provider.of<BusinessStatusProvider>(
      context,
      listen: false,
    ).businessgetImages[widget.imageIndex].status.path;
    Provider.of<BusinessStatusProvider>(
      context,
      listen: false,
    ).resetimageSaved();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdState.businessinterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _loadInterstitialAd();
            },
          );
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
      body: Consumer<BusinessStatusProvider>(
        builder: (context, yoFile, child) {
          return PageView.builder(
            controller: _pageController,
            itemCount: yoFile.businessgetImages.length,
            itemBuilder: (context, index) {
              return SinglePageImage(
                filePath: yoFile.businessgetImages[index].status.path,
              );
            },
            onPageChanged: (value) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              yoFile.resetimageSaved();
              imagePath = yoFile.businessgetImages[value].status.path;
              pagenumber = value;
              _animationController!.reverse();
              if (_interstitialAd == null) {
                _loadInterstitialAd();
              }
            },
          );
        },
      ),
      floatingActionButton:
          Consumer2<GetStatusProvider, BusinessStatusProvider>(
        builder: (context, statusProvider, businessprov, child) =>
            FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Save",
              iconColor: Colors.white,
              bubbleColor: Colors.green,
              icon: Icons.save,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                _animationController!.reverse();
                businessprov.imageSaved
                    ? ScaffoldMessenger.of(context).showSnackBar(
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
                    : statusProvider.saveImagetoGallery(imagePath).then(
                        (file) {
                          businessprov.imageSaved = true;
                          if (_interstitialAd != null) {
                            _interstitialAd?.show();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              backgroundColor: Colors.green,
                              content: Text(
                                'Picture saved',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
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
                statusProvider.shareImage(imagePath).then((value) {});
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
