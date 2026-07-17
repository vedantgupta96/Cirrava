# Issue tracker: GitHub

Issues and PRDs for this repository live in GitHub Issues:

- Repository: `vedantgupta96/Cirrava`
- URL: `https://github.com/vedantgupta96/Cirrava`

Use the `gh` CLI for all operations. The local repository tracks `origin/main`, so `gh` can infer the repository; the examples pass `--repo vedantgupta96/Cirrava` explicitly so they remain portable.

## Conventions

- Create: `gh issue create --repo vedantgupta96/Cirrava --title "..." --body "..."`
- Read: `gh issue view <number> --repo vedantgupta96/Cirrava --comments`
- List: `gh issue list --repo vedantgupta96/Cirrava --state open`
- Comment: `gh issue comment <number> --repo vedantgupta96/Cirrava --body "..."`
- Add or remove labels: `gh issue edit <number> --repo vedantgupta96/Cirrava --add-label "..."` or `--remove-label "..."`
- Close: `gh issue close <number> --repo vedantgupta96/Cirrava --comment "..."`

## Pull requests as a triage surface

**PRs as a request surface: no.**

Set this to `yes` if the repository later treats external pull requests as feature requests.

GitHub shares one number space across issues and pull requests. Resolve an ambiguous reference with `gh pr view <number>` and fall back to `gh issue view <number>`.

## Skill operations

When a skill says “publish to the issue tracker,” create a GitHub issue.

When a skill says “fetch the relevant ticket,” run:

`gh issue view <number> --repo vedantgupta96/Cirrava --comments`

## Wayfinding operations

The map is one GitHub issue with child issues as tickets.

- Map label: `wayfinder:map`
- Child labels: `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, or `wayfinder:task`
- Use native GitHub sub-issues and issue dependencies when available.
- Otherwise, use task lists and `Blocked by: #<number>` references.
- Claim work with `gh issue edit <number> --repo vedantgupta96/Cirrava --add-assignee @me`.
- Resolve work by commenting with the result and closing the child issue.
