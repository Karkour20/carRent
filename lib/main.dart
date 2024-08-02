import 'package:carlink/screen/gerneral_support/Applanguage_screen.dart';
import 'package:carlink/utils/Dark_lightmode.dart';
import 'package:carlink/helpar/get_di.dart' as di;
import 'package:carlink/screen/login_flow/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Localmodal_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    );
  
  // Initialize GetStorage
  await GetStorage.init();
  await di.init();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences _prefs;

  const MyApp({super.key, required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorNotifire(), // Replace with your actual provider
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleModel(_prefs), // Replace with your actual provider
        ),
      ],
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: LocalString(), // Replace with your actual localization class
            locale: localeModel.locale,
            theme: ThemeData(
              useMaterial3: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              dividerColor: Colors.transparent,
              fontFamily: "urbani_regular",
              primaryColor: const Color(0xff1347FF),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color(0xff194BFB),
              ),
            ),
            home: const SplashScreen(), // Replace with your actual home screen widget
          );
        },
      ),
    );
  }
}
