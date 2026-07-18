import 'package:flutter/material.dart';

import '../../core/domain/flight.dart';
import '../../design_system/app_colors.dart';
import '../formatters/flight_formatters.dart';
import 'flight_status_badge.dart';

class FlightRouteCard extends StatelessWidget {
  const FlightRouteCard({
    super.key,
    required this.flight,
    required this.onTap,
    this.trailing,
  });

  final FlightSnapshot flight;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    final isStale = flight.isStaleAt(now);
    return Semantics(
      button: true,
      label:
          '${flight.operatingFlightNumber}, ${flight.originCode} to ${flight.destinationCode}, ${flight.phase.label}',
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        flight.operatingFlightNumber,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    FlightStatusBadge(flight: flight),
                    if (trailing != null) ...[
                      const SizedBox(width: 4),
                      trailing!,
                    ],
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _Airport(code: flight.originCode)),
                    const _RouteLine(),
                    Expanded(
                      child: _Airport(
                        code: flight.destinationCode,
                        alignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _Time(
                        value: airportTime(
                          flight.estimatedDepartureUtc,
                          flight.originTimeZone,
                        ),
                        changed: flight.departureDelay.inMinutes > 0,
                      ),
                    ),
                    Text(
                      airportDate(
                        flight.scheduledDepartureUtc,
                        flight.originTimeZone,
                      ),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                    ),
                    Expanded(
                      child: _Time(
                        value: airportTime(
                          flight.estimatedArrivalUtc,
                          flight.destinationTimeZone,
                        ),
                        changed: flight.arrivalDelay.inMinutes > 0,
                        alignment: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      isStale ? Icons.cloud_off_outlined : Icons.sync,
                      size: 15,
                      color: isStale ? AppColors.delayed : AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isStale
                          ? 'May be out of date'
                          : relativeFreshness(flight.observedAt, now),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isStale ? AppColors.delayed : AppColors.muted,
                        fontWeight: isStale ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Airport extends StatelessWidget {
  const _Airport({
    required this.code,
    this.alignment = CrossAxisAlignment.start,
  });

  final String code;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          code,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.signal,
              shape: BoxShape.circle,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({
    required this.value,
    required this.changed,
    this.alignment = TextAlign.start,
  });

  final String value;
  final bool changed;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: alignment,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: changed ? AppColors.delayed : null,
        fontWeight: FontWeight.w800,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
