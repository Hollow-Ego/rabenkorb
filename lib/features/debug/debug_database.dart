import 'package:flutter/material.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/features/debug/debug_database_helper.dart';
import 'package:rabenkorb/features/debug/debug_database_real_data_sample.dart';
import 'package:rabenkorb/services/core/snackbar_service.dart';
import 'package:rabenkorb/shared/helper_functions.dart';
import 'package:rabenkorb/shared/widgets/inputs/core_primary_button.dart';
import 'package:watch_it/watch_it.dart';

class DebugDatabase extends StatelessWidget {
  const DebugDatabase({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            title: Text("Database"),
          ),
          CorePrimaryButton(
            onPressed: () async {
              await doWithLoadingIndicator(() async {
                final db = di<AppDatabase>();
                await clearDatabase(db);
                await seedDatabaseWithExampleData(db);
              });
              if (context.mounted) {
                di<SnackBarService>().show(context: context, text: "Database seeded");
              }
            },
            child: const Text("Seed Database with Example Data"),
          ),
          CorePrimaryButton(
            onPressed: () async {
              await doWithLoadingIndicator(() async {
                final db = di<AppDatabase>();
                await clearDatabase(db);
                await seedDatabase(db);
              });
              if (context.mounted) {
                di<SnackBarService>().show(context: context, text: "Database seeded");
              }
            },
            child: const Text("Seed Database with Test Data"),
          ),
        ],
      ),
    );
  }
}
