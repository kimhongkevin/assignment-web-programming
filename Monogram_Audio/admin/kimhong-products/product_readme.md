# Module: Products

This README outlines the coding requirements for managing the product catalog of the audio store.

---

### General Coding Requirements (Applicable to All Product Module Files)

All PHP files within the `products` folder **must** adhere to the following:

1.  **Includes:**
    * `admin_header.php`, `admin_footer.php`, `db_connect.php` (adjust paths as needed).

2.  **Session Management & Authorization:**
    * `session_start();`
    * Implement authorization checks to ensure the user has permission for specific product actions (e.g., `product_add`, `product_edit`, `product_delete`).

3.  **Database Interaction (MySQLi Object-Oriented Style):**
    * Use **prepared statements** for all SQL queries.
    * Handle query results.
    * Close database connection.

4.  **Input Validation & Sanitization:**
    * Validate all form inputs (e.g., numeric for price/quantity, string length).
    * Sanitize input to prevent XSS.

5.  **File Upload Handling:**
    * For product images, handle `$_FILES` array correctly:
        * Check `$_FILES['name']`, `$_FILES['error']`.
        * Validate file type and size.
        * Use `move_uploaded_file()` to securely store images in a dedicated `uploads/products/` directory.
        * Generate unique filenames to prevent conflicts.

6.  **Error Handling & User Feedback:**
    * Provide clear success/error messages.
    * Redirect after POST.
7. ** Database configuration
$host = 'localhost';
$username = 'root';      // Default XAMPP username
$password = '';          // Default XAMPP password (empty)
$database = 'audio_store_db';

---

### File-Specific Requirements

#### 1. `product_add.php`

* **Purpose:** To add a new product to the store's inventory.
* **Database Table:** `products` 
* **Frontend:**
    * An HTML form with input fields for: `Product Name`, `Brand`, `Description`, `Category` (e.g., dropdown), `Unit Price`, `Quantity`, and `Product Image` (file input).
* **Backend (PHP/MySQLi):**
    * Process `POST` request.
    * Validate all input fields.
    * Handle **image upload**: Validate, move uploaded file, store filename and alt text in DB.
    * **SQL `INSERT`:** Insert product data into the `products` table.
    * Redirect to `product_view.php` on success.

#### 2. `product_edit.php`

* **Purpose:** To modify details of an existing product.
* **Database Table:** `products` 
* **Frontend:**
    * An HTML form pre-filled with the existing product's data based on `product_id`.
    * Input fields for all product details, including the ability to view the current image and upload a new one.
* **Backend (PHP/MySQLi):**
    * **On page load:** Get `product_id` from `$_GET`. `SELECT` product data to pre-fill the form.
    * **On form submission (`POST` request):**
        * Collect updated data.
        * Validate input.
        * Handle **image replacement**: If a new image is uploaded, process it (and optionally delete the old one from the server). Update filename in DB.
        * **SQL `UPDATE`:** Update the product record in the `products` table.
        * Redirect to `product_view.php` on success.

#### 3. `product_delete.php`

* **Purpose:** To remove a product from the inventory.
* **Database Table:** `products` 
* **Frontend:** No full page. Triggered by a link/button from `product_view.php`. **Confirmation mechanism is vital.**
* **Backend (PHP/MySQLi):**
    * Get `product_id` from `$_GET` (or `$_POST`).
    * **Confirmation step.**
    * **SQL `DELETE`:** Remove the product record from `products`.
    * **Important:** Also **delete the associated image file** from the server's `uploads/products/` directory to prevent orphaned files.
    * Consider implications for `order_items` (e.g., prevent deletion if product is part of existing orders, or handle through database foreign key constraints like `ON DELETE SET NULL` or `ON DELETE CASCADE` if applicable).
    * Redirect to `product_view.php` on completion.

#### 4. `product_view.php`

* **Purpose:** To display a comprehensive list of all products in inventory.
* **Database Table:** `products` 
* **Frontend:**
    * A responsive HTML table displaying: `Product ID`, `Name`, `Brand`, `Category`, `Price`, `Quantity`, `Image Thumbnail`, and `Status` (e.g., "In Stock", "Low Stock", "Out of Stock").
    * An "Add New Product" button.
    * "Edit" and "Delete" actions for each product row.
* **Backend (PHP/MySQLi):**
    * **SQL `SELECT`:** Retrieve all necessary product data from `products`.
    * Loop through results to populate the table.
    * Implement **low stock alert logic**: `if ($row['quantity'] <= 2)` to display a "Low Stock!" badge or similar indicator.
    * Generate dynamic links for "Edit" (`product_edit.php?id=...`) and "Delete" (`product_delete.php?id=...`).

#### 5. `product_low_stock.php` (Optional, or integrated into `product_view.php`)

* **Purpose:** To specifically display products that are currently low in stock, facilitating reordering.
* **Database Table:** `products` 
* **Frontend:** A table showing only products whose `quantity` is below a predefined threshold (e.g., 2).
* **Backend (PHP/MySQLi):**
    * **SQL `SELECT`:** Fetch products `FROM products WHERE quantity <= [your_threshold]`.
    * Display results in a table.
