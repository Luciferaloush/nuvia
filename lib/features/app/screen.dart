import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_provider.dart';
import '../home/screen.dart';
import '../users/screen.dart';
import 'cubit/app_cubit.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, int>(
        builder: (context, state) {
          return IndexedStack(
            index: state,
            children: const [
              HomeProvider(),
              UsersScreen(),
              Text("akka"),

              Text("akka"),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<AppCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state,
            onTap: (index) => context.read<AppCubit>().updateIndex(index), // تأكد من استدعاء AppCubit هنا
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: 'Find user',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail_outline),
                activeIcon: Icon(Icons.mail),
                label: 'Messages',
              ),
            ],
          );
        },
      ),
    );
  }
}