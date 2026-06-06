import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
 class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            //Top header
            Container(
              width: double.infinity,
              color: AppColors.navyBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Logo
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: 'ALU',
                          style: TextStyle(color: AppColors.white),
                        ),
                        TextSpan(
                          text: 'Connect',
                          style: TextStyle(color: AppColors.red),
                        ),
                      ],
                    ),
                  ),

                  //Notification Icon
                  const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.white,
                    size: 24,
                  ),
                ],
              ),
            ),

            //Body (Will be replaced by real feed)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.red,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navyBlue,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Feed coming soon.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),

      //Bottom navigation (Will be completed later in task 4)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.red,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedFontSize: 10,
        currentIndex: 0,
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group_rounded),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today_rounded),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
 }
