import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/app_styles.dart';

class AvatarPicker extends StatelessWidget {
  final XFile? avatar;
  final Function() onPickAvatar;
  final double radius;

  const AvatarPicker({
    Key? key,
    required this.avatar,
    required this.onPickAvatar,
    this.radius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickAvatar,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppStyles.verticalSpacing),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor:
                  avatar == null
                      ? AppStyles.secondaryColor.withOpacity(0.1)
                      : null,
              backgroundImage:
                  avatar != null ? FileImage(File(avatar!.path)) : null,
              child:
                  avatar == null
                      ? Icon(
                        Icons.person,
                        size: radius * 1.2,
                        color: AppStyles.secondaryColor.withOpacity(0.5),
                      )
                      : null,
            ),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppStyles.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppStyles.backgroundColor, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                size: radius * 0.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
