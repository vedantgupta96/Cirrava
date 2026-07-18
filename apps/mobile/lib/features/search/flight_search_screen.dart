import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/domain/flight.dart';
import '../../core/domain/flight_follow.dart';
import '../../design_system/app_colors.dart';
import '../../infrastructure/fixtures/flight_search_service.dart';
import '../../shared/formatters/flight_formatters.dart';

class FlightSearchScreen extends ConsumerStatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  ConsumerState<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends ConsumerState<FlightSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  var _requestId = 0;
  var _loading = false;
  String? _error;
  String? _trackingId;
  List<FlightSnapshot> _results = const [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    final query = normalizeFlightQuery(_controller.text);
    if (query.replaceAll(' ', '').length < 2) {
      setState(() {
        _loading = false;
        _error = null;
        _results = const [];
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 280), () {
      unawaited(_search(query));
    });
  }

  Future<void> _search(String query) async {
    final requestId = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await ref.read(flightSearchServiceProvider).search(query);
      if (!mounted || requestId != _requestId) return;
      await ref
          .read(flightRepositoryProvider)
          .cacheSearchResults(query, results);
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _loading = false;
        _error = 'Search is unavailable right now. Try again.';
      });
    }
  }

  Future<void> _track(FlightSnapshot flight) async {
    setState(() => _trackingId = flight.id);
    try {
      final query = normalizeFlightQuery(_controller.text);
      await ref
          .read(flightRepositoryProvider)
          .cacheSearchResults(query, _results);
      await ref.read(flightRepositoryProvider).follow(flight.id);
      if (!mounted) return;
      context.go('/flight/${flight.id}');
    } on AnonymousFollowLimitException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cirrava can track one flight for now. Stop tracking the current flight first.',
          ),
        ),
      );
      setState(() => _trackingId = null);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not track this flight. Try again.'),
        ),
      );
      setState(() => _trackingId = null);
    }
  }

  void _useExample(String query) {
    _controller
      ..text = query
      ..selection = TextSelection.collapsed(offset: query.length);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('flight-search-screen'),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SearchHeader(onBack: () => context.pop()),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: _FlightQueryField(
                controller: _controller,
                focusNode: _focusNode,
              ),
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FilterChip(label: 'TODAY', selected: true),
                  SizedBox(width: 8),
                  _FilterChip(label: 'TOMORROW'),
                  SizedBox(width: 8),
                  _FilterChip(label: 'BY ROUTE  ›'),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _SearchBody(
                  key: ValueKey(
                    '${_loading}_${_results.length}_${_error ?? ''}_${_controller.text}',
                  ),
                  query: _controller.text,
                  loading: _loading,
                  error: _error,
                  results: _results,
                  trackingId: _trackingId,
                  onTrack: _track,
                  onExample: _useExample,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 24, 0),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: onBack,
            tooltip: 'Back',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.muted.withValues(alpha: 0.12),
              foregroundColor: AppColors.muted,
            ),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Track a flight',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlightQueryField extends StatelessWidget {
  const _FlightQueryField({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.cyan, width: 1.5),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.16),
            blurRadius: 26,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AIRLINE + FLIGHT NUMBER',
              style: TextStyle(
                color: AppColors.muted,
                fontFamily: 'SpaceMono',
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
            TextField(
              key: const Key('flight-query-field'),
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.characters,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.cyan,
              cursorWidth: 3,
              style: const TextStyle(
                color: AppColors.ink,
                fontFamily: 'SpaceMono',
                fontSize: 31,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
              decoration: const InputDecoration(
                isDense: true,
                filled: false,
                hintText: 'AA 100',
                hintStyle: TextStyle(
                  color: AppColors.mutedDeep,
                  fontFamily: 'SpaceMono',
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                ),
                contentPadding: EdgeInsets.only(top: 7),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.cyan.withValues(alpha: 0.14) : null,
        border: Border.all(
          color: selected
              ? AppColors.cyan.withValues(alpha: 0.52)
              : AppColors.muted.withValues(alpha: 0.25),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.cyan : AppColors.muted,
            fontFamily: 'SpaceMono',
            fontSize: 10.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({
    super.key,
    required this.query,
    required this.loading,
    required this.error,
    required this.results,
    required this.trackingId,
    required this.onTrack,
    required this.onExample,
  });

  final String query;
  final bool loading;
  final String? error;
  final List<FlightSnapshot> results;
  final String? trackingId;
  final ValueChanged<FlightSnapshot> onTrack;
  final ValueChanged<String> onExample;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            error!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }
    if (query.trim().length < 2) {
      return _SearchExamples(onExample: onExample);
    }
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.radar_rounded,
                color: AppColors.mutedDeep,
                size: 38,
              ),
              const SizedBox(height: 14),
              Text(
                'No matching flight',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 7),
              const Text(
                'Try the airline code and number, such as DL 442.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final flight = results[index];
        return _ResultRow(
          flight: flight,
          loading: trackingId == flight.id,
          onTrack: () => onTrack(flight),
        );
      },
    );
  }
}

class _SearchExamples extends StatelessWidget {
  const _SearchExamples({required this.onExample});

  final ValueChanged<String> onExample;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(26, 30, 26, 32),
      children: [
        const Text(
          'TRY A SAMPLE FLIGHT',
          style: TextStyle(
            color: AppColors.muted,
            fontFamily: 'SpaceMono',
            fontSize: 10.5,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 13),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            for (final code in ['AA 100', 'DL 442', 'UA 908'])
              ActionChip(
                onPressed: () => onExample(code),
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.stroke),
                label: Text(
                  code,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontFamily: 'SpaceMono',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 22),
        const Text(
          'Search is running on deterministic fixture data in this first slice. Live airline data comes next.',
          style: TextStyle(color: AppColors.muted, height: 1.45),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.flight,
    required this.loading,
    required this.onTrack,
  });

  final FlightSnapshot flight;
  final bool loading;
  final VoidCallback onTrack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${flight.operatingFlightNumber} · ${flight.originCode} → ${flight.destinationCode}',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontFamily: 'SpaceMono',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${airportTime(flight.estimatedDepartureUtc, flight.originTimeZone)} · ${flight.operatingCarrierName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            key: Key('track-${flight.id}'),
            onPressed: loading ? null : onTrack,
            style: FilledButton.styleFrom(
              minimumSize: const Size(72, 42),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: loading
                ? const SizedBox.square(
                    dimension: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.paperInk,
                    ),
                  )
                : const Text('Track'),
          ),
        ],
      ),
    );
  }
}
