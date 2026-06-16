# Rails 3.2.22 → Rails 5.2 Upgrade Plan

## Codebase Stats

| Metric | Value |
|--------|-------|
| Ruby LOC (app/config/lib) | ~3,000 |
| Ruby files | 52 |
| ERB views | 94 |
| RABL templates | 6 |
| Test files | 38 |
| Database tables | ~17 |
| Controllers | 15 |
| Models | 18 |

---

## Critical Breaking Changes

### 1. Strong Parameters (largest change)

Rails 4 removed `attr_accessible`. Every `params[:model]` must become `params.require(:model).permit(...)`.

| Category | Count |
|----------|-------|
| Controllers using mass assignment | 11 files |
| Models with `attr_accessible` | 18 files |

**Affected controllers:**
- `app/controllers/vachanas_controller.rb` — `Vachana.new(params[:vachana])`, `@vachana.update_attributes(params[:vachana])`
- `app/controllers/users_controller.rb` — `User.new(params[:user])`, `@user.update_attributes(params[:user])`
- `app/controllers/vachanakaaras_controller.rb` — `@vachanakaara.update_attributes params[:vachanakaara]`
- `app/controllers/review_vachanas_controller.rb` — `ReviewVachana.new(params[:review_vachana])`
- `app/controllers/home_controller.rb` — `@feedback.update_attributes(...)`, `@page.update_attributes(...)`
- `app/controllers/word_lists_controller.rb` — `WordList.new(params[:word_list])`
- `app/controllers/reference_books_controller.rb` — `ReferenceBook.new(params[:reference_book])`
- `app/controllers/user_feedbacks_controller.rb` — `UserFeedback.new(params[:user_feedback])`

**Affected models (remove `attr_accessible`):** All 18 models — user, vachana, vachanakaara, key_word, concord, daily_vachana, user_feedback, keyword_vachana, keyword_vachanakaara, reference_book, concord_item, user_vachanakaara, review_vachana, review_comment, word_list, glossary, static_page, role

### 2. Gems blocking the upgrade

| Gem | Current | Rails 5.2 compatible? | What needed |
|-----|---------|----------------------|-------------|
| `devise` | 3.5.10 | ❌ (`< 5` constraint) | Upgrade to `~> 4.7` |
| `cancan` | 1.6.10 | ❌ Unmaintained | Replace with `cancancan ~> 3.0` |
| `friendly_id` | 4.0.10 | ❌ (`< 4.0` constraint) | Upgrade to `~> 5.2` |
| `mysql2` | 0.3.21 | ❌ | Upgrade to `~> 0.5` |
| `twitter-bootstrap-rails` | 2.2.8 | ❌ | Replace (Bootstrap 2 is very old) |
| `sass-rails` | ~> 3.2.3 | ❌ | `~> 5.0` |
| `coffee-rails` | ~> 3.2.1 | ❌ | `~> 4.2` |
| `responders` gem | 1.1.2 | ❌ (`< 4.2`) | Extracted from Rails 5 core; needs `~> 2.0` |
| `jquery-rails` | 3.1.5 | ❌ (`< 5.0` constraint) | Upgrade to `~> 4.3` |
| `rack-ssl` (implicit) | 1.3.4 | ❌ | Remove (Rails 5 uses `force_ssl` config) |

Other gem compatibility notes:
- `will_paginate` (3.1.6) — should work with Rails 5
- `rabl` (0.14.0) — needs checking for Rails 5 compatibility
- `sunspot_rails` (2.3.0) — needs checking for Rails 5 compatibility
- `public_activity` (1.6.2) — needs Rails 5 compatible version
- `font-awesome-rails` (4.7.0.4) — supports `< 6.0`, check if `< 7` constraint works
- `rubyzip` (1.2.2), `zip-zip` (0.3) — OK, `zip-zip` can be removed
- `zeroclipboard-rails` (0.1.2) — very old, likely needs replacement
- `yaml_db` (0.7.0) — needs Rails 5 compatible version
- `rack-attack` (5.2.0) — needs Rails 5 compatible version

