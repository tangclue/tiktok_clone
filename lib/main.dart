import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/screen_config/dark_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  final preferences = await SharedPreferences.getInstance();
  final repository = PlaybackConfigRepository(preferences);

  runApp(ProviderScope(overrides: [
    playbackConfigProvider
        .overrideWith(() => PlaybackConfigViewModel(repository))
  ], child: const TiktokApp()));
}

class TiktokApp extends ConsumerWidget {
  const TiktokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    S.load(const Locale("en"));
    return AnimatedBuilder(
      animation: darkConfig,
      builder: (context, child) => MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        debugShowCheckedModeBanner: false,
        title: 'Tiktok Clone',
        localizationsDelegates: const [
          S.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        themeMode: darkConfig.value ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
            listTileTheme: const ListTileThemeData(iconColor: Colors.black),
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade50),
            brightness: Brightness.light,
            textTheme: Typography.blackMountainView,
            splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.w600,
              ),
            ),
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xFFE9435A),
            tabBarTheme: TabBarTheme(
              unselectedLabelColor: Colors.grey.shade500,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
            ),
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: Color(0xFFE9435A))),
        darkTheme: ThemeData(
            tabBarTheme: TabBarTheme(
              unselectedLabelColor: Colors.grey.shade500,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
            ),
            indicatorColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            textTheme: Typography.whiteMountainView,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            primaryColor: const Color(0xFFE9435A),
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: Color(0xFFE9435A)),
            bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black)),

        // home: const SignUpScreen(),
      ),
    );
  }
}
