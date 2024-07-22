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
  const CustomDivider({super.key,this.color,this.thickness,this.borderRadius});
  final Color? color;
  final double? thickness;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          height: thickness ?? 3,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??35),
          color: color ?? Colors.black,
        ),
      ),
        ],
      ),
    );


  }
}