### 3. Rails 3 DSL removed

| Change | Files affected | Count |
|--------|---------------|-------|
| `before_filter` → `before_action` | 8 controllers | 11 instances |
| `after_filter` → `after_action` | — | — |
| `KannadaVachana::Application` → `Rails.application` | 6 config files | — |
| `update_attribute` → `update` | 2 models | 4 instances |
| `redirect_to :back` → `redirect_back(fallback_location: ...)` | 5 controllers | 8 instances |
| `config.secret_token` → `config.secret_key_base` | 1 initializer | — |
| `config.active_record.whitelist_attributes = true` | 3 config files | — |
| `config.active_record.mass_assignment_sanitizer` | 2 config files | — |
| `config.assets.enabled = true` | 1 config file | Remove (always enabled) |
| `config.assets.version = '1.0'` | 1 config file | Remove (deprecated) |
| `config.assets.compress = true` | 1 config file | Replace with css/js_compressor |
| `config.encoding = "utf-8"` | 1 config file | Remove (always UTF-8) |
| `config.active_support.escape_html_entities_in_json = true` | 1 config file | Remove (always true) |
| `config.whiny_nils = true` | 2 config files | Remove (Rails 4) |
| `config.action_dispatch.best_standards_support` | 1 config file | Remove (Rails 4) |
| `config.serve_static_assets = false` → `config.public_file_server.enabled` | 2 config files | — |
| `config.active_record.auto_explain_threshold_in_seconds` | 1 config file | Remove (Rails 4.2) |
| `caches_action` | 1 controller | Removed in Rails 4 (use fragment caching) |
| `match` routes with `:via => :get` | routes.rb | Replace with `get` |
| Gemfile `:assets` group | Gemfile | Remove (Rails 4+ always enables assets) |
| Bundler.require with `:assets` group | config/application.rb | Simplify |
| `protect_from_forgery` (no args) | 1 controller | Add `with: :exception` |

---

## Smaller Changes

| Change | Instances | Files |
|--------|-----------|-------|
| `find_by_*` → `find_by(...)` | 6 | 4 files |
| `respond_to :json` class-level → needs `responders` gem | 3 | API controllers |
| `default_scope order(...)` → `default_scope { order(...) }` | 1 | vachanakaara.rb |
| `confirm: "..."` → `data: { confirm: "..." }` | 2 | 2 views |
| `:disable_with => ...` → `data: { disable_with: ... }` | 4 | 4 views |
| `:remote => true` → `remote: true` | 1 | 1 view |
| `File.exists?` → `File.exist?` | 1 | config/boot.rb |
| `serialize :column` → `serialize :column, Array` (best practice) | 3 | 2 models |
| `validates_uniqueness_of` → `validates ..., uniqueness: true` | 1 | 1 model |
| Hash rocket `:key => value` → `key: value` (cosmetic) | ~80 | ~30 views |
| `respond_with` / `respond_to` in controllers | 15+ | 8 controllers |

---

## Test Suite

- **Framework**: Test::Unit (via `test-unit ~> 3.0` gem)
- **38 test files**: 11 functional tests, 17 unit tests, 10 helper tests
- **Fixtures**: 14 YAML files in `test/fixtures/`
- **Key issue**: `ActionController::TestCase` is deprecated in Rails 5 — should migrate to `ActionDispatch::IntegrationTest`
- **No test DB configured**: `database.yml` has no `development` or `test` sections — both need to be added

---

## Database Setup (New Branch)

Current `config/database.yml` only defines `production`. The new branch needs:

```yaml
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: vachana_concord_development
  pool: 5
  username: vachana_concord
  password: YOUR_DB_PASSWORD

  test:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: vachana_concord_test
  pool: 5
  username: vachana_concord
  password: YOUR_DB_PASSWORD

  production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: vachana_concord
  pool: 5
  username: vachana_concord
  password: YOUR_DB_PASSWORD
```

---

## Phased Implementation Plan

### Phase 1 — Bootstrap (1-2 days)

