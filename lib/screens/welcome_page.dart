import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/yowhatsapp_provider.dart';

import '../providers/bottom_nav.dart';
import '../providers/get_statuses_provider.dart';
import 'gbwhatsapp/gb_whatsapp.dart';
import 'privacypolicy/privacy_policy.dart';
import 'wa_business/wabusiness_home.dart';
import 'whatsapp/whatsapp_home.dart';
import 'widgets/drawer.dart';
import 'yowhatsapp/yowhatsapp_home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
    ).then(
      (value) {
        FlutterNativeSplash.remove();
      },
    );
    Provider.of<GetStatusProvider>(
      context,
      listen: false,
    ).initializer(ctx: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Consumer2<BottomNavProvider, GetStatusProvider>(
            builder: (context, value, value2, child) {
              return Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/1.png',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Center(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 5,
                                    shadowColor: Colors.green.withOpacity(1),
                                    borderRadius: BorderRadius.circular(10),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/[CITYPNG.COM]HD Wtsp Wa Whatsapp Logo Icon Sign Symbol Illustration PNG Image - 1600x1600.png',
                                        ),
                                      ),
                                      tileColor: Colors.white,
                                      title: const Text(
                                        'Whatsapp',
                                        style: TextStyle(
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onTap: () {
                                        value.formatIndex();
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const WhatsAppHomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 5,
                                    shadowColor: Colors.green.withOpacity(1),
                                    borderRadius: BorderRadius.circular(12),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                            'assets/images/whatsapp-business-logo.png'),
                                      ),
                                      tileColor: Colors.white,
                                      title: const Text(
                                        'Whatsapp Business',
                                        style: TextStyle(
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onTap: () {
                                        value.formatIndex();
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const WABusinessHomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 5,
                                    shadowColor: Colors.green.withOpacity(1),
                                    borderRadius: BorderRadius.circular(10),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/[CITYPNG.COM]HD Wtsp Wa Whatsapp Logo Icon Sign Symbol Illustration PNG Image - 1600x1600.png',
                                        ),
                                      ),
                                      tileColor: Colors.white,
                                      title: const Text(
                                        'YoWhatsapp',
                                        style: TextStyle(
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onTap: () {
                                        value.formatIndex();
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const YoWhatsAppHomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Material(
                                    elevation: 5,
                                    shadowColor: Colors.green.withOpacity(1),
                                    borderRadius: BorderRadius.circular(10),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/gb-image__2_-removebg-preview (1).png',
                                        ),
                                      ),
                                      tileColor: Colors.white,
                                      title: const Text(
                                        'GB Whatsapp',
                                        style: TextStyle(
                                          letterSpacing: .5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onTap: () {
                                        value.formatIndex();
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const GBWhatsappHomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                                vertical: 20,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircleAvatar(
                                        child: Icon(Icons.share),
                                      ),
                                      Text('Share')
                                    ],
                                  ),
                                  Column(
                                    children: const [
                                      CircleAvatar(
                                        child: Icon(Icons.star_rounded),
                                      ),
                                      Text(
                                        'Rate app',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const PrivacyPolicy(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: const [
                                        CircleAvatar(
                                          child: Icon(Icons.privacy_tip),
                                        ),
                                        Text(
                                          'Privacy \npolicy',
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: const [
                                      CircleAvatar(
                                        child: Icon(Icons.info),
                                      ),
                                      Text('About')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
