import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/domain/flight.dart';
import '../../core/domain/flight_follow.dart';
import '../../design_system/app_colors.dart';
import '../../shared/formatters/flight_formatters.dart';
import '../../shared/widgets/terrella_globe.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final follows = ref.watch(activeFollowsProvider);
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      key: const Key('home-screen'),
      floatingActionButton: isIos
          ? null
          : FloatingActionButton(
              key: const Key('track-flight-fab'),
              onPressed: () => context.push('/search'),
              tooltip: 'Track a flight',
              backgroundColor: AppColors.amber,
              foregroundColor: AppColors.paperInk,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add_rounded, size: 30),
            ),
      body: SafeArea(
        bottom: false,
        child: follows.when(
          loading: () => const _LoadingHome(),
          error: (error, _) => _HomeError(
            onRetry: () {
              ref.invalidate(activeFollowsProvider);
            },
          ),
          data: (items) => _HomeContent(
            followedFlight: items.firstOrNull,
            showInlineAdd: isIos,
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.followedFlight,
    required this.showInlineAdd,
  });

  final FollowedFlight? followedFlight;
  final bool showInlineAdd;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Expanded(child: _Wordmark()),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.amber, AppColors.violet],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'V',
                    style: TextStyle(
                      color: AppColors.night,
                      fontFamily: 'SpaceMono',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Text(
              followedFlight == null ? 'Ready when you are' : 'Your flight',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
          sliver: SliverToBoxAdapter(
            child: followedFlight == null
                ? const _EmptyFlightHero()
                : _TrackedFlightHero(item: followedFlight!),
          ),
        ),
        if (showInlineAdd)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            sliver: SliverToBoxAdapter(
              child: _TrackFlightRow(
                hasFlight: followedFlight != null,
                onTap: () => context.push('/search'),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 112)),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'CIRRAVA',
      style: TextStyle(
        color: AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 5,
      ),
    );
  }
}

class _TrackedFlightHero extends StatelessWidget {
  const _TrackedFlightHero({required this.item});

  final FollowedFlight item;

  @override
  Widget build(BuildContext context) {
    final flight = item.flight;
    final delayed = flight.departureDelay.inMinutes > 0;
    final cancelled = flight.isCancelled;
    return Semantics(
      button: true,
      label:
          '${flight.operatingFlightNumber}, ${flight.originCode} to ${flight.destinationCode}',
      child: Material(
        color: AppColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: (cancelled ? AppColors.cancelled : AppColors.amber)
                .withValues(alpha: 0.38),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const Key('tracked-flight-card'),
          onTap: () => context.push('/flight/${flight.id}'),
          child: Column(
            children: [
              SizedBox(
                height: 188,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: TerrellaGlobe(height: 188, compact: true),
                    ),
                    Positioned(
                      top: 12,
                      left: 14,
                      child: _SignalChip(
                        label: cancelled
                            ? 'CANCELLED'
                            : delayed
                            ? 'DELAYED +${flight.departureDelay.inMinutes}'
                            : flight.phase.label.toUpperCase(),
                        color: cancelled
                            ? AppColors.cancelled
                            : delayed
                            ? AppColors.amber
                            : AppColors.cyan,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${flight.originCode}  →  ${flight.destinationCode}',
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontFamily: 'SpaceMono',
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${airportDate(flight.estimatedDepartureUtc, flight.originTimeZone)} · ${flight.operatingFlightNumber} · ${flight.operatingCarrierName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'DEPARTS',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          airportTime(
                            flight.estimatedDepartureUtc,
                            flight.originTimeZone,
                          ),
                          style: TextStyle(
                            color: delayed ? AppColors.amber : AppColors.ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          color.withValues(alpha: 0.12),
          AppColors.surfaceRaised.withValues(alpha: 0.90),
        ),
        border: Border.all(color: color.withValues(alpha: 0.48)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color, blurRadius: 8, spreadRadius: 0.5),
                ],
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
        ),
      ),
    );
  }
}

class _EmptyFlightHero extends StatelessWidget {
  const _EmptyFlightHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const TerrellaGlobe(height: 222, compact: true, progress: 0.18),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              children: [
                Text(
                  'A calmer way to meet your flight.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Search a flight number. Cirrava will keep the changing parts in one place.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  key: const Key('empty-track-flight-button'),
                  onPressed: () => context.push('/search'),
                  icon: const Icon(Icons.flight_takeoff_rounded),
                  label: const Text('Track a flight'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackFlightRow extends StatelessWidget {
  const _TrackFlightRow({required this.hasFlight, required this.onTap});

  final bool hasFlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.muted.withValues(alpha: 0.38),
          width: 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded, color: AppColors.muted, size: 20),
              const SizedBox(width: 9),
              Text(
                hasFlight
                    ? 'Search another flight'
                    : 'Track a flight — airline, number, date',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingHome extends StatelessWidget {
  const _LoadingHome();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.muted,
              size: 34,
            ),
            const SizedBox(height: 16),
            Text(
              'Cirrava could not load your flight.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
