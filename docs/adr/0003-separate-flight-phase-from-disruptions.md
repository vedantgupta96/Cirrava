# Separate Flight Phase from disruption conditions

Cirrava models one Flight Phase separately from independent Disruption Conditions because real flights can occupy both at once, such as boarding while delayed. Provider-specific status strings are normalized into this composite model rather than exposed or collapsed into one enum. This adds explicit state-combination rules but prevents contradictory status transitions and supports clearer presentation, events, and notifications.
