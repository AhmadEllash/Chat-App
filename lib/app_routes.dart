import 'package:chat_app/business_logic/cubit/auth/auth_cubit.dart';
import 'package:chat_app/business_logic/cubit/user/user_cubit.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/data/api/auth_api.dart';
import 'package:chat_app/data/api/user_api.dart';
import 'package:chat_app/data/respositroy/auth_repository.dart';
import 'package:chat_app/data/respositroy/user_repository.dart';
import 'package:chat_app/ui/screens/chat_screen.dart';
import 'package:chat_app/ui/screens/home_screen.dart';
import 'package:chat_app/ui/screens/search_screen.dart';
import 'package:chat_app/ui/screens/sign_in_screen.dart';
import 'package:chat_app/ui/screens/sign_up_screen.dart';
import 'package:chat_app/ui/screens/splash_screen.dart';
import 'package:chat_app/ui/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  late AuthRepository authRepository;
  late AuthCubit authCubit;
  late UserRepository _userRepository;
  late UserCubit _userCubit;
  AppRoutes() {
    authRepository = AuthRepository(AuthApi());
    authCubit = AuthCubit(authRepository);
    _userRepository = UserRepository(UserApi());
    _userCubit = UserCubit(_userRepository);
  }
  Route? generateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: const SplashScreen(),
          );
        });
      case homeScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: BlocProvider(
              create: (context) => _userCubit,
              child: HomeScreen(),
            ),
          );
        });
      case searchScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: BlocProvider(
              create: (context) => _userCubit,
              child: SearchScreen(),
            ),
          );
        });
      case signInScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: BlocProvider(
              create: (context) => authCubit,
              child: const SignInScreen(),
            ),
          );
        });

      case signUpScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: BlocProvider(
              create: (context) => authCubit,
              child: const SignUpScreen(),
            ),
          );
        });
      case verificationScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: BlocProvider(
              create: (context) => authCubit,
              child: VerificationScreen(),
            ),
          );
        });
      case chatScreen:
        return PageRouteBuilder(pageBuilder: (context, animation, _) {
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: BlocProvider(
              create: (context) => _userCubit,
              child: const ChatScreen(),
            ),
          );
        });
    }
  }
}
