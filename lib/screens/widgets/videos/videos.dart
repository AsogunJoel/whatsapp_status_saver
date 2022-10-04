import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/directory_response/check_directory_response.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';

import '../../../providers/get_statuses_provider.dart';
import '../../../utils/get_thumbails.dart';
import 'video_view.dart';

class WhatsappVideoPage extends StatefulWidget {
  const WhatsappVideoPage({super.key});

  @override
  State<WhatsappVideoPage> createState() => _WhatsappVideoPageState();
}

class _WhatsappVideoPageState extends State<WhatsappVideoPage> {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(
      context,
    );
    adState.initialization.then((value) {
      setState(() {
        _bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState.videobannerAdUnitId,
          listener: adState.adListener,
          request: const AdRequest(),
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_bannerAd != null)
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 50,
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        Expanded(
          child: VideoGrid(),
        ),
      ],
    );
  }
}

class VideoGrid extends StatefulWidget {
  const VideoGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<GetStatusProvider>(
      builder: (context, file, child) {
        if (file.itemsData.status == Status.COMPLETED &&
            file.getVideos.isNotEmpty) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 2.5 / 3,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: file.getVideos.length,
            itemBuilder: (context, index) {
              String pathhh = file.getVideos[index].status.path;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => VideoView(
                          videoPath: file.getVideos[index].status.path),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleVideo(file: pathhh),
                ),
              );
            },
          );
        } else if (file.itemsData.status == Status.LOADING) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (file.getVideos.isEmpty) {
          return const Center(
            child: Text(
              'No recently viewed videos',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: .5,
                fontSize: 15,
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: .5,
                fontSize: 15,
              ),
            ),
          );
        }
      },
    );
  }
}

class SingleVideo extends StatefulWidget {
  const SingleVideo({
    Key? key,
    this.file,
  }) : super(key: key);
  final String? file;

  @override
  State<SingleVideo> createState() => _SingleVideoState();
}

class _SingleVideoState extends State<SingleVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: getThumbnail(widget.file),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(
                snapshot.data!,
              ),
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text(
                  'Unavailable',
                  textAlign: TextAlign.center,
                ),
              ),
              fit: BoxFit.cover,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(30.0),
            child: SizedBox(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text(
            'Unavailable, please refresh',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
