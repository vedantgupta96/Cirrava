# Use contract-first REST and OpenAPI

Cirrava uses a versioned REST API described by OpenAPI for the mobile/backend boundary. Public contract changes begin in the OpenAPI document, generated Dart clients and TypeScript types are refreshed through approved commands, and the API remains compatible with supported released mobile versions. Predictable access patterns and generated contracts outweigh GraphQL's query flexibility for v1, while keeping provider-specific fields out of the public API.
