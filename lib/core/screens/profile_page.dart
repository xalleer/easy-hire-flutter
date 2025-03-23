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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Карта профілю
              Container(
                width: double.infinity, // Робимо картку на всю ширину
                child: Card(
                  elevation: 5, // Висота тіні
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Округлені кути
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Центрування по вертикалі
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .center, // Центрування по горизонталі
                      children: [
                        CircleAvatar(
                          radius: 40, // Розмір аватара
                          backgroundImage: NetworkImage(
                            avatarUrl ??
                                'https://www.example.com/avatar.png', // Підтягуємо URL для аватара
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          name ??
                              "Ім'я користувача", // Підтягуємо ім'я користувача
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          email ??
                              "example@mail.com", // Адреса електронної пошти
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          phone ?? "+380123456789", // Номер телефону
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),

                        // Рейтинг з зірками
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            if (index < rating!) {
                              return Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 20,
                              );
                            } else if (index < rating! + 0.5) {
                              return Icon(
                                Icons.star_half,
                                color: Colors.yellow[700],
                                size: 20,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: Colors.yellow[700],
                                size: 20,
                              );
                            }
                          }),
                        ),
                        Text(
                          "$rating / 5.0", // Рейтинг
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Кнопка "Вийти"
              Spacer(),
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
    );
  }
}
