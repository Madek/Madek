# PR #895 Required Changes Checklist

Source PR: [Madek/Madek#895](https://github.com/Madek/Madek/pull/895)

## Required Changes

- [x] Remove unnecessary migration guards (`foreign_key_exists?`, `column_exists?`) in `api-v2/datalayer/db/migrate/076_rename_groups_updated_by_user_id_to_updator_id.rb` while keeping the intended rename/FK semantics.
- [x] Revert attribute-ordering-only changes in `admin-webapp/app/views/groups/show.html.haml`; keep behavior aligned with existing view patterns.
- [x] Remove explicit `creator_id` / `updator_id` key-forcing wrappers in `api-v2/src/madek/api/resources/groups.clj` and rely on base query + nullable DB fields.
- [x] Keep `api-v2/datalayer/db/structure.sql` focused on intentional schema deltas only (avoid environment-specific dump noise where possible).

## PR Feedback Checklist

- [x] Datalayer feedback: remove `foreign_key_exists?`/`column_exists?` checks from migration `076_rename_groups_updated_by_user_id_to_updator_id.rb`.
- [x] Datalayer feedback: ensure `db/structure.sql` keeps only intended schema changes and avoid accidental dump-token churn (`\restrict`, dump header noise) if not required.
- [x] Admin-webapp feedback: remove the non-required attribute ordering adjustment in `app/views/groups/show.html.haml`.
- [x] API-v2 feedback: remove `assoc nil` key-forcing patterns for `creator_id` and `updator_id` in `src/madek/api/resources/groups.clj`.
- [x] API-v2 feedback: verify list/index output still includes fields via base `:*` query behavior and nullable DB columns.

## Validation Checklist

- [x] Run `api-v2` specs from `api-v2/datalayer` context:
  - [x] `spec/resources/groups/create_group_spec.rb`
  - [x] `spec/resources/groups/patch_group_spec.rb`
  - [x] `spec/resources/groups/index_spec.rb`
  - [x] `spec/authentication/fields_selection_spec.rb`
- [x] Ensure test DB is migrated before running specs (`db/migrate/076_rename_groups_updated_by_user_id_to_updator_id.rb` is currently pending).
- [x] Verify docs at `api-v2/resources/md/admin-groups-put.md` match final payload keys (`creator_id`, `updator_id`).
- [x] Confirm no extra UI-only diffs remain in `admin-webapp/app/views/groups/show.html.haml`.

## Out Of Scope

- [x] Do not introduce unrelated refactors outside files touched by PR #895 review comments.
