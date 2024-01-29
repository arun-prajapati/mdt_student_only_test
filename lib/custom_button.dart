import 'package:flutter/material.dart';
import 'package:student_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Gradient? gradient;
  final String? title;
  final VoidCallback? onTap;

  const CustomButton({super.key, this.gradient, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                onTap;
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: gradient == null
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                                AppColors.primary,
                                AppColors.secondary,
                                AppColors.secondary,
                              ])
                        : gradient),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text('$title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
