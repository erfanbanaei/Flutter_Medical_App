  import 'package:flutter/material.dart';
import 'package:medicalapp/src/core/%20theme/app_colors.dart';

Widget doctorsWidgets({
    required Color color,
    required Color colorShadow,
    required String imageName,
    required String doctorName,
    required String doctorPosition,
    required String rateNumber,
    required Function() ontap,
    required BuildContext context
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 94,
        width: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.05),
              offset: Offset(0, 4),
              blurRadius: 25,
            ),
          ],
        ),
        child: Row(
          spacing: 16,
          children: [
            Container(
              height: 94,
              width: 97,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: colorShadow, blurRadius: 20),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: 77,
                      height: 82,
                      child: Image.asset("assets/images/$imageName.png"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    spacing: 8,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMainColor,
                        ),
                      ),
                      Text(
                        doctorPosition,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textMainColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.yellowColor,
                      ),
                      Text(
                        rateNumber,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMainColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }