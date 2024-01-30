import 'package:flutter/material.dart';
import 'package:student_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Gradient? gradient;
  final String? title;
  final VoidCallback? onTap;
  final bool isImage;
  final String? image;
  final EdgeInsets? padding;

  const CustomButton(
      {super.key,
      this.gradient,
      this.onTap,
      this.title,
      this.isImage = false,
      this.image,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: gradient == null
                ? RadialGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.secondary,
                    ],
                    radius: 10,
                    focal: Alignment(-1.1, -3.0),
                  )
                : gradient),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isImage == true
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          image!,
                          color: AppColors.white,
                          height: 14,
                          width: 16,
                        ),
                      ),
                    )
                  : SizedBox(),
              // SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.33,
              //   ),
              Text('$title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
