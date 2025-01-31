# Store Controller API Documentation

## **Endpoints**

### **1. Get List of Stores**
**Endpoint**: `/api/stores`  
**Method**: `GET`  
**Description**: Fetch the list of stores based on the user's role.

**Authorization**:
- **Admin**: View all stores.  
- **Owner**: View stores they own.  
- **Staff**: View the store associated with them.

**Responses**:
- **200 OK**: Returns the list of stores.
- **403 Unauthorized**: Access denied.
- **500 Internal Server Error**: Server error.

---

### **2. Get Store Details**
**Endpoint**: `/api/stores/{store}`  
**Method**: `GET`  
**Description**: Retrieve the details of a specific store.

**Authorization**:
- Users must have permission to view the store.

**Responses**:
- **200 OK**: Returns store details.
- **403 Unauthorized**: Access denied.
- **500 Internal Server Error**: Server error.

---

### **3. Create a New Store**
**Endpoint**: `/api/stores`  
**Method**: `POST`  
**Description**: Create a new store.

**Authorization**:
- Only users with the `create` permission for stores can access this endpoint.

**Request Body**:
```json
{
  "name": "string, required",
  "number_phone": "string, required",
  "postal_code": "string, required",
  "address": "string, required",
  "image": "file, optional"
}
```

**Responses**:
- **201 Created**: Store successfully created.
- **403 Unauthorized**: Access denied.
- **422 Validation Error**: Input data is invalid.
- **500 Internal Server Error**: Server error.

---

### **4. Update Store Details**
**Endpoint**: `/api/stores/{store}`  
**Method**: `PUT/PATCH`  
**Description**: Update store information.

**Authorization**:
- Users must have the `update` permission for the store.

**Request Body** (optional):
```json
{
  "name": "string, optional",
  "number_phone": "string, optional",
  "postal_code": "string, optional",
  "address": "string, optional"
}
```

**Responses**:
- **200 OK**: Store successfully updated.
- **403 Unauthorized**: Access denied.
- **422 Validation Error**: Input data is invalid.
- **500 Internal Server Error**: Server error.

---

### **5. Update Store Image**
**Endpoint**: `/api/stores/{store}/image`  
**Method**: `POST`  
**Description**: Update the image of a store.

**Authorization**:
- Users must have the `update` permission for the store.

**Request Body**:
```json
{
  "image": "file, required (jpeg, png, jpg, gif, max 2MB)"
}
```

**Responses**:
- **200 OK**: Image successfully updated.
- **403 Unauthorized**: Access denied.
- **422 Validation Error**: Input data is invalid.
- **500 Internal Server Error**: Server error.

---

### **6. Delete Store**
**Endpoint**: `/api/stores/{store}`  
**Method**: `DELETE`  
**Description**: Delete a store.

**Authorization**:
- Users must have the `delete` permission for the store.

**Responses**:
- **200 OK**: Store successfully deleted.
- **403 Unauthorized**: Access denied.
- **500 Internal Server Error**: Server error.

---

## **Error Handling**
- **403 Unauthorized**: Returned when the user does not have permission to perform the action.
- **422 Validation Error**: Returned when the input data is invalid.
- **500 Internal Server Error**: Returned when there is a system or server error.

---

## **Notes**
- Ensure authentication middleware is applied to protect the endpoints.
- Use `Gate::authorize` to verify user permissions as configured in `AuthServiceProvider`.  

---
