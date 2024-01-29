import 'package:flutter/material.dart';
import 'package:student_app/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Gradient? gradient;
  final String? title;
  final VoidCallback? onTap;

  const CustomButton({super.key, this.gradient, this.onTap, this.title});

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
                // LinearGradient(
                //         begin: Alignment.topLeft,
                //         end: Alignment.centerRight,
                //         // begin: FractionalOffset(0.0, 0.0),
                //         // end: FractionalOffset(1.0, 0.0),
                //         colors: [
                //           Color(0xFF79e6c9),
                //           Color(0xFF79e6c9),
                //           Color(0xFF79e6c9),
                //           // Color(0xFF38b8cd),
                //           Color(0xFF38b8cd),
                //           Color(0xFF38b8cd),
                //         ],
                //         stops: [-1.0, -0.1, 0.0, 1.0, 1.1],
                //       )

                // begin: Alignment.topLeft,
                // end: Alignment.centerRight,
                // colors: [
                //     AppColors.primary,
                //     AppColors.secondary,
                //     AppColors.secondary,
                //   ])
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
    );
  }
}
