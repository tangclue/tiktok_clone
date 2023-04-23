import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/screen_config/dark_config.dart';
import 'package:tiktok_clone/features/authentication/repos/authentification_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Localizations.override(
      context: context,
      locale: const Locale("ko"),
      child: Scaffold(
          appBar: AppBar(title: const Text("Settings")),
          body: ListView(children: [
            AnimatedBuilder(
              animation: darkConfig,
              builder: (context, child) => SwitchListTile.adaptive(
                activeColor: Colors.green,
                value: darkConfig.value,
                onChanged: (value) {
                  darkConfig.value = !darkConfig.value;
                },
                title: const Text("Dark mode."),
                subtitle: const Text("Screens are shown in drak mode"),
              ),
            ),
            SwitchListTile.adaptive(
              activeColor: Colors.green,
              value: ref.watch(playbackConfigProvider).muted,
              onChanged: (value) =>
                  {ref.read(playbackConfigProvider.notifier).setMuted(value)},
              // context.read<PlaybackConfigViewModel>().setMuted(value),
              title: const Text("Mute Video"),
              subtitle: const Text("Videos muted by default"),
            ),
            SwitchListTile.adaptive(
              activeColor: Colors.green,
              value: ref.watch(playbackConfigProvider).autoplay,
              onChanged: (value) => {
                ref.read(playbackConfigProvider.notifier).setAutoplay(value)
              },
              // context.read<PlaybackConfigViewModel>().setAutoplay(value),
              title: const Text("Auto Play"),
              subtitle: const Text("Video will start playing automatically"),
            ),
            SwitchListTile.adaptive(
              activeColor: Colors.green,
              value: false,
              onChanged: (value) => {},
              title: const Text("Enable notifications"),
              subtitle: const Text("You can Change it"),
            ),
            CheckboxListTile(
              activeColor: Colors.black,
              value: false,
              onChanged: (value) => {},
              title: const Text("Enable notifications"),
            ),
            ListTile(
              onTap: () async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1980),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2030));

                if (kDebugMode) {
                  print(date);
                }
                // ignore: use_build_context_synchronously
                final time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());

                print(time);
                // ignore: use_build_context_synchronously
                final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                        data: ThemeData(
                            appBarTheme: const AppBarTheme(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black)),
                        child: child!);
                  },
                );
                print(booking);
              },
              title: const Text(
                "What is your birthday?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ListTile(
              title: const Text("Log out (iOS)"),
              textColor: Colors.red,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("You can come back any time."),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "No",
                        ),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          context.go("/");
                        },
                        isDestructiveAction: true,
                        child: const Text(
                          "Yes",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Log out (Android)"),
              textColor: Colors.red,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const FaIcon(FontAwesomeIcons.skull),
                    title: const Text("Are you sure?"),
                    content: const Text("You can come back any time."),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const FaIcon(FontAwesomeIcons.car),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Yes",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Log out (iOS/Bottom)"),
              textColor: Colors.red,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    message: const Text("You can come back anytime."),
                    title: const Text("Are you sure?"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Not Log out"),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(context).pop(),
                        isDestructiveAction: true,
                        child: const Text("Yes, pleasse"),
                      )
                    ],
                  ),
                );
              },
            ),
            const AboutListTile()
          ])),
    );
  }
}
