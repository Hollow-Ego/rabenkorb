import 'package:flutter/material.dart';
import 'package:rabenkorb/features/core/structural/navigation/destination_details.dart';
import 'package:rabenkorb/generated/l10n.dart';

final List<DestinationDetails> mainDestinations = [
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.bug_report),
      label: S.current.Debug,
    ),
    body: const Center(
      child: Text("Debug 1"),
    ),
    appBar: AppBar(),
    index: 0,
  ),
  DestinationDetails(
    destination: NavigationDestination(
      icon: const Icon(Icons.bug_report),
      label: S.current.Debug,
    ),
    body: const Center(
      child: Text("Debug 2"),
    ),
    index: 1,
    mainAction: MainAction(
      icon: const Icon(Icons.access_alarm),
      onPressed: (BuildContext context) {},
    ),
  )
];
