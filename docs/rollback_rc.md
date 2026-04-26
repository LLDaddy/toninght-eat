# RC Rollback Guide

## Target
Rollback from `0.1.1-rc.1+2` to the previous stable baseline.

## Preconditions
- Keep previous stable artifact package and checksum archive.
- Confirm database migrations are backward-compatible before app rollback.

## Steps
1. Stop rollout of current RC package in your release channel.
2. Re-enable previous stable release in your distribution console.
3. Verify mobile clients can still log in and fetch menus with current backend schema.
4. Clear RC-specific release notes/channels and communicate rollback notice.
5. Open a hotfix branch from previous stable commit and re-run CI gates before re-release.

## Verification Checklist
- Login and onboarding still functional.
- Today menu generation and recipe detail open normally.
- Favorites list read/write still works.
- No crash spikes or auth errors after rollback.
