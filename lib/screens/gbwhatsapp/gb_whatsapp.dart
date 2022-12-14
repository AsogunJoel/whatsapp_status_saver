import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/bottom_nav.dart';
import 'package:whatsapp_status_saver/providers/gb_provider.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/screens/gbwhatsapp/widgets/image/image.dart';
import 'package:whatsapp_status_saver/screens/gbwhatsapp/widgets/videos/videos.dart';

class GBWhatsappHomePage extends StatefulWidget {
  const GBWhatsappHomePage({super.key});

  @override
  State<GBWhatsappHomePage> createState() => _GBWhatsappHomePage();
}

class _GBWhatsappHomePage extends State<GBWhatsappHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<GBStatusProvider>(
      context,
      listen: false,
    ).initializerGB(ctx: context);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   Provider.of<GBStatusProvider>(
  //     context,
  //     listen: false,
  //   ).clearSafs();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BottomNavProvider, GBStatusProvider>(
      builder: (context, navProvider, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('GB Whatsapp'),
          centerTitle: true,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: navProvider.controller,
          children: const [
            GBWhatsappImagePage(),
            GBWhatsappVideoPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            navProvider.changewaGBPageIndex(value);
          },
          currentIndex: navProvider.gBCurrentIndex,
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