1. Copy entire codebase to `/home/vachana/rails_apps/concord/releases/vachana-5.2`
2. Update `Gemfile` with Rails 5.2 + all compatible gem versions
3. Run `bundle install` — fix gem compatibility errors iteratively
4. Fix config files to get `rails s` starting:
   - `config/application.rb` — remove Rails 3 settings
   - `config/environments/*` — update deprecated settings
   - `config/initializers/secret_token.rb` → `secret_key_base.rb`
   - `config/routes.rb` — update DSL (`KannadaVachana::Application` → `Rails.application`, `match` → `get`)
   - `config/boot.rb` — `File.exists?` → `File.exist?`
5. Point at production DB (read-only for initial testing) or set up a clone

### Phase 2 — Core Upgrades (2-3 days)

6. Install `cancancan` and update `app/models/ability.rb`
7. Upgrade Devise: generate new config (`rails generate devise:install`), update views
8. Upgrade `friendly_id`: regenerate config
9. Replace `twitter-bootstrap-rails` with a modern Bootstrap gem or plain CSS
10. Add `responders` gem for `respond_to` class-level declarations

### Phase 3 — Strong Parameters (2-3 days)

11. Add `private` `model_params` methods to all 15 controllers
12. Replace all `params[:model]` with `params.require(:model).permit(...)`
13. Remove `attr_accessible` from all 18 models
14. Remove `config.active_record.whitelist_attributes` and `mass_assignment_sanitizer`
15. Test all CRUD flows manually

### Phase 4 — Views and UI (1-2 days)

16. Update old `confirm:` options to `data: { confirm: ... }`
17. Update `:disable_with` to `data: { disable_with: ... }`
18. Update `:remote => true` to `remote: true`
19. (Optional) Migrate hash rocket syntax in views for consistency

### Phase 5 — Polish (1 day)

20. Fix `before_filter` → `before_action` in all 8 controllers
21. Fix `update_attribute` → `update` in models
22. Fix `redirect_to :back` → `redirect_back(fallback_location:)`
23. Fix `find_by_*` → `find_by(...)` in all callers
24. Fix `default_scope order(...)` → `default_scope { order(...) }`
25. Fix `serialize` declarations
26. Fix `validates_uniqueness_of`
27. Configure test DB and run test suite
28. Fix failing tests

### Phase 6 — Deploy for Testing (1 day)

29. Deploy upgraded app to a different URL (e.g., `beta.vachana.sanchaya.net`)
30. Run through all major features manually
31. Monitor logs for deprecation warnings and fix them
32. After verification, swap production URL or deploy upgraded version

---

## Effort Estimate

| Phase | Days | Risk |
|-------|------|------|
| 1 — Bootstrap + bundle | 1-2 | Medium (gem compatibility unknowns) |
| 2 — Core upgrades | 2-3 | High (Devise/cancan/Bootstrap changes) |
| 3 — Strong Parameters | 2-3 | Low (mechanical but tedious) |
| 4 — Views | 1-2 | Low (mostly cosmetic) |
| 5 — Polish + tests | 1 | Low |
| 6 — Deploy + QA | 1 | Medium (runtime issues in production) |
| **Total** | **~8-12 days** | |

---

## Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Devise views break | High | Medium | Generate fresh Devise views and re-apply customizations |
| CanCan → CanCanCan API changes | High | Medium | Check changelog; authorization rules may need rewriting |
| Bootstrap 2 → 4 layout breaks | High | High | Most impactful visual change; plan for layout rework |
| `sunspot_rails` incompatibility | Medium | Low | Check if latest version supports Rails 5 |
| `public_activity` incompatibility | Medium | Low | Check gem compatibility |
| Data loss during testing | Critical | Low | Always run on a database clone, never production directly |
| Ruby 2.7 incompatibility with Rails 5.2 | Low | Low | Rails 5.2 supports Ruby 2.5+, and 2.7.6 is tested |
| Deployment (Capistrano) | Low | Medium | Update Capistrano if needed; test deploy flow separately |
