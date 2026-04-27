import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/category_utils.dart';
import '../../core/utils/format_utils.dart';
import '../../domain/entities/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Format description text based on items
    String summaryText = '';
    if (transaction.items.isNotEmpty) {
      final firstItem = transaction.items.first;
      summaryText = firstItem.quantity > 1
          ? '${firstItem.quantity}x ${firstItem.product.name}'
          : firstItem.product.name;

      if (transaction.items.length > 1) {
        final remaining = transaction.items.length - 1;
        summaryText += ' & $remaining more';
      }
    } else {
      summaryText = 'No items';
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: ID and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.id,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  FormatUtils.relativeDate(transaction.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Middle Section: Item Summary
            Text(
              summaryText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),

            // Categories Wrap
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: transaction.categories.map((cat) {
                final color = CategoryUtils.getColor(cat);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: color.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CategoryUtils.getIcon(cat),
                          size: 12.sp,
                          color: color),
                      SizedBox(width: 4.w),
                      Text(
                        cat,
                        style: TextStyle(
                          color: color,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),

            // Bottom Row: Status and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: _statusColor(transaction.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _statusColor(transaction.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        transaction.status,
                        style: TextStyle(
                          color: _statusColor(transaction.status),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Total Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    Text(
                      FormatUtils.currency(transaction.amount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF00B894);
      case 'Pending':
        return const Color(0xFFFDCB6E);
      case 'Failed':
        return const Color(0xFFD63031);
      default:
        return const Color(0xFF636E72);
    }
  }
}
