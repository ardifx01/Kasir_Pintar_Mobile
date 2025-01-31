# API Documentation for Customer Management

This is the API documentation for managing Customers. It covers the CRUD operations for the Customers resource, including creation, updating, retrieval, and deletion of customer data. The following endpoints are available for interaction with the Customer resource.

## 1. GET `/customers` - Retrieve a list of all customers
- **Authorization**: `viewAny` permission required.
- **Returns**: A list of customers, including store information.

## 2. GET `/customers/store/{storeId}` - Retrieve a list of customers by store ID
- **Authorization**: Only admins can access this endpoint.
- **Returns**: A list of customers for the specified store.

## 3. POST `/customers` - Create a new customer
- **Authorization**: `create` permission required.
- **Input**:
    - `name` (string): Customer's name (required).
    - `number_phone` (string): Customer's phone number (required).
    - `address` (string): Customer's address (required).
    - `email` (string): Customer's email (optional).
    - `store_id` (integer): The ID of the store the customer belongs to (required).
- **Returns**: The created customer data.

## 4. GET `/customers/{customerId}` - Retrieve a specific customer by ID
- **Authorization**: `view` permission required.
- **Returns**: The customer data with the associated store.

## 5. PUT `/customers/{customerId}` - Update a customer's information
- **Authorization**: `update` permission required.
- **Input**:
    - `name` (string): Customer's name (optional).
    - `number_phone` (string): Customer's phone number (optional).
    - `address` (string): Customer's address (optional).
    - `email` (string): Customer's email (optional).
    - `store_id` (integer): The ID of the store the customer belongs to (optional).
- **Returns**: The updated customer data.

## 6. DELETE `/customers/{customerId}` - Delete a customer
- **Authorization**: `delete` permission required.
- **Returns**: A message indicating that the customer has been deleted.

## Error Handling:
- `401 Unauthorized` - If the user is not authorized for the requested action.
- `422 Unprocessable Entity` - If validation fails for the input data.
- `500 Internal Server Error` - In case of unexpected errors.

End of documentation.
