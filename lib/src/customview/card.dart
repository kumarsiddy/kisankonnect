import 'package:flutter/material.dart';
import 'package:kisankonnect/src/resources/resources.dart';

class CustomCard extends StatelessWidget {
  final Widget childWidget;

  CustomCard(this.childWidget);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: AppColor.WHITE.color,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: AppColor.PRIMARY.color.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: childWidget,
    );
  }
}
