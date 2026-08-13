# Refactoring: Professional Test Setup & Admin Products Controller (v1)

**Date:** August 13, 2026  
**Branch:** `refactor/spec-admin-products`  
**Test Results:** 56 examples, 0 failures ✅

## Overview

This refactoring modernizes the Rails 8.1 test infrastructure and implements a professional API controller architecture for product management. Key improvements include:

- **Unified RSpec configuration** with proper DatabaseCleaner integration
- **Admin authorization concern** (reusable across controllers)
- **Product serializer** for consistent JSON response formatting
- **Admin::V1::ProductsController** with CRUD operations and authorization
- **Comprehensive test suite** for all new components
- **Rails deprecation fixes** (fixture_path → fixture_paths)

---

## Changes by File

### 1. **spec/rails_helper.rb**

**Problem:** Multiple `RSpec.configure` blocks, inconsistent fixture configuration, deprecation warnings.

**Solution:**
- ✅ Merged three separate `RSpec.configure` blocks into one
- ✅ Changed `config.fixture_path` (singular) → `config.fixture_paths` (array, Rails 7.1+)
- ✅ Disabled `use_transactional_fixtures` to prevent DatabaseCleaner conflicts
- ✅ Consolidated all DatabaseCleaner hooks into single config block

**Impact:** Cleaner, more maintainable test setup; eliminates deprecation warnings.

---

### 2. **spec/models/user_spec.rb**

**Problem:** Shoulda-matcher `validate_uniqueness_of(:email).case_insensitive` failed because the matcher couldn't detect the validation's actual scope (`:provider` from DeviseTokenAuth).

**Solution:**
- ✅ Replaced shoulda-matcher with explicit validation test
- ✅ Tests case-insensitive uniqueness directly: `'TIM.MURRAY@RUNTE.EXAMPLE'` matches `'tim.murray@runte.example'`

**Before:**
```ruby
subject { build(:user) }
it { should validate_uniqueness_of(:email).case_insensitive }
```

**After:**
```ruby
it 'valida unicidade do email sem diferenciar maiúsculas/minúsculas' do
  create(:user, email: 'tim.murray@runte.example')
  user = build(:user, email: 'TIM.MURRAY@RUNTE.EXAMPLE')
  expect(user).not_to be_valid
  expect(user.errors[:email]).to include('has already been taken')
end
```

**Impact:** More explicit, maintainable tests; no matcher ambiguity.

---

### 3. **config/routes.rb**

**Problem:** Reference to `StaticTokenAuth` raised `uninitialized constant` error because the class was in the `Middlewares` module.

**Solution:**
- ✅ Changed `Sidekiq::Web.use StaticTokenAuth` → `Sidekiq::Web.use Middlewares::StaticTokenAuth`

**Impact:** Proper constant resolution; Sidekiq Web UI middleware loads correctly.

---

### 4. **app/controllers/concerns/admin_authorization.rb** _(NEW)_

**Purpose:** Centralized authorization logic for admin-only endpoints.

**Features:**
- Reusable module included in controllers requiring admin access
- Reads `uid` header from request (DeviseTokenAuth token extraction)
- Returns `403 Forbidden` for non-admin users
- Clean separation of concerns

**Usage:**
```ruby
module Admin
  module V1
    class SomeController < ApplicationController
      include AdminAuthorization
      before_action :authorize_admin_from_header!
      # ... controller actions
    end
  end
end
```

**Tests:** spec/controllers/concerns/admin_authorization_spec.rb

---

### 5. **app/serializers/product_serializer.rb** _(NEW)_

**Purpose:** Consistent JSON serialization for Product responses.

**Features:**
- Single responsibility: transforms Product model → JSON
- Returns essential fields: id, name, description, price, status, featured
- Supports both single and collection serialization
- Easy to extend for future fields

**Usage:**
```ruby
# Single product
ProductSerializer.new(@product).as_json

# Collection
products.map { |p| ProductSerializer.new(p).as_json }
```

**Tests:** spec/serializers/product_serializer_spec.rb

---

### 6. **app/controllers/admin/v1/products_controller.rb** _(NEW)_

**Purpose:** RESTful API controller for product management (admin only).

**Features:**
- **index** — List all products
- **show** — Fetch single product by ID
- **create** — Create new product with categories and image
- **update** — Update product properties
- **destroy** — Delete product (returns 204 No Content)
- Authorization via `AdminAuthorization` concern
- Image attachment before save (satisfies presence validation)
- Category association management

**Response Format:**
```json
{
  "data": {
    "id": 1,
    "name": "Game Title",
    "description": "...",
    "price": "199.90",
    "status": "available",
    "featured": true
  }
}
```

**Tests:** spec/requests/admin/v1/products_spec.rb (7 scenarios)

---

## New Test Files

### spec/controllers/concerns/admin_authorization_spec.rb
- ✅ Admin user access allowed
- ✅ Non-admin user returns 403 Forbidden

### spec/serializers/product_serializer_spec.rb
- ✅ All attributes serialized correctly
- ✅ Price conversion to string

---

## Test Results

**Full Suite:**
```
bundle exec rspec
56 examples, 0 failures ✅
Finished in 1.61 seconds
```

**Request Specs (products):**
```
Admin::V1::Products
  GET /admin/v1/products — 2 scenarios (admin access, forbidden)
  GET /admin/v1/products/:id — 1 scenario
  POST /admin/v1/products — 2 scenarios (valid/invalid params)
  PATCH /admin/v1/products/:id — 1 scenario
  DELETE /admin/v1/products/:id — 1 scenario

7 scenarios, 0 failures ✅
```

**Unit Tests (concern + serializer):**
```
AdminAuthorization — 2 examples, 0 failures ✅
ProductSerializer — 1 example, 0 failures ✅
```

---

## Instructions to Merge

1. **Authenticate with GitHub:**
   ```bash
   gh auth login --web
   ```

2. **Create remote repository and push:**
   ```bash
   gh repo create manoelbertin/store_pulse_api --public --source=. --remote=origin --push
   ```

3. **Open Pull Request:**
   ```bash
   gh pr create \
     --title "Refactor: professional test setup & admin products controller" \
     --body "Modernize Rails 8.1 test infrastructure and implement admin API architecture" \
     --base main
   ```

---

## Future Improvements

- [ ] Extract common authorization patterns into policy classes (Pundit)
- [ ] Add request/response logging middleware
- [ ] Implement pagination for product index
- [ ] Add filtering/searching capabilities
- [ ] Create OpenAPI/Swagger documentation
- [ ] Performance benchmarks for bulk operations
- [ ] Admin dashboard analytics endpoints

---

## Related Files

- spec/rails_helper.rb — RSpec configuration
- spec/spec_helper.rb — RSpec expectations/mocks config
- app/models/user.rb — User model with profile enum
- app/models/product.rb — Product model with validations

---

**Status:** Ready for review and merge ✅
