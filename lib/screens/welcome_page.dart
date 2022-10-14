import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/providers/bottom_nav.dart';
import 'package:whatsapp_status_saver/providers/get_statuses_provider.dart';
import 'package:whatsapp_status_saver/screens/gbwhatsapp/gb_whatsapp.dart';
import 'package:whatsapp_status_saver/screens/wa_business/wabusiness_home.dart';
import 'package:whatsapp_status_saver/screens/whatsapp/whatsapp_home.dart';
import 'package:whatsapp_status_saver/screens/widgets/drawer.dart';
import 'package:whatsapp_status_saver/screens/yowhatsapp/yowhatsapp_home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<GetStatusProvider>(
      context,
      listen: false,
    ).initializer(ctx: context);
    Future.delayed(
      const Duration(seconds: 2),
    ).then(
      (value) {
        FlutterNativeSplash.remove();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Consumer2<BottomNavProvider, GetStatusProvider>(
        builder: (context, value, value2, child) {
          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/logo1.png',
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          'WhatsApp',
                          style: TextStyle(
                            letterSpacing: .5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          value2.clearData();
                          value.formatIndex();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const WhatsAppHomePage(),
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
                          'YoWhatsApp',
                          style: TextStyle(
                            letterSpacing: .5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          value2.clearData();
                          value.formatIndex();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const YoWhatsAppHomePage(),
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
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                              'assets/images/whatsapp-business-logo.png'),
                        ),
                        tileColor: Colors.white,
                        title: const Text(
                          'WA Business',
                          style: TextStyle(
                            letterSpacing: .5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          value2.clearData();
                          value.formatIndex();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const WABusinessHomePage(),
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
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/whatsapp-business-logo.png',
                          ),
                        ),
                        tileColor: Colors.white,
                        title: const Text(
                          'GB WhatsApp',
                          style: TextStyle(
                            letterSpacing: .5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          value2.clearData();
                          value.formatIndex();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const GBWhatsappHomePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
