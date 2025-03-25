import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../constants/app_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/location_input.dart';
import '../widgets/chip_input.dart';
import '../widgets/section_header.dart';
import '../widgets/chip_display.dart';
import '../services/auth_api.dart';
import '../models/user.dart';

class SignUpNextPage extends StatefulWidget {
  @override
  _SignUpNextPageState createState() => _SignUpNextPageState();
}

class _SignUpNextPageState extends State<SignUpNextPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController workLocationsController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();
  XFile? _avatar;
  final ImagePicker _picker = ImagePicker();
  List<String> selectedWorkLocations = [];
  List<String> selectedSkills = [];
  bool _showWorkLocationInput = false;
  bool _showSkillsInput = false;
  bool _isFetchingLocation = false;
  bool _isRegistering = false;

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 500,
    );
    if (pickedFile != null) {
      setState(() => _avatar = pickedFile);
    }
  }

  Future<List<String>> _getCitySuggestions(String query) async {
    if (query.length < 2) return [];

    try {
      List<Location> locations = await locationFromAddress(query);
      List<String> cities = [];
      for (var loc in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        for (var place in placemarks) {
          if (place.locality != null && !cities.contains(place.locality)) {
            cities.add(place.locality!);
          }
        }
      }
      return cities;
    } catch (e) {
      return [];
    }
  }

  Future<void> _determineCurrentLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar("Дозвіл на місцезнаходження відхилено", isError: true);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && placemarks.first.locality != null) {
        setState(() {
          if (!selectedWorkLocations.contains(placemarks.first.locality!)) {
            selectedWorkLocations.add(placemarks.first.locality!);
            _showSnackBar("Локацію додано: ${placemarks.first.locality!}");
          } else {
            _showSnackBar("Ця локація вже додана", isWarning: true);
          }
        });
      } else {
        _showSnackBar("Не вдалося визначити місто", isError: true);
      }
    } catch (e) {
      _showSnackBar("Помилка: $e", isError: true);
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  void _addWorkLocation() {
    if (workLocationsController.text.isNotEmpty) {
      setState(() {
        if (!selectedWorkLocations.contains(workLocationsController.text)) {
          selectedWorkLocations.add(workLocationsController.text);
          _showSnackBar("Локацію додано: ${workLocationsController.text}");
        } else {
          _showSnackBar("Ця локація вже додана", isWarning: true);
        }
        workLocationsController.clear();
      });
    }
  }

  void _addSkill() {
    if (skillsController.text.isNotEmpty) {
      setState(() {
        if (!selectedSkills.contains(skillsController.text)) {
          selectedSkills.add(skillsController.text);
          _showSnackBar("Навички додано: ${skillsController.text}");
        } else {
          _showSnackBar("Ця навичка вже додана", isWarning: true);
        }
        skillsController.clear();
      });
    }
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
    bool isWarning = false,
  }) {
    Color backgroundColor = AppStyles.primaryColor;
    if (isError) backgroundColor = AppStyles.errorColor;
    if (isWarning) backgroundColor = Colors.orange;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  Future<void> _signUpUser() async {
    if (selectedWorkLocations.isEmpty) {
      _showSnackBar(
        "Будь ласка, додайте хоча б одне місце роботи",
        isWarning: true,
      );
      return;
    }

    setState(() => _isRegistering = true);

    try {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;

      final response = await authApi.signUpUser(
        name: nameController.text,
        email: args?['email'] ?? "test2@test.com",
        phone: args?['phone'] ?? "1234567890",
        password: args?['password'] ?? "yourpassword",
        workLocations: selectedWorkLocations,
        skills: selectedSkills,
      );

      if (response != null) {
        User user = User.fromJson(response['user']);
        _showSnackBar("✅ Успішна реєстрація: ${user.name}");

        // Navigate to the next page or home page
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed('/home');
        });
      } else {
        _showSnackBar("❌ Не вдалося зареєструватися", isError: true);
      }
    } catch (e) {
      _showSnackBar("Помилка: $e", isError: true);
    } finally {
      setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Додаткова інформація", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: AppStyles.formPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AvatarPicker(
                    avatar: _avatar,
                    onPickAvatar: _pickAvatar,
                  ),
                ),

                SizedBox(height: AppStyles.verticalSpacing),

                Text(
                  "Персональна інформація",
                  style: AppStyles.headingStyle.copyWith(fontSize: 18),
                ),

                SizedBox(height: AppStyles.verticalSpacing),

                CustomTextField(
                  hintText: "Повне ім'я",
                  controller: nameController,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppStyles.secondaryColor,
                  ),
                ),

                SizedBox(height: AppStyles.verticalSpacing),

                // Work locations
                SectionHeader(
                  title: "Місця роботи",
                  onAdd:
                      _showWorkLocationInput
                          ? null
                          : () => setState(() => _showWorkLocationInput = true),
                ),

                if (selectedWorkLocations.isNotEmpty)
                  ChipDisplay(
                    items: selectedWorkLocations,
                    onDelete: (location) {
                      setState(() {
                        selectedWorkLocations.remove(location);
                      });
                    },
                  ),

                if (_showWorkLocationInput)
                  LocationInput(
                    controller: workLocationsController,
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        if (!selectedWorkLocations.contains(suggestion)) {
                          selectedWorkLocations.add(suggestion);
                          _showSnackBar("Локацію додано: $suggestion");
                        } else {
                          _showSnackBar(
                            "Ця локація вже додана",
                            isWarning: true,
                          );
                        }
                        workLocationsController.clear();
                      });
                    },
                    suggestionsCallback: _getCitySuggestions,
                    onCancel:
                        () => setState(() => _showWorkLocationInput = false),
                    onAdd: _addWorkLocation,
                    onAutoDetect: _determineCurrentLocation,
                    isDetecting: _isFetchingLocation,
                  ),

                SizedBox(height: AppStyles.verticalSpacing),

                // Skills
                SectionHeader(
                  title: "Навички",
                  onAdd:
                      _showSkillsInput
                          ? null
                          : () => setState(() => _showSkillsInput = true),
                ),

                if (selectedSkills.isNotEmpty)
                  ChipDisplay(
                    items: selectedSkills,
                    onDelete: (skill) {
                      setState(() {
                        selectedSkills.remove(skill);
                      });
                    },
                  ),

                if (_showSkillsInput)
                  ChipInput(
                    controller: skillsController,
                    onCancel: () => setState(() => _showSkillsInput = false),
                    onAdd: _addSkill,
                    selectedItems: selectedSkills,
                    onDelete: (skill) {
                      setState(() {
                        selectedSkills.remove(skill);
                      });
                    },
                    labelText: "Введіть навичку",
                    icon: Icons.psychology,
                  ),

                SizedBox(height: AppStyles.verticalSpacing * 2),

                CustomButton(
                  text: "Зареєструватися",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signUpUser();
                    }
                  },
                  isLoading: _isRegistering,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
