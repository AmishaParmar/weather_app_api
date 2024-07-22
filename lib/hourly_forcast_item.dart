import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: Card(
        color: const Color.fromARGB(245, 16, 192, 189),
        shadowColor:  const Color.fromARGB(249, 176, 193, 84),
        elevation: 6.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                time,
                //maxLines: 1,
                //overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(icon, size: 32),
              const SizedBox(
                height: 8,
              ),
              Text(
                temp,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
