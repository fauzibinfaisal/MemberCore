import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/category_utils.dart';

class FilterChipRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const FilterChipRow({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCategory = label == 'Category';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 14.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: options.map((option) {
            final isSelected = selected == option;

            Widget labelWidget = Text(
              option,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : isCategory
                    ? CategoryUtils.getColor(option)
                    : const Color(0xFF0984E3),
              ),
            );

            if (isCategory) {
              labelWidget = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CategoryUtils.getIcon(option),
                    size: 14.sp,
                    color: isSelected ? theme.colorScheme.onPrimary : CategoryUtils.getColor(option),
                  ),
                  SizedBox(width: 6.w),
                  labelWidget,
                ],
              );
            }

            return FilterChip(
              label: labelWidget,
              selected: isSelected,
              onSelected: (val) {
                onSelected(val ? option : null);
              },
              showCheckmark: false,
              selectedColor: isCategory ? CategoryUtils.getColor(option) : const Color(0xFF0984E3),
              backgroundColor: theme.colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: BorderSide(
                  color: isSelected
                      ? (isCategory ? CategoryUtils.getColor(option) : const Color(0xFF0984E3))
                      : theme.colorScheme.onSurface.withValues(alpha: 0.15),
                ),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        SizedBox(height: 24.h),
        Divider(height: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.08)),
      ],
    );
  }
}
