---
name: pr-description
description: Write a pull request description using the standard template (Summary, Changes, How to test, Screenshots, Reviewer notes, Checklist, linked issue). Use when the user asks to write, draft or fill in a PR description, open a PR, or create a pull_request_template.md.
---

# Pull request description

Write the description from the actual branch diff, not from memory.

## Steps

1. Find the base branch (usually `main`) and read the change set:
   - `git log --oneline <base>..HEAD`
   - `git diff --stat <base>...HEAD`, then read the relevant parts of `git diff <base>...HEAD`
2. Fill in the template below. Rules:
   - **Summary** explains *why*, in 1–3 sentences. The diff already shows *what*.
   - **Changes** is a short bullet list of meaningful changes, not every file.
   - **How to test** gives concrete, reproducible steps and commands (e.g. `php artisan test --filter=...`, a `curl` check, pages to open).
   - **Screenshots** only for UI changes. Suggest dragging images into the GitHub PR page rather than committing them to the repo. Delete the section if there's no UI change.
   - **Reviewer notes** lists risky areas, known issues and follow-ups honestly, including unresolved review findings.
   - **Checklist**: tick only items you actually verified. Leave the rest unticked.
   - Link issues with `Closes #N` / `Fixes #N` if one exists. Otherwise delete the line, and never invent an issue number.
   - Keep it short: under about 150 words of prose for a focused PR.
3. Show the draft to the user before creating the PR. Only run `gh pr create` if the user asks and `gh` is installed.

## Template

```markdown
## Summary
<!-- What and WHY, 1–3 sentences -->

## Changes
-

## How to test
1.

## Screenshots
<!-- UI changes only -->

## Reviewer notes
<!-- Risky areas, things to look at closely, known follow-ups -->

## Checklist
- [ ] Tests added/updated and passing
- [ ] Migrations are reversible
- [ ] No secrets or `.env` changes committed

Closes #
```

## Repo template file

If the user wants GitHub to pre-fill every PR, save the template as `.github/pull_request_template.md` (the repo root and `docs/` also work). For several templates, put them in `.github/PULL_REQUEST_TEMPLATE/` and select one with the `?template=<name>.md` URL parameter.
