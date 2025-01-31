# Staff API Documentation

## Base URL
All endpoints are prefixed with `/staffs`.

---

## Endpoints

### 1. Get All Staff
**GET** `/`

**Description:** Retrieve all staff. If the authenticated user belongs to a store, only staff from that store will be retrieved.

**Authorization:** Requires `viewAny` permission on `Staff`.

#### Response
- **200 OK:**
  ```json
  [
      {
          "id": 1,
          "user": { "id": 1, "name": "John Doe", ... },
          "store": { "id": 1, "name": "Store A", ... },
          "role": "manager",
          ...
      }
  ]
  ```
- **403 Forbidden:** Unauthorized access.
- **500 Internal Server Error:** Server error details.

---

### 2. Get Staff by Store
**GET** `/store/{storeId}`

**Description:** Retrieve all staff from a specific store.

**Authorization:** Requires `viewAny` permission on `Staff`. Users must be an admin or own the store.

#### Parameters
- **Path Parameter:**
  - `storeId`: The ID of the store.

#### Response
- **200 OK:**
  ```json
  [
      {
          "id": 1,
          "user": { "id": 1, "name": "John Doe", ... },
          "store": { "id": 1, "name": "Store A", ... },
          "role": "manager",
          ...
      }
  ]
  ```
- **403 Forbidden:** Unauthorized access.
- **500 Internal Server Error:** Server error details.

---

### 3. Create a Staff
**POST** `/`

**Description:** Add a new staff.

**Authorization:** Requires `create` permission on `Staff`.

#### Request Body
- `name` (string, required): Name of the staff.
- `email` (string, required): Email address of the staff. Must be unique.
- `password` (string, required): Password for the staff account. Minimum 6 characters.
- `number_phone` (string, required): Staff’s phone number.
- `store_id` (integer, required): ID of the store the staff belongs to.
- `role` (string, required): Role of the staff.

#### Response
- **201 Created:**
  ```json
  {
      "id": 1,
      "store_id": 1,
      "user_id": 1,
      "role": "manager",
      ...
  }
  ```
- **422 Unprocessable Entity:** Validation errors.
- **403 Forbidden:** Unauthorized access.
- **500 Internal Server Error:** Server error details.

---

### 4. Get a Staff by ID
**GET** `/{staff}`

**Description:** Retrieve details of a specific staff by ID.

**Authorization:** Requires `view` permission on the specified `Staff`.

#### Response
- **200 OK:**
  ```json
  {
      "id": 1,
      "user": { "id": 1, "name": "John Doe", ... },
      "store": { "id": 1, "name": "Store A", ... },
      "role": "manager",
      ...
  }
  ```
- **403 Forbidden:** Unauthorized access.
- **500 Internal Server Error:** Server error details.

---

### 5. Update a Staff
**PUT** `/{staff}`

**Description:** Update details of a specific staff.

**Authorization:** Requires `update` permission on the specified `Staff`.

#### Request Body
- `name` (string, optional): Updated name of the staff.
- `email` (string, optional): Updated email address. Must be unique.
- `password` (string, optional): Updated password. Minimum 6 characters.
- `number_phone` (string, optional): Updated phone number.
- `store_id` (integer, optional): Updated store ID. Must exist.
- `role` (string, optional): Updated role.

#### Response
- **200 OK:**
  ```json
  {
      "id": 1,
      "store_id": 1,
      "user_id": 1,
      "role": "manager",
      ...
  }
  ```
- **422 Unprocessable Entity:** Validation errors.
- **403 Forbidden:** Unauthorized access.
- **500 Internal Server Error:** Server error details.

---

### 6. Delete a Staff
**DELETE** `/{staff}`

**Description:** Delete a staff and its associated user account.

**Authorization:** Requires `delete` permission on the specified `Staff`.

#### Response
- **200 OK:**
  ```json
  {
      "message": "Staff and user deleted successfully"
  }
  ```
- **403 Forbidden:** Unauthorized access.
- **500 Internal Server Error:** Server error details.

---
