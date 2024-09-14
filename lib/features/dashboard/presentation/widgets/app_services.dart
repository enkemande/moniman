import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/entities/app_service.dart';

final appServices = [
  const AppService(
    title: 'Send Money',
    subtitle: 'Send',
    icon: Icons.send,
  ),
  const AppService(
    title: 'Request Money',
    subtitle: 'Request',
    icon: Icons.request_page,
  ),
  const AppService(
    title: 'Add Money',
    subtitle: 'add money',
    icon: Icons.wallet,
  ),
  const AppService(
    title: 'Withdraw',
    subtitle: 'Withdraw',
    icon: Icons.wallet,
  ),
];

class AppServices extends StatelessWidget {
  const AppServices({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: appServices.map((service) {
          return GestureDetector(
            onTap: () {
              if (service.path != null) {
                context.push(service.path!);
              }
            },
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: service.color.withOpacity(0.2),
                      radius: 30,
                      child: Icon(
                        service.icon,
                        size: 30,
                        color: service.color,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Text(
                    //   service.title,
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }).toList());
  }
}
