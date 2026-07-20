import 'package:flutter/material.dart';

import '../../core/domain/flight.dart';
import '../../design_system/app_colors.dart';
import '../formatters/flight_formatters.dart';

/// Persistent Data Freshness label.
///
/// Renders the age of the displayed Cached Flight State relative to its last
/// accepted observation. Freshness is always visible so a follower can trust
/// (or discount) what they see; when the state is stale it is emphasised in
/// text, shape, and colour so the meaning never depends on colour alone
/// (PRODUCT.md accessibility gate).
class FreshnessIndicator extends StatelessWidget {
  const FreshnessIndicator({
    super.key,
    required this.observedAt,
    required this.now,
    this.stale,
  });

  /// Last accepted observation time of the Cached Flight State.
  final DateTime observedAt;

  /// Current time, injected so the widget stays deterministic under test.
  final DateTime now;

  /// Whether the state is stale. Defaults to the domain rule when omitted.
  final bool? stale;

  @override
  Widget build(BuildContext context) {
    final isStale =
        stale ??
        FlightSnapshot.isStaleFor(observedAt: observedAt, now: now);
    final label = relativeFreshness(observedAt, now);
    final color = isStale ? AppColors.amberLight : AppColors.muted;

    return Semantics(
      liveRegion: true,
      label: isStale
          ? 'Information may be out of date. $label.'
          : '$label.',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isStale ? Icons.history_rounded : Icons.check_circle_outline_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              isStale ? 'May be out of date · $label' : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontFamily: 'SpaceMono',
                fontSize: 10.5,
                fontWeight: isStale ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
