import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/directory_response/check_directory_response.dart';
import 'package:whatsapp_status_saver/providers/adstate.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/image/image_view.dart';

class WhatsappImagePage extends StatefulWidget {
  const WhatsappImagePage({super.key});

  @override
  State<WhatsappImagePage> createState() => _WhatsappImagePageState();
}

class _WhatsappImagePageState extends State<WhatsappImagePage> {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(
      context,
    );
    adState.initialization.then(
      (value) {
        setState(() {
          _bannerAd = BannerAd(
            size: AdSize.banner,
            adUnitId: AdState.bannerAdUnitId,
            listener: adState.adListener,
            request: const AdRequest(),
          )..load();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: Consumer<GetStatusProvider>(
              builder: (context, file, child) {
                if (file.itemsData.status == Status.COMPLETED &&
                    file.getImages.isNotEmpty) {
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 2.5 / 3,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: file.getImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => ImageView(
                                imagePath: file.getImages[index].status.path,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(
                                file.getImages[index].status.path,
                              ),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Text(
                                  'Unavailable, please refresh',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (file.itemsData.status == Status.ERROR) {
                  return Center(
                    child: Text(
                      file.itemsData.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: .5,
                        fontSize: 15,
                      ),
                    ),
                  );
                } else if (file.itemsData.status == Status.LOADING) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (file.getImages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recently viewed pictures',
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
            ),
          ),
        ],
      ),
    );
  }
}
