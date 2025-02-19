import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentification_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

import 'features/videos/views/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState);
  


  return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: InterestsScreen.routeName,
          path: InterestsScreen.routeURL,
          builder: (context, state) => const InterestsScreen(),
        ),
        GoRoute(
            path: "/:tab(home|discover|inbox|profile)",
            name: MainNavigationScreen.routeName,
            builder: (context, state) {
              final tab = state.params["tab"]!;
              return MainNavigationScreen(tab: tab);
            }),
        GoRoute(
          name: ActivityScreen.routeName,
          path: ActivityScreen.routeUrl,
          builder: (context, state) => const ActivityScreen(),
        ),
        GoRoute(
            name: ChatsScreen.routeName,
            path: ChatsScreen.routeURL,
            builder: (context, state) => const ChatsScreen(),
            routes: [
              GoRoute(
                  name: ChatDetailScreen.routeName,
                  path: ChatDetailScreen.routeURL,
                  builder: (context, state) {
                    final String chatId = state.params["chatId"]!;

                    return ChatDetailScreen(chatId: chatId);
                  })
            ]),
        GoRoute(
            name: VideoRecordingScreen.routeName,
            path: VideoRecordingScreen.routeURL,
            pageBuilder: (context, state) => CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 200),
                  child: const VideoRecordingScreen(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    final position =
                        Tween(begin: const Offset(0, 1), end: Offset.zero)
                            .animate(animation);
                    return SlideTransition(
                      position: position,
                      child: child,
                    );
                  },
                ))
      ]);
});



// final router = GoRouter(routes: [
//   GoRoute(
//       path: SignUpScreen.routeURL,
//       name: SignUpScreen.routeName,
//       builder: (context, state) => const SignUpScreen(),
//       routes: [
//         GoRoute(
//             path: UsernameScreen.routeURL,
//             name: UsernameScreen.routeName,
//             builder: (context, state) => const UsernameScreen(),
//             routes: [
//               GoRoute(
//                   path: EmailScreen.routeURL,
//                   name: EmailScreen.routeName,
//                   builder: (context, state) {
//                     final args = state.extra as EmailScreenArgs;
//                     return EmailScreen(username: args.username);
//                   }),
//             ]),
//       ]),
//   // GoRoute(
//   //   path: LoginScreen.routeName,
//   //   builder: (context, state) => const LoginScreen(),
//   // ),
//   // GoRoute(
//   //   name: "username_screen",
//   //   path: UsernameScreen.routeName,

//   // pageBuilder: (context, state) {
//   //   return CustomTransitionPage(
//   //     child: const UsernameScreen(),
//   //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//   //       return ScaleTransition(
//   //         scale: animation,
//   //         child: FadeTransition(
//   //           opacity: animation,
//   //           child: child,
//   //         ),
//   //       );
//   //     },
//   //   );
//   // },
//   // ),

//   GoRoute(
//     path: "/users/:username",
//     builder: (context, state) {
//       final username = state.params['username'];
//       final tab = state.queryParams["show"];
//       return UserProfileScreen(username: username!, tab: tab!);
//     },
//   )
// ]);
