import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'providers/adstate.dart';
import 'providers/bottom_nav.dart';
import 'providers/business_provider.dart';
import 'providers/gb_provider.dart';
import 'providers/get_statuses_provider.dart';
import 'providers/yowhatsapp_provider.dart';
import 'screens/welcome_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  await dotenv.load(fileName: ".env");
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['6C0441EB3643C8D9B5F7C8E04C01A6F7'],
    ),
  );
  runApp(
    Provider.value(
      value: adState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetYoStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GBStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BusinessStatusProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const WelcomePage(),
      ),
    );
  }
}
