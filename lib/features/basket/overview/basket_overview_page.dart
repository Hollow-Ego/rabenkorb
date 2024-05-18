import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/core_scaffold.dart';
import 'package:rabenkorb/features/core/structural/drawer/core_drawer.dart';
import 'package:rabenkorb/generated/l10n.dart';

class BasketOverviewPage extends StatelessWidget {
  const BasketOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreScaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(S.of(context).BasketOverview)],
          ),
        ),
      ),
      drawer: const CoreDrawer(),
      appBar: AppBar(
        title: Text(S.of(context).BasketOverview),
      ),
    );
  }
}
