import 'package:flutter/material.dart';

class BottomTabItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function onTap;
  final double size;
  const BottomTabItem({Key key, this.icon, this.isSelected, this.onTap, this.size}): super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, 
            color: isSelected? Colors.white: Colors.grey,
            size: isSelected? 30:25,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}