import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final double topPadding;

  const MenuOption(this.title,
      {super.key, this.isSelected = false, this.topPadding = 0});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: topPadding), // Uso del parámetro
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isSelected ? 23 : 16,
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            if (isSelected)
              Container(
                width: 94,
                height: 3.2,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
