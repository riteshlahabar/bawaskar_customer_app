# Bawaskar Customer App

Flutter customer eCommerce app using GetX modules.

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

For live server:

```bash
flutter run --dart-define=API_BASE_URL=https://drbawasakar.turnkeyinfotech.live/api/v1
```

## Main Structure

- `lib/app/config` API config
- `lib/app/data/models` models
- `lib/app/data/services` API, auth storage, cart service
- `lib/app/routes` GetX routes
- `lib/app/theme` green Bawaskar theme
- `lib/app/widgets` shared UI widgets
- `lib/modules/auth` login, signup, OTP
- `lib/modules/home` eCommerce front view
- `lib/modules/catalog` categories/products
- `lib/modules/product_detail` product detail
- `lib/modules/cart` cart
- `lib/modules/checkout` checkout/order placement
- `lib/modules/orders` order history
- `lib/modules/profile` profile/settings
- `lib/modules/addresses` address form
- `lib/modules/support` support ticket

## Notes

- Mobile OTP login uses the current Laravel customer OTP endpoints.
- Email login screen is created, but Laravel backend must expose `/auth/customer/login` for it to work.
- Checkout sends address/payment details inside `notes` because the current Laravel customer order API accepts `items` and `notes` only.
