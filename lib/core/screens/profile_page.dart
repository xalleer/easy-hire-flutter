import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_styles.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone;
  String? avatarUrl;
  double? rating;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('userInfo');
    print("userInfoJson: $userInfoJson");

    if (userInfoJson != null) {
      Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
      print("Parsed userInfo: $userInfo");

      setState(() {
        name = userInfo['name'] as String?;
        email = userInfo['email'] as String? ?? 'example@mail.com';
        phone = userInfo['phone'] as String? ?? '+380123456789';
        avatarUrl =
            userInfo['avatarUrl'] as String? ??
            'https://cactusthemes.com/blog/wp-content/uploads/2018/01/tt_avatar_small.jpg';
        rating = (userInfo['rating'] as num?)?.toDouble() ?? 4.9;
        print("Loaded: name=$name, email=$email, phone=$phone, rating=$rating");
      });
    } else {
      setState(() {
        name = null;
        email = 'example@mail.com';
        phone = '+380123456789';
        avatarUrl = 'https://www.example.com/avatar.png';
        rating = 4.9;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("❌ Помилка при виході: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профіль", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey[700]),
            onPressed: () {
              // Перехід до налаштувань (поки порожня дія)
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Карта профілю
                Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              avatarUrl ?? 'https://www.example.com/avatar.png',
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            name ?? "Ім'я користувача",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            email ?? "example@mail.com",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            phone ?? "+380123456789",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 15),
                          // Категорії роботи
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Категорії роботи",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment.center,
                            children: [
                              Chip(
                                label: Text("Фізична праця"),
                                backgroundColor: Colors.blue[100],
                                labelStyle: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              Chip(
                                label: Text("Водіння"),
                                backgroundColor: Colors.blue[100],
                                labelStyle: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              Chip(
                                label: Text("Будівництво"),
                                backgroundColor: Colors.blue[100],
                                labelStyle: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          // Міста/села
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Міста/села",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment.center,
                            children: [
                              Chip(
                                label: Text("Київ"),
                                backgroundColor: Colors.green[100],
                                labelStyle: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              Chip(
                                label: Text("Сушки"),
                                backgroundColor: Colors.green[100],
                                labelStyle: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          // Кнопка редагування
                          OutlinedButton.icon(
                            onPressed: () {
                              // Перехід до редагування профілю (поки порожня дія)
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.blue[700],
                            ),
                            label: Text(
                              "Редагувати",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.blue[700]!,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Рейтинг і відгуки
                Text(
                  "Рейтинг та відгуки",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            if (index < rating!) {
                              return Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 24,
                              );
                            } else if (index < rating! + 0.5) {
                              return Icon(
                                Icons.star_half,
                                color: Colors.yellow[700],
                                size: 24,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: Colors.yellow[700],
                                size: 24,
                              );
                            }
                          }),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            "$rating / 5.0",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Відгуки",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Чудовий виконавець!",
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            "Олена, 25.03.2025",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Швидко і якісно",
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            "Петро, 24.03.2025",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Кнопка "Вийти"
                CustomButton(
                  text: "Вийти",
                  onPressed: () {
                    logout(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
