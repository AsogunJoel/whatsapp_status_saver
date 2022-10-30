import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/directory_response/check_directory_response.dart';
import 'package:whatsapp_status_saver/providers/yowhatsapp_provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/videos/single_video.dart';
import 'package:whatsapp_status_saver/screens/widgets/videos/video_view.dart';

class YoVideoGrid extends StatefulWidget {
  const YoVideoGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<YoVideoGrid> createState() => _YoVideoGridState();
}

class _YoVideoGridState extends State<YoVideoGrid>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<GetYoStatusProvider>(
      builder: (context, file, child) {
        if (file.itemsData.status == Status.COMPLETED &&
            file.yogetVideos.isNotEmpty) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 2.5 / 4,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: file.yogetVideos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoView(
                        videoPath: file.yogetVideos[index].status.path,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleVideo(file: file.yogetVideos[index].status.path),
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
              semanticsLabel: file.itemsData.message,
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
                    semanticsLabel: 'Please wait...',
                  ),
                )
              ],
            ),
          );
        } else if (file.yogetVideos.isEmpty) {
          return const Center(
            child: Text(
              'No recently viewed videos',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: .5,
                fontSize: 15,
              ),
              semanticsLabel: 'No recently viewed videos',
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
