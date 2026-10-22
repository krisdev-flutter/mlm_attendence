import 'package:flutter/material.dart';

class NavDrawerItem extends StatelessWidget {
  const NavDrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: isSelected
            ? BoxDecoration(
                color: primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? primary : Colors.grey[700],
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          color: isSelected ? primary : null,
        ),
      ),
      onTap: onTap,
      tileColor: isSelected
          ? Theme.of(context).colorScheme.surface.withOpacity(.5)
          : null,
    );
  }
}
