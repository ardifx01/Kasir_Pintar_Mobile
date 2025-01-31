
# API Documentation for Supplier Management

This is the API documentation for managing Suppliers. It covers the CRUD operations for the Suppliers resource, including creation, updating, retrieval, and deletion of supplier data.

## 1. GET `/suppliers` - Retrieve a list of all suppliers
- **Authorization**: `viewAny` permission required.
- **Returns**: A list of suppliers, including store information.

## 2. GET `/suppliers/store/{storeId}` - Retrieve a list of suppliers by store ID
- **Authorization**: Only admins can access this endpoint.
- **Returns**: A list of suppliers for the specified store.

## 3. POST `/suppliers` - Create a new supplier
- **Authorization**: `create` permission required.
- **Input**:
    - `name` (string): Supplier's name (required).
    - `number_phone` (string): Supplier's phone number (required).
    - `address` (string): Supplier's address (required).
    - `email` (string): Supplier's email (optional).
    - `store_id` (integer): The ID of the store the supplier belongs to (required).
- **Returns**: The created supplier data.

## 4. GET `/suppliers/{supplierId}` - Retrieve a specific supplier by ID
- **Authorization**: `view` permission required. The user must be an admin or own the store that the supplier belongs to.
- **Returns**: The supplier data with the associated store.

## 5. PUT `/suppliers/{supplierId}` - Update a supplier's information
- **Authorization**: `update` permission required.
- **Input**:
    - `name` (string): Supplier's name (optional).
    - `number_phone` (string): Supplier's phone number (optional).
    - `address` (string): Supplier's address (optional).
    - `email` (string): Supplier's email (optional).
    - `store_id` (integer): The ID of the store the supplier belongs to (optional).
- **Returns**: The updated supplier data.

## 6. DELETE `/suppliers/{supplierId}` - Delete a supplier
- **Authorization**: `delete` permission required.
- **Returns**: A message indicating that the supplier has been deleted.

## Error Handling:
- `401 Unauthorized` - If the user is not authorized for the requested action.
- `422 Unprocessable Entity` - If validation fails for the input data.
- `500 Internal Server Error` - In case of unexpected errors.

End of documentation.
