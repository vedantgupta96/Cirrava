import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

String airportTime(DateTime utc, String timeZone) {
  final local = tz.TZDateTime.from(utc, tz.getLocation(timeZone));
  return DateFormat('h:mm a').format(local);
}

String airportDate(DateTime utc, String timeZone) {
  final local = tz.TZDateTime.from(utc, tz.getLocation(timeZone));
  return DateFormat('EEE, MMM d').format(local);
}

String relativeFreshness(DateTime observedAt, DateTime now) {
  final age = now.toUtc().difference(observedAt.toUtc());
  if (age.isNegative || age.inMinutes < 1) return 'Updated just now';
  if (age.inMinutes == 1) return 'Updated 1 min ago';
  if (age.inHours < 1) return 'Updated ${age.inMinutes} min ago';
  if (age.inHours == 1) return 'Updated 1 hour ago';
  return 'Updated ${age.inHours} hours ago';
}

String delayLabel(Duration delay) {
  if (delay.inMinutes <= 0) return 'On time';
  final hours = delay.inMinutes ~/ 60;
  final minutes = delay.inMinutes.remainder(60);
  if (hours == 0) return '${minutes}m late';
  if (minutes == 0) return '${hours}h late';
  return '${hours}h ${minutes}m late';
}
