import 'package:flutter/material.dart';

import '../../core/domain/flight.dart';
import '../../design_system/app_colors.dart';

class FlightStatusBadge extends StatelessWidget {
  const FlightStatusBadge({super.key, required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _presentation;
    return Semantics(
      label: 'Flight status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  (String, Color) get _presentation {
    if (flight.disruptions.contains(DisruptionCondition.cancelled)) {
      return ('Cancelled', AppColors.cancelled);
    }
    if (flight.disruptions.contains(DisruptionCondition.diverted)) {
      return ('Diverted', AppColors.delayed);
    }
    if (flight.disruptions.contains(DisruptionCondition.returnedToGate)) {
      return ('Returned to gate', AppColors.delayed);
    }
    if (flight.disruptions.contains(DisruptionCondition.delayed)) {
      return ('Delayed', AppColors.delayed);
    }
    return (flight.phase.label, AppColors.onTime);
  }
}
