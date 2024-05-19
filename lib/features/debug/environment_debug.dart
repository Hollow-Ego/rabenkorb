import 'package:flutter/material.dart';
import 'package:rabenkorb/services/core/environment_service.dart';
import 'package:watch_it/watch_it.dart';

class EnvironmentDebug extends StatelessWidget {
  const EnvironmentDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            const ListTile(
              title: Text("Environment"),
            ),
            ListTile(
              title: Text(di<EnvironmentService>().environment),
            ),
            ListTile(
              title: Text("Has MongoDb Connection String: ${di<EnvironmentService>().hasConnectionString}"),
            ),
          ],
        ),
      ),
    );
  }
}
