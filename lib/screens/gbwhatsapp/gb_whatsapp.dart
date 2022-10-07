import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/bottom_nav.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/screens/widgets/image/image.dart';
import 'package:whatsapp_status_saver/screens/widgets/videos/videos.dart';

class GBWhatsappHomePage extends StatefulWidget {
  const GBWhatsappHomePage({super.key});

  @override
  State<GBWhatsappHomePage> createState() => _GBWhatsappHomePage();
}

class _GBWhatsappHomePage extends State<GBWhatsappHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<GetStatusProvider>(
      context,
      listen: false,
    ).initializerWABusiness(ctx: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BottomNavProvider, GetStatusProvider>(
      builder: (context, navProvider, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('GB Whatsapp Status Saver'),
          centerTitle: true,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: navProvider.controller,
          children: const [
            WhatsappImagePage(),
            WhatsappVideoPage(),
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
            value.getGBWhatsappStatus(ctx: context);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
