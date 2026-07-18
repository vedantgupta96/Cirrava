# Use direct platform push services

Cirrava sends iPhone notification alerts and ActivityKit operations directly through Apple Push Notification service. It sends Android notification alerts, promoted Live Updates, and ongoing-notification updates through Firebase Cloud Messaging. No third-party notification intermediary is part of v1.

The NestJS worker owns provider adapters, token-based credentials, retry classification, delivery-attempt records, token invalidation, and lifecycle termination. Notification Decisions and payload intent remain provider-neutral; platform adapters translate them only at the delivery boundary. Durable jobs and the transactional outbox remain the source of delivery work.

This decision supersedes the technical-architecture baseline's use of FCM as the cross-platform route for Apple messages. Direct APNs is already required for Cirrava's ActivityKit lifecycle and avoids adding FCM as a second Apple delivery boundary. FCM remains the native Android route and currently has no service charge. Cirrava accepts the cost of maintaining two small adapters in exchange for owning its delivery behavior, credentials, and failure diagnostics without another vendor dependency.
