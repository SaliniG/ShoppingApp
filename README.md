# Shopping App Documentation

## Overview
A Flutter shopping app that allows users to browse products, filter by category, manage a wishlist, add products to a cart, and place orders via a payment screen. The app follows the MVVM pattern, uses the Provider package for state management, and fetches real product data from [FakeStoreAPI](https://fakestoreapi.com).

---

## Features

### Product Listing
- **Responsive Grid View**: Automatically adjusts number of columns based on screen width.
- **Product Card**: Shows product image, name, price, and star rating.
- **Search Bar**: Filter products by name in real time.
- **Category Filter Chips**: Filter products by category — All, Electronics, Jewelery, Men's Clothing, Women's Clothing.
- **Wishlist Heart Icon**: Tap the heart on any card to save/remove from wishlist.

### Product Details Screen
- **Product Image**: Displays the product image at a fixed height.
- **Product Info**: Name, description, price, and star rating with review count.
- **Add to Cart**: Button sized to content with live "X in cart" counter.
- **Wishlist Toggle**: Heart icon in the AppBar to add/remove from wishlist.

### Wishlist / Favorites
- **Wishlist Tab**: Dedicated tab in the bottom navigation bar.
- **Favourites List**: Shows all saved products with name, price, and remove button.
- **Tap to View**: Tap any wishlist item to open its product details screen.

### Cart Management
- **Cart View**: Each item shows image, name, total price, and +/− quantity controls.
- **Total Bar**: Compact bottom bar with total price and Proceed to Checkout button.
- **Empty State**: Displays an empty cart illustration when no items are added.

### Payment Screen *(new)*
- **Order Summary**: Shows the total amount at the top.
- **Payment Methods**: Select from Credit/Debit Card, PayPal, or Cash on Delivery.
- **Card Details Form**: Card number, cardholder name, expiry, and CVV with validation (shown only when card is selected).
- **Place Order Button**: Validates form before proceeding.

### Order Confirmation
- **Success Icon**: Green checkmark in a circle.
- **Amount Paid**: Displayed in a styled card.
- **Continue Shopping**: Returns to the home screen.

---

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

### Model
- `ProductModel` — product data including name, price, image, category, and rating.
- `Cart` — singleton managing cart items as a `Map<ProductModel, int>`.
- `Wishlist` — singleton managing favourites as a `Set<ProductModel>`.

### View
- `HomeScreen`, `ProductDetailsScreen`, `CartScreen`, `WishlistScreen`, `PaymentScreen`, `PlaceOrderScreen`
- `ProductListWidget`, `StarRatingWidget` — reusable UI components.

### ViewModel (Providers)
- `ProductProviderClass` — fetches products, handles search and category filtering.
- `CartProvider` — manages cart item counts and total price.
- `WishlistProvider` — manages wishlist toggle state.
- `ScreenIndexProvider` — tracks the active bottom navigation tab.

---

## Packages

| Package | Purpose |
|---|---|
| `provider` | State management |
| `http` | API network requests |
| `json_annotation` | JSON serialisation |

## API
- **FakeStoreAPI** (`https://fakestoreapi.com/products`) — free public REST API providing real product data with categories and ratings.

---

## Screens

### Home Screen
```
─────────────────────────────────────
  Shopping App
─────────────────────────────────────
  [ Search...                🔍 ]
  [All] [Electronics] [Jewelery] ...
─────────────────────────────────────
  ┌──────────┐  ┌──────────┐
  │  Image   │  │  Image   │
  │ Name     │  │ Name     │
  │ $Price ★ │  │ $Price ★ │
  └──────────┘  └──────────┘
─────────────────────────────────────
```

### Product Details Screen
```
─────────────────────────────────────
  ← Product Details          ♡
─────────────────────────────────────
        [ Product Image ]
  Product Name
  $Price          ★★★★☆ 4.2 (120)
  Product description text...

  [Add to Cart 🛒]   2 in cart
─────────────────────────────────────
```

### Cart Screen
```
─────────────────────────────────────
  My Cart
─────────────────────────────────────
  ┌─────────────────────────────────┐
  │ [Img]  Name          − 2 +     │
  │        $21.98                   │
  └─────────────────────────────────┘
─────────────────────────────────────
  Total            $21.98
        [Proceed to Checkout]
─────────────────────────────────────
```

### Payment Screen
```
─────────────────────────────────────
  ← Payment
─────────────────────────────────────
  Order Total              $21.98
─────────────────────────────────────
  ◉ Credit / Debit Card
  ○ PayPal
  ○ Cash on Delivery

  Card Number: ________________
  Cardholder:  ________________
  Expiry: ______  CVV: ________

              [Place Order]
─────────────────────────────────────
```

### Order Confirmation
```
─────────────────────────────────────

          ✅

      Order Placed!
  Your order has been placed.

  ┌─────────────────────────┐
  │  Amount Paid   $21.98   │
  └─────────────────────────┘

      [Continue Shopping]

─────────────────────────────────────
```

---

## Conclusion
This app demonstrates a clean Flutter architecture with Provider state management, real API integration, and a complete shopping flow from browsing to payment confirmation.
