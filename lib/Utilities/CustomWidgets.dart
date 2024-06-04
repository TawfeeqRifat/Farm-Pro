import 'package:flutter/material.dart';
double HorizontalPadSize = 15;
double VerticalPadSize = 35;
class VerticalPadding extends StatelessWidget {
  const VerticalPadding({super.key, required this.paddingSize});
  final double paddingSize;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: paddingSize));
  }
}

class HorizontalPadding extends StatelessWidget {
  const HorizontalPadding({super.key, required this.paddingSize});
  final double paddingSize;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: paddingSize));
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
       VerticalPadding(paddingSize: 40),
        Container(
          width: 335,
          height: 4,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: Colors.white,
        ),
      ),
       VerticalPadding(paddingSize: 40),
        ],
      ),
    );


  }
}

