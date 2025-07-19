# Module: Sales

This README outlines the coding requirements for managing customer orders and viewing sales history.

---

### General Coding Requirements (Applicable to All Sales Module Files)

All PHP files within the `sales` folder **must** adhere to the following:

1.  **Includes:**
    * `admin_header.php`, `admin_footer.php`, `db_connect.php` (adjust paths as needed).

2.  **Session Management & Authorization:**
    * `session_start();`
    * Implement authorization checks to ensure the user has permission to view/manage sales orders.

3.  **Database Interaction (MySQLi Object-Oriented Style):**
    * Use **prepared statements** for all SQL queries.
    * Handle query results.
    * Close database connection.

4.  **Input Validation & Sanitization:**
    * For any filters (e.g., date ranges, customer ID), validate and sanitize input.

5.  **Order Status Management:**
    * Handle updates to the `status` column in the `orders` table .

6.  **Error Handling & User Feedback:**
    * Provide clear success/error messages.
    * Redirect after POST.

---

### File-Specific Requirements

#### 1. `orders_view.php`

* **Purpose:** To view and manage current or pending sales orders, allowing status updates.
* **Database Tables:** `orders` , `customers` , `order_items` , `products` .
* **Frontend:**
    * A table listing orders, showing key details: `Order ID`, `Customer Name`, `Order Date`, `Total Price`, `Status`.
    * Actions for each order: "View Details" (e.g., link to `order_details.php` or trigger a modal), "Update Status" buttons (e.g., "Mark as Paid", "Mark as Delivered").
* **Backend (PHP/MySQLi):**
    * **SQL `SELECT`:** Fetch orders. Typically filtered by `status = 'pending'` or other active statuses.
    * **`JOIN`** with the `customers` table to display customer names.
    * Implement logic to update the `status` column of an order when corresponding buttons are clicked.
    * For "View Details", prepare `order_id` to be passed to an `order_details.php` page or used to fetch `order_items` for a modal.

#### 2. `orders_history.php`

* **Purpose:** To view a comprehensive history of all sales orders, including completed and cancelled ones.
* **Database Tables:** `orders` , `customers` , `order_items` , `products` .
* **Frontend:**
    * A table displaying all orders.
    * May include filtering options (e.g., by date range, customer, status) and search functionality.
* **Backend (PHP/MySQLi):**
    * **SQL `SELECT`:** Retrieve all orders from the `orders` table.
    * **`JOIN`** with `customers` and `order_items` as needed for display.
    * Implement filtering logic based on user input for search/filter functionalities.