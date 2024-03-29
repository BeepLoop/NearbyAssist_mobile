import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/screens/add_service.dart';
import 'package:nearby_assist/screens/chat.dart';
import 'package:nearby_assist/screens/complaints.dart';
import 'package:nearby_assist/screens/history.dart';
import 'package:nearby_assist/screens/home.dart';
import 'package:nearby_assist/screens/in_progress.dart';
import 'package:nearby_assist/screens/login.dart';
import 'package:nearby_assist/screens/conversations.dart';
import 'package:nearby_assist/screens/map_page.dart';
import 'package:nearby_assist/screens/my_services.dart';
import 'package:nearby_assist/screens/new_message.dart';
import 'package:nearby_assist/screens/settings.dart';
import 'package:nearby_assist/screens/vendor.dart';

class AppRouter {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) {
          return const Homapage();
        },
        routes: [
          GoRoute(
            path: 'map',
            name: 'map',
            builder: (context, state) {
              return const MapPage();
            },
            routes: [
              GoRoute(
                  path: ':vendor',
                  name: 'vendor',
                  builder: (context, state) {
                    final serviceId = state.pathParameters['vendor']!;
                    return Vendor(serviceId: serviceId);
                  }),
            ],
          ),
        ],
      ),
      GoRoute(
          path: '/messages',
          name: 'messages',
          builder: (context, state) {
            return const Conversations();
          },
          routes: [
            GoRoute(
                path: 'new-message',
                name: 'new-message',
                builder: (context, state) {
                  return const NewMessage();
                }),
            GoRoute(
                path: ':userId',
                name: 'chat',
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  final vendorName = state.uri.queryParameters['vendorName']!;

                  return Chat(userId: int.parse(userId), name: vendorName);
                }),
          ]),
      GoRoute(
          path: '/in-progress',
          name: 'in-progress',
          builder: (context, state) {
            return const InProgress();
          }),
      GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) {
            return const History();
          }),
      GoRoute(
          path: '/complaints',
          name: 'complaints',
          builder: (context, state) {
            return const Complaints();
          }),
      GoRoute(
          path: '/my-services',
          name: 'my-services',
          builder: (context, state) {
            return const MyServices();
          },
          routes: [
            GoRoute(
                path: 'add-service',
                name: 'add-service',
                builder: (context, state) {
                  return const AddService();
                }),
          ]),
      GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) {
            return const Settings();
          }),
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginPage();
          }),
    ],
    redirect: (context, state) {
      final loginStatus = getIt.get<AuthModel>().getLoginStatus();
      final token = getIt.get<AuthModel>().getAccessToken();

      if (loginStatus == AuthStatus.unauthenticated || token == null) {
        return '/login';
      }

      if (token.isExpired) {
        return '/login';
      }

      return null;
    },
    refreshListenable: getIt.get<AuthModel>(),
    initialLocation: '/',
  );
}
