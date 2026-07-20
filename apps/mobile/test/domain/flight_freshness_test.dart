import 'package:cirrava_mobile/core/domain/flight.dart';
import 'package:cirrava_mobile/shared/formatters/flight_formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final observed = DateTime.utc(2026, 7, 18, 12, 0);

  group('FlightSnapshot.isStaleFor', () {
    test('fresh within the threshold', () {
      expect(
        FlightSnapshot.isStaleFor(
          observedAt: observed,
          now: observed.add(const Duration(minutes: 14)),
        ),
        isFalse,
      );
    });

    test('exactly at the threshold is not yet stale', () {
      expect(
        FlightSnapshot.isStaleFor(
          observedAt: observed,
          now: observed.add(FlightSnapshot.staleThreshold),
        ),
        isFalse,
      );
    });

    test('stale once past the threshold', () {
      expect(
        FlightSnapshot.isStaleFor(
          observedAt: observed,
          now: observed.add(const Duration(minutes: 16)),
        ),
        isTrue,
      );
    });

    test('normalises across time zones (local vs utc)', () {
      // observedAt supplied in a non-UTC zone must still compare correctly.
      final localObserved = observed.toLocal();
      expect(
        FlightSnapshot.isStaleFor(
          observedAt: localObserved,
          now: observed.add(const Duration(minutes: 5)),
        ),
        isFalse,
      );
    });
  });

  group('relativeFreshness', () {
    test('just now under a minute', () {
      expect(
        relativeFreshness(observed, observed.add(const Duration(seconds: 30))),
        'Updated just now',
      );
    });

    test('singular minute', () {
      expect(
        relativeFreshness(observed, observed.add(const Duration(minutes: 1))),
        'Updated 1 min ago',
      );
    });

    test('minutes then hours', () {
      expect(
        relativeFreshness(observed, observed.add(const Duration(minutes: 42))),
        'Updated 42 min ago',
      );
      expect(
        relativeFreshness(observed, observed.add(const Duration(hours: 3))),
        'Updated 3 hours ago',
      );
    });
  });
}
