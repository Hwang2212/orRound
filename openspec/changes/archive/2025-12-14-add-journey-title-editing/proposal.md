# Proposal: Add Journey Title Editing

## Overview

Enable users to edit journey titles on completed journeys so they can record memories and personalize their travel history.

## Why

Currently, journeys are only identified by timestamps, making it difficult for users to quickly recognize and recall specific trips. Users need a way to personalize their journey history with meaningful names that help them remember the purpose, destination, or highlights of each trip. This feature enables better journey organization and memory recording.

## Motivation

Currently, journeys are only identified by timestamps, making it difficult for users to quickly recognize and recall specific trips. Adding editable titles allows users to:

- Personalize their journey history with memorable names
- Quickly identify specific trips in their journey list
- Record the purpose or highlights of each journey

## Scope

This change modifies two existing capabilities:

- **journey-storage**: Add title field to journeys table and Journey model
- **journey-detail**: Add title editing UI and functionality for completed journeys only

## User Impact

- Journeys are saved with empty titles by default when tracking sessions finish
- On the detail page, empty/null titles display as auto-generated text (e.g., "Journey on Dec 15, 2025" or "Travelling on Dec 15, 2025")
- Users can tap to edit the displayed title, which saves it to the database
- If users clear a title to empty, it reverts to showing auto-generated text (not saved to DB)
- Long titles will be displayed with ellipsis in UI

## Technical Approach

1. Add nullable `title` column to journeys table (defaults to NULL)
2. Update Journey model to include optional title field
3. Add title display logic in detail page that generates random titles for display when title is null/empty
4. Add title editing UI to journey detail page (tap-to-edit or edit icon)
5. Save titles to database only when user explicitly edits them
6. Update journey list display to show custom titles or auto-generated text

## Alternatives Considered

- **Pre-fill titles during tracking**: Rejected because users may not know the journey purpose at start
- **AI-generated titles based on route**: Rejected as out of scope for offline-first MVP
- **Edit during tracking**: Rejected to keep scope focused on completed journeys

## Dependencies

None - this is a self-contained feature addition.

## Risks

- Database migration must handle existing journeys (auto-generate titles)
- UI must handle very long titles gracefully
- Need to ensure title persistence works offline

## Success Criteria

- Users can edit titles on completed journeys
- Null/empty titles display as auto-generated text with random variations
- Existing journeys display auto-generated titles until edited
- Titles are only saved to database when explicitly set by users
- All changes work offline-first
- No breaking changes to existing functionality
