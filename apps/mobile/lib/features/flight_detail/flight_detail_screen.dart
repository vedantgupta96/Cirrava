import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/domain/flight.dart';
import '../../design_system/app_colors.dart';
import '../../shared/formatters/flight_formatters.dart';
import '../../shared/widgets/terrella_globe.dart';
import '../../shared/widgets/torn_paper_card.dart';

class FlightDetailScreen extends ConsumerWidget {
  const FlightDetailScreen({super.key, required this.flightId});

  final String flightId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flight = ref.watch(flightProvider(flightId));
    return Scaffold(
      key: const Key('flight-detail-screen'),
      body: SafeArea(
        bottom: false,
        child: flight.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (error, _) => _MissingFlight(
            message: 'Cirrava could not load this flight.',
            onBack: () => context.go('/'),
          ),
          data: (value) {
            if (value == null) {
              return _MissingFlight(
                message: 'This flight is no longer stored on this device.',
                onBack: () => context.go('/'),
              );
            }
            final content = value.isCancelled
                ? _CancelledFlightDetail(flight: value)
                : _ActiveFlightDetail(flight: value);
            return Column(
              children: [
                _DetailHeader(
                  flight: value,
                  onBack: () =>
                      context.canPop() ? context.pop() : context.go('/'),
                  onStopTracking: () => _stopTracking(context, ref, value.id),
                ),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _stopTracking(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final repository = ref.read(flightRepositoryProvider);
    final follows = await repository.watchActiveFollows().first;
    final matching = follows.where((item) => item.flight.id == id).firstOrNull;
    if (matching == null) return;
    await repository.unfollow(matching.follow.id);
    if (context.mounted) context.go('/');
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.flight,
    required this.onBack,
    required this.onStopTracking,
  });

  final FlightSnapshot flight;
  final VoidCallback onBack;
  final VoidCallback onStopTracking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            tooltip: 'Back',
            color: AppColors.muted,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          const Text(
            'CIRRAVA',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10.5,
              letterSpacing: 4.5,
            ),
          ),
          const Spacer(),
          Text(
            flight.operatingFlightNumber,
            style: const TextStyle(
              color: AppColors.muted,
              fontFamily: 'SpaceMono',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Flight options',
            color: AppColors.surfaceRaised,
            onSelected: (value) {
              if (value == 'stop') onStopTracking();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'stop', child: Text('Stop tracking')),
            ],
            icon: const Icon(Icons.more_horiz_rounded, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _ActiveFlightDetail extends StatelessWidget {
  const _ActiveFlightDetail({required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    final isInflight =
        flight.phase == FlightPhase.enRoute ||
        flight.phase == FlightPhase.departed;
    final delayed = flight.departureDelay.inMinutes > 0;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(
                  height: isInflight ? 285 : 300,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: TerrellaGlobe(
                          height: isInflight ? 285 : 300,
                          progress: isInflight ? 0.56 : 0.18,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 24,
                        child: _LiveState(
                          label: isInflight
                              ? 'IN FLIGHT'
                              : delayed
                              ? 'DELAYED +${flight.departureDelay.inMinutes}'
                              : flight.phase.label.toUpperCase(),
                          color: delayed ? AppColors.amber : AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isInflight)
                  _InflightHero(flight: flight)
                else ...[
                  const _RouteLegend(),
                  const SizedBox(height: 16),
                  _DepartureArrivalTimes(flight: flight),
                ],
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    26,
                    isInflight ? 20 : 24,
                    26,
                    22,
                  ),
                  child: _FlightNarrative(flight: flight),
                ),
                const Spacer(),
                TornPaperCard(child: _BoardingPass(flight: flight)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveState extends StatelessWidget {
  const _LiveState({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color, blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: TextStyle(
            color: color == AppColors.amber ? AppColors.amberLight : color,
            fontFamily: 'SpaceMono',
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RouteLegend extends StatelessWidget {
  const _RouteLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppColors.amber, label: 'YOUR AIRCRAFT'),
        SizedBox(width: 18),
        _LegendItem(color: AppColors.cyan, label: 'YOUR ROUTE', dashed: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 15,
          child: Row(
            children: dashed
                ? [
                    Container(width: 5, height: 2, color: color),
                    const SizedBox(width: 3),
                    Container(width: 5, height: 2, color: color),
                  ]
                : [Expanded(child: Container(height: 2, color: color))],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontFamily: 'SpaceMono',
            fontSize: 9.5,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _DepartureArrivalTimes extends StatelessWidget {
  const _DepartureArrivalTimes({required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _BigTime(
              airport: flight.originCode,
              label: 'DEPARTS',
              value: airportTime(
                flight.estimatedDepartureUtc,
                flight.originTimeZone,
              ),
              oldValue: flight.departureDelay.inMinutes > 0
                  ? airportTime(
                      flight.scheduledDepartureUtc,
                      flight.originTimeZone,
                    )
                  : null,
              highlighted: flight.departureDelay.inMinutes > 0,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _BigTime(
              airport: flight.destinationCode,
              label: 'ARRIVES',
              value: airportTime(
                flight.estimatedArrivalUtc,
                flight.destinationTimeZone,
              ),
              oldValue: flight.arrivalDelay.inMinutes > 0
                  ? airportTime(
                      flight.scheduledArrivalUtc,
                      flight.destinationTimeZone,
                    )
                  : null,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _BigTime extends StatelessWidget {
  const _BigTime({
    required this.airport,
    required this.label,
    required this.value,
    this.oldValue,
    this.highlighted = false,
    this.alignEnd = false,
  });

  final String airport;
  final String label;
  final String value;
  final String? oldValue;
  final bool highlighted;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final valueParts = value.split(' ');
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          '$airport · $label',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            letterSpacing: 1.7,
          ),
        ),
        if (oldValue != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              oldValue!,
              style: const TextStyle(
                color: AppColors.mutedDeep,
                fontSize: 13,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2,
              ),
            ),
          ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: highlighted ? AppColors.amber : AppColors.ink,
              fontFamily: 'SpaceGrotesk',
              fontSize: 34,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.2,
            ),
            children: [
              TextSpan(text: valueParts.first),
              if (valueParts.length > 1)
                TextSpan(
                  text: ' ${valueParts.last}',
                  style: const TextStyle(fontSize: 16, letterSpacing: 0),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InflightHero extends StatelessWidget {
  const _InflightHero({required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    final remaining = flight.estimatedArrivalUtc.difference(
      DateTime.now().toUtc(),
    );
    final hours = remaining.isNegative ? 0 : remaining.inHours;
    final minutes = remaining.isNegative
        ? 0
        : remaining.inMinutes.remainder(60);
    return Column(
      children: [
        const Text(
          'TIME TO GO',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: AppColors.ink,
              fontFamily: 'SpaceGrotesk',
              fontSize: 52,
              fontWeight: FontWeight.w700,
              letterSpacing: -2,
            ),
            children: [
              TextSpan(text: '$hours'),
              const TextSpan(
                text: 'h ',
                style: TextStyle(color: AppColors.muted, fontSize: 24),
              ),
              TextSpan(text: '$minutes'),
              const TextSpan(
                text: 'm',
                style: TextStyle(color: AppColors.muted, fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Lands ${airportTime(flight.estimatedArrivalUtc, flight.destinationTimeZone)} local',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    );
  }
}

class _FlightNarrative extends StatelessWidget {
  const _FlightNarrative({required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    final isStale = flight.isStaleAt(DateTime.now().toUtc());
    final delayed = flight.departureDelay.inMinutes > 0;
    final color = isStale
        ? AppColors.muted
        : delayed
        ? AppColors.amber
        : AppColors.cyan;
    final message = isStale
        ? 'This update may be out of date. Cirrava last saw this flight ${relativeFreshness(flight.observedAt, DateTime.now().toUtc()).toLowerCase()}.'
        : delayed
        ? 'Departure moved ${delayLabel(flight.departureDelay)}. Your current gate is ${flight.originGate ?? 'not assigned yet'}, and the arrival estimate has moved with it.'
        : 'Everything looks steady. Gate ${flight.originGate ?? 'details are still pending'} and the current departure estimate match the schedule.';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color, blurRadius: 11)],
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.inkSoft,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _BoardingPass extends StatelessWidget {
  const _BoardingPass({required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: AppColors.paperInk,
        fontFamily: 'SpaceMono',
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'FLIGHT CARD',
                  style: TextStyle(
                    color: AppColors.paperMuted,
                    fontSize: 9.5,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Text(
                '${flight.originTerminal == null ? '' : 'TERMINAL ${flight.originTerminal} · '}${flight.operatingFlightNumber}',
                style: const TextStyle(
                  color: AppColors.paperMuted,
                  fontSize: 9.5,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PassFact(label: 'GATE', value: flight.originGate ?? '—'),
              _PassFact(
                label: 'DEPARTS',
                value: _compactTime(
                  airportTime(
                    flight.estimatedDepartureUtc,
                    flight.originTimeZone,
                  ),
                ),
              ),
              _PassFact(
                label: 'ARRIVES',
                value: _compactTime(
                  airportTime(
                    flight.estimatedArrivalUtc,
                    flight.destinationTimeZone,
                  ),
                ),
                alignEnd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _compactTime(String value) => value.replaceAll(' ', '');

class _PassFact extends StatelessWidget {
  const _PassFact({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.paperMuted, fontSize: 9.5),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _CancelledFlightDetail extends StatelessWidget {
  const _CancelledFlightDetail({required this.flight});

  final FlightSnapshot flight;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -1.2),
          radius: 1.3,
          colors: [Color(0xFF2A0F14), Color(0xFF12080F), AppColors.night],
          stops: [0, 0.42, 1],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 16, 26, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${flight.operatingFlightNumber} · ${flight.originCode} → ${flight.destinationCode}',
                            style: const TextStyle(
                              color: Color(0xFFC98F96),
                              fontFamily: 'SpaceMono',
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const _LiveState(
                          label: 'CANCELLED',
                          color: AppColors.cancelled,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 26, 26, 0),
                    child: Text(
                      "This flight won't fly.",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(26, 12, 26, 0),
                    child: Text(
                      'Your original itinerary is no longer operating. Compare rebooking and refund choices before accepting a replacement.',
                      style: TextStyle(
                        color: Color(0xFFD8B8BC),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(26, 28, 26, 12),
                    child: Text(
                      'WHAT TO DO NEXT',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 10.5,
                        letterSpacing: 2.8,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: _RecoveryCard(
                      title: 'Review rebooking options',
                      body:
                          'Compare arrival time, stops, seat continuity, and any fare change.',
                      primary: true,
                      onTap: () => _showLiveDataNote(context),
                    ),
                  ),
                  const SizedBox(height: 11),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: _RecoveryCard(
                      title: 'Keep a refund as your fallback',
                      body:
                          'Eligibility depends on the airline, ticket, and applicable passenger protections.',
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 22),
                  TornPaperCard(
                    child: _CancellationStub(
                      flightNumber: flight.operatingFlightNumber,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLiveDataNote(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceRaised,
      showDragHandle: true,
      builder: (context) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 6, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live rebooking comes with provider integration',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'This first build uses deterministic flight fixtures. Cirrava will link to verified airline options once live data is connected.',
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  const _RecoveryCard({
    required this.title,
    required this.body,
    this.primary = false,
    this.onTap,
  });

  final String title;
  final String body;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary ? AppColors.surfaceRaised : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary
              ? AppColors.amber.withValues(alpha: 0.42)
              : AppColors.stroke,
        ),
        boxShadow: primary
            ? [
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.15),
                  blurRadius: 28,
                  spreadRadius: -10,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(body, style: Theme.of(context).textTheme.bodySmall),
          if (primary) ...[
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
              ),
              child: const Text('Review options'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CancellationStub extends StatelessWidget {
  const _CancellationStub({required this.flightNumber});

  final String flightNumber;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: AppColors.paperInk,
        fontFamily: 'SpaceMono',
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TRAVEL RECORD · $flightNumber',
                  style: const TextStyle(
                    color: AppColors.paperMuted,
                    fontSize: 9.5,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep receipts and the cancellation notice',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Transform.rotate(
            angle: 0.08,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFB5342A), width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'CANCELLED',
                style: TextStyle(
                  color: Color(0xFFB5342A),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingFlight extends StatelessWidget {
  const _MissingFlight({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flight_outlined, color: AppColors.muted, size: 40),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onBack, child: const Text('Back home')),
          ],
        ),
      ),
    );
  }
}
