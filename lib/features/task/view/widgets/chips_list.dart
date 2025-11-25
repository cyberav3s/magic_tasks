import 'package:flutter/material.dart';
import 'package:magic_tasks/core/constants/app_spacing.dart';
import 'package:magic_tasks/core/widgets/app_chip.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChipsList extends StatefulWidget {
  final List<String> topics;
  final Function(String) onFilterSelected;
  final String? initialSelected;

  const ChipsList({
    super.key,
    required this.onFilterSelected,
    this.initialSelected,
    required this.topics,
  });

  @override
  State<ChipsList> createState() => _ChipsListState();
}

class _ChipsListState extends State<ChipsList> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(left: AppSpacing.lg, top: AppSpacing.xs),
        child: Row(
          children: widget.topics.map((filter) {
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: AppChip.custom(
                icon: isSelected ? Icon(Symbols.layers) : null,
                label: filter,
                isSelected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = selected ? filter : null;
                  });
                  widget.onFilterSelected(filter);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
