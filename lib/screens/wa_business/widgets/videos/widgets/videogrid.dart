import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../directory_response/check_directory_response.dart';
import '../../../../../providers/business_provider.dart';
import '../../../../widgets/videos/single_video.dart';
import '../../../../widgets/videos/video_view.dart';

class BusinessVideoGrid extends StatefulWidget {
  const BusinessVideoGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<BusinessVideoGrid> createState() => _BusinessVideoGridState();
}

class _BusinessVideoGridState extends State<BusinessVideoGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<BusinessStatusProvider>(
      builder: (context, file, child) {
        if (file.itemsData.status == Status.COMPLETED &&
            file.businessgetVideos.isNotEmpty) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 2.5 / 3,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: file.businessgetVideos.length,
            itemBuilder: (context, index) {
              String pathhh = file.businessgetVideos[index].status.path;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => VideoView(
                          videoPath: file.businessgetVideos[index].status.path),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Please wait...',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          );
        } else if (file.businessgetVideos.isEmpty) {
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
