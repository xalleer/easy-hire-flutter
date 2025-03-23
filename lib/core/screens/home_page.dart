import 'package:easy_hire/core/screens/profile_page.dart';
import 'package:flutter/material.dart';
import '../constants/app_styles.dart';
import '../screens/profile_page.dart' as profile;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Індекс вибраної вкладки

  // Список віджетів для кожної вкладки (не константний)
  final List<Widget> _widgetOptions = <Widget>[
    profile.ProfilePage(), // Профіль
    Center(child: Text('Завдання')), // Завдання
    Center(child: Text('Налаштування')), // Налаштування
    Center(child: Text('Баланс')), // Баланс
  ];

  // Функція для зміни вкладки
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(
          _selectedIndex,
        ), // Показує вкладку на основі індексу
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Профіль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Завдання',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Налаштування',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Баланс',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppStyles.primaryColor, // Колір вибраної іконки
        unselectedItemColor: Colors.grey, // Колір невибраних іконок
        onTap: _onItemTapped, // Обробка вибору вкладки
      ),
    );
  }
}
