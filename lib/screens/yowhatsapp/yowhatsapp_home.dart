import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/bottom_nav.dart';
import 'package:whatsapp_status_saver/providers/yowhatsapp_provider.dart';
import 'package:whatsapp_status_saver/screens/yowhatsapp/widgets/image/image.dart';
import 'package:whatsapp_status_saver/screens/yowhatsapp/widgets/videos/videos.dart';

class YoWhatsAppHomePage extends StatefulWidget {
  const YoWhatsAppHomePage({super.key});

  @override
  State<YoWhatsAppHomePage> createState() => _YoWhatsAppState();
}

class _YoWhatsAppState extends State<YoWhatsAppHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<GetYoStatusProvider>(
      context,
      listen: false,
    ).initializerYowhatsapp(ctx: context);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   Provider.of<GetYoStatusProvider>(
  //     context,
  //     listen: false,
  //   ).clearData();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BottomNavProvider, GetYoStatusProvider>(
      builder: (context, navProvider, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('YoWhatsapp'),
          centerTitle: true,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: navProvider.controller,
          children: const [
            YoWhatsappImagePage(),
            YoWhatsappVideoPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            navProvider.changePageIndex(value);
          },
          currentIndex: navProvider.currentIndex,
          enableFeedback: true,
          showUnselectedLabels: false,
          iconSize: 30,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              label: 'Pictures',
              activeIcon: Icon(Icons.photo_library),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_file_rounded),
              label: 'Videos',
              activeIcon: Icon(
                Icons.video_file_rounded,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            value.refreshpaths(context);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
