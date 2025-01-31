
# SellingTransactionController API Documentation

## Endpoints

### Selling Transactions

#### 1. `GET /transactions/selling`
- **Description**: Retrieve all selling transactions.
- **Authorization**: Requires authorization for `viewAny` ability.
- **Query Params**: None
- **Response**:
  - 200: List of selling transactions.
  - 403: Unauthorized.
  - 500: Server error.

#### 2. `POST /transactions/selling`
- **Description**: Create a new selling transaction.
- **Authorization**: Requires authorization for `create` ability.
- **Request Body**:
  ```json
  {
    "store_id": "integer|required",
    "total_discount": "numeric|required|min:0",
    "is_debt": "boolean|required",
    "description": "string|nullable",
    "payment_method": "string|required",
    "total_amount": "numeric|required|min:0",
    "amount_paid": "numeric|required|min:0",
    "change_amount": "numeric|required|min:0",
    "transaction_status": "string|required",
    "sellingDetailTransactions": [
      {
        "product_id": "integer|required|exists:products,id",
        "quantity": "integer|required|min:1",
        "item_discount": "numeric|required|min:0",
        "subtotal": "numeric|required|min:0"
      }
    ],
    "customer_id": "integer|nullable|exists:customers,id",
    "due_date": "date|nullable"
  }
  ```
- **Response**:
  - 201: Selling transaction created successfully.
  - 422: Validation errors.
  - 403: Unauthorized.
  - 500: Server error.

#### 3. `GET /transactions/selling/{sellingTransaction}`
- **Description**: Retrieve a specific selling transaction by ID.
- **Authorization**: Requires authorization for `view` ability.
- **Path Parameters**:
  - `sellingTransaction`: ID of the selling transaction.
- **Response**:
  - 200: Selling transaction details.
  - 403: Unauthorized.
  - 500: Server error.

#### 4. `DELETE /transactions/selling/{sellingTransaction}`
- **Description**: Delete a specific selling transaction by ID.
- **Authorization**: Requires authorization for `delete` ability.
- **Path Parameters**:
  - `sellingTransaction`: ID of the selling transaction.
- **Response**:
  - 200: Transaction deleted successfully.
  - 403: Unauthorized.
  - 500: Server error.

### Notes
- Updating a selling transaction is **not allowed**. The API returns a 405 response for update requests.
- Transactions involving debt will automatically create a receivable record if `is_debt` is set to true.
