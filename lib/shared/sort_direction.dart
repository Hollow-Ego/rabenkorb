import 'package:drift/drift.dart';

enum SortDirection { asc, desc }

SortDirection flipSortDirection(SortDirection sortDirection) {
  return sortDirection == SortDirection.asc ? SortDirection.desc : SortDirection.asc;
}

OrderingMode toOrderingMode(SortDirection sortDirection) {
  switch (sortDirection) {
    case SortDirection.desc:
      return OrderingMode.desc;
    case SortDirection.asc:
    default:
      return OrderingMode.asc;
  }
}
