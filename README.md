# Shopping App Documentation

## Overview
This document provides a comprehensive guide to the Shopping App's features, architecture, and implementation details. The app allows users to browse products, view product details, add products to a cart, and place orders. The application follows the MVVM (Model-View-ViewModel) pattern for architecture, utilizes the Provider package for state management, and interacts with a mock API using the HTTP package.

## Features
### Product Listing
- **Grid View**: Displays a list of products in a grid format.
- **Product Details**: Each product entry shows an image, name, and price.
- **Search Bar**: Located at the top of the screen, enabling users to filter products by name.

### Product Details Screen
- **Larger Image**: Displays a larger image of the selected product.
- **Product Information**: Shows the product name, description, and price.
- **Add to Cart Button**: Allows the user to add the product to their cart.

### Cart Management
- **Cart View**: Displays a list of products added to the cart, each showing an image, name, price, and quantity.
- **Total Price**: Shows the total price of all products in the cart.
- **Place Order Button**: Allows the user to place an order for the products in the cart.
- **Order Confirmation**: Displays a confirmation message when an order is placed and shows a summary of the order, including products and the total price.

## Architecture
The app is structured following the MVVM pattern:

### Model
- Handles data definitions and business logic.
- Interacts with the network layer to fetch data from the mock API.

### View
- UI components that display the data and capture user interactions.
- Consists of screens for product listing, product details, and cart management.

### ViewModel
- Acts as a bridge between the Model and View.
- Manages the state of the UI and handles user inputs.
- Utilizes the Provider package for state management.

### State Management
- **Provider Package**: Used to manage the state across the app, ensuring UI components react to data changes.

## Packages and Utilities
- **UI Package**: Contains all the UI components and screens.
- **Network Package**: Manages API calls using the HTTP package and handles responses.
- **Utils Package**: Contains utility functions and constants used throughout the app.
- **Data Package**: Defines data models and handles data-related operations.

### Mock API
- **Mock.io**: Used to create and interact with a mock API for fetching product data.

## Implementation Details

### Singleton Class for Cart
- A singleton class is used to manage the cart, ensuring a single instance of the cart is maintained throughout the app.
- The class provides methods to add, remove, and update products in the cart and to calculate the total price.

### State Management
- The Provider package is used to update the UI in response to changes in the cart's state.
- The ViewModel listens to changes in the cart and updates the UI accordingly.

### HTTP Package for API Interaction
- The HTTP package is used to make network requests to the mock API.
- Data fetched from the API is processed and provided to the ViewModel.

## User Interface

### Product Listing Screen
```plaintext
-----------------------------------------
| Search Bar                           |
-----------------------------------------
| Product Image | Product Image |      |
| Product Name  | Product Name  |      |
| Product Price | Product Price |      |
-----------------------------------------
```

### Product Details Screen
```plaintext
-----------------------------------------
| Large Product Image                   |
-----------------------------------------
| Product Name                          |
| Product Description                   |
| Product Price                         |
| [Add to Cart] Button                  |
-----------------------------------------
```

### Cart Screen
```plaintext
-----------------------------------------
| Cart Item Image | Cart Item Name      |
| Cart Item Price | Quantity            |
-----------------------------------------
| Total Price                           |
| [Place Order] Button                  |
-----------------------------------------
| Confirmation Message                  |
| Order Summary                         |
-----------------------------------------
```

## Conclusion
This documentation outlines the key features and architectural details of the Shopping App. By following the MVVM pattern and using the Provider package for state management, the app ensures a clean separation of concerns and a responsive UI. The use of mock API via Mock.io facilitates easy testing and development.
