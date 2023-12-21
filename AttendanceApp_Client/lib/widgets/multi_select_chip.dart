import 'package:flutter/material.dart';

class MultiSelectChip<T> extends StatefulWidget {
  const MultiSelectChip(
      {super.key,
      required this.reportList,
      required this.onSelectionChanged,
      required this.labelBuilder,
      this.alreadySelected});

  final List<T> reportList;
  final Function(List<T>) onSelectionChanged;
  final Widget Function(T) labelBuilder;
  final List<T>? alreadySelected;

  @override
  State<MultiSelectChip<T>> createState() => _MultiSelectChipState<T>();
}

class _MultiSelectChipState<T> extends State<MultiSelectChip<T>> {
  // list to hold selected items
  List<T> selectedReportList = [];

  _getAlreadySelectedChips() {
    if (widget.alreadySelected != null && widget.alreadySelected!.isNotEmpty) {
      for (var item in widget.alreadySelected!) {
        selectedReportList.add(item);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _getAlreadySelectedChips();
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.reportList) {
      final label = widget.labelBuilder(item);
      choices.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            selectedColor: Theme.of(context).colorScheme.background,
            label: label,
            selected: selectedReportList.contains(item),
            onSelected: (selected) {
              setState(() {
                selected
                    ? selectedReportList.add(item)
                    : selectedReportList.remove(item);
                widget.onSelectionChanged(selectedReportList);
              });
            },
          ),
        ),
      );
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildChoiceList(),
    );
  }
}
