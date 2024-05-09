import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:rabenkorb/generated/l10n.dart';
import 'package:rabenkorb/shared/no_search_result.dart';

class CoreSearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final _dropdownStateKey = GlobalKey<DropdownSearchState<T>>();
  final T? selectedItem;
  final String Function(T)? itemAsString;
  final String Function(T?) displayString;
  final void Function(T?)? onChanged;
  final bool Function(T, T)? compareFn;
  final void Function(String)? onNoSearchResultAction;
  final bool allowEmptyValue;
  final InputDecoration? inputDecoration;

  CoreSearchableDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    this.itemAsString,
    required this.displayString,
    this.onChanged,
    this.compareFn,
    this.onNoSearchResultAction,
    this.allowEmptyValue = true,
    this.inputDecoration,
  });

  final _searchTextController = TextEditingController();

  void _onNoSearchResultAction() {
    if (onNoSearchResultAction == null) {
      return;
    }
    _dropdownStateKey.currentState?.closeDropDownSearch();
    onNoSearchResultAction!(_searchTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      key: _dropdownStateKey,
      items: items,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      clearButtonProps: ClearButtonProps(
        isVisible: allowEmptyValue,
      ),
      dropdownBuilder: (context, item) {
        return Text(displayString(item));
      },
      onChanged: onChanged,
      compareFn: compareFn,
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
        fit: FlexFit.loose,
        menuProps: const MenuProps(
          backgroundColor: Colors.transparent,
        ),
        containerBuilder: (BuildContext context, Widget widget) {
          return Material(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            elevation: 4,
            shadowColor: Colors.black,
            child: widget,
          );
        },
        emptyBuilder: (BuildContext context, String _) => NoSearchResult(
          onNoResultAction: onNoSearchResultAction != null ? _onNoSearchResultAction : null,
          searchTerm: _searchTextController.text,
        ),
        searchFieldProps: TextFieldProps(
          controller: _searchTextController,
          decoration: InputDecoration(
            hintText: S.of(context).SearchLabel,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchTextController.clear();
              },
            ),
          ),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(dropdownSearchDecoration: inputDecoration),
    );
  }
}
