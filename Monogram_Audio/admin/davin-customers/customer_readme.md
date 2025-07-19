# Project: Audio Store Admin Panel

## Module: Customers

This section outlines the coding requirements and best practices for developing the "Customers" module of the admin panel. This module is responsible for managing customer records within the database.

---

### General Coding Requirements (Applicable to All Customer Module Files)

All PHP files within the `customers` folder **must** adhere to the following:

1.  **Includes:**
    * Start each file by including the `admin_header.php` for consistent layout:
        ```php
        <?php include '../admin_header.php'; ?>
        ```
    * Include the `admin_footer.php` at the end of the file:
        ```php
        <?php include '../admin_footer.php'; ?>
        ```
    * Include the database connection file (`db_connect.php`). Ensure the path is correct based on your project structure (e.g., `../db_connect.php` if `db_connect.php` is in the parent directory).
        ```php
        <?php include '../db_connect.php'; ?>
        ```

2.  **Session Management:**
    * Initiate session at the very beginning (after `<?php` tag) to manage user login and authorization:
        ```php
        <?php session_start(); ?>
        ```

3.  **Authentication & Authorization:**
    * Implement checks to ensure the user is logged in and possesses the necessary permissions to access customer management functionalities. Redirect to the login page (`login.php`) if unauthorized.

4.  **Database Interaction (MySQLi Object-Oriented Style):**
    * Always use **prepared statements** (`prepare()`, `bind_param()`, `execute()`) for all SQL queries (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) involving user input to prevent SQL injection vulnerabilities.
    * Handle query results using methods like `get_result()`, `fetch_assoc()`.
    * Ensure database connection (`$conn->close();`) is closed at the end of the script.

5.  **Input Validation & Sanitization:**
    * Validate all user input (`$_POST`, `$_GET`) for correct data types, length, and format.
    * Sanitize input using functions like `htmlspecialchars()`, `trim()`, `stripslashes()` before using it in queries or displaying it on the page to prevent XSS attacks.

6.  **Password Hashing:**
    * When storing or updating customer passwords, **always use `password_hash()`** (e.g., `PASSWORD_DEFAULT` algorithm) and verify with `password_verify()`. **Never store plain text or MD5 passwords.** (Note: Your `users` table schema shows MD5 for user passwords. It's highly recommended to upgrade to `password_hash()` for better security.)

7.  **Error Handling & User Feedback:**
    * Implement basic error checking for database operations.
    * Provide clear and user-friendly success or error messages (e.g., using Bootstrap alerts) after any action.
    * Redirect users using `header('Location: ...'); exit();` after successful POST requests to prevent form re-submission.

8. Database configuration
$host = 'localhost';
$username = 'root';      // Default XAMPP username
$password = '';          // Default XAMPP password (empty)
$database = 'audio_store_db';

---

### File-Specific Requirements

#### 1. `customer_add.php`

* **Purpose:** To provide a form for administrators to add new customer records to the database.
* **Frontend:**
    * An HTML form with input fields for:
        * `Customer Name` (Text input)
        * `Email` (Email input, ensure unique validation)
        * `Phone` (Text input)
        * `Address` (Textarea or multiple text inputs)
        * `Password` (Password input, required)
    * A submit button (`Add Customer`) and a cancel button/link.
* **Backend (PHP/MySQLi):**
    * Detect `POST` request.
    * Collect form data from `$_POST`.
    * **Validate input:** Check for empty fields, valid email format, unique email.
    * **Hash the password** using `password_hash()`.
    * **SQL `INSERT`:** Insert the validated and hashed data into the `customers` table.
    * On successful insertion, redirect to `customer_view.php` with a success status.

#### 2. `customer_edit.php`

* **Purpose:** To allow administrators to modify details of an existing customer.
* **Frontend:**
    * An HTML form similar to `customer_add.php`, but with fields **pre-filled** with the customer's current data.
    * A separate password field that can be left blank if the password isn't being changed, or filled to update it.
    * A submit button (`Update Customer`) and a cancel button/link.
* **Backend (PHP/MySQLi):**
    * **On page load:**
        * Get `cus_id` from `$_GET` (e.g., `customer_edit.php?id=123`).
        * **SQL `SELECT`:** Fetch the existing customer's data from the `customers` table using the `cus_id`.
        * If `cus_id` is invalid or customer not found, display an error and exit.
        * Use the fetched data to pre-fill the form fields.
    * **On form submission (`POST` request):**
        * Collect updated form data.
        * **Validate input:** Check for empty fields, valid email, etc.
        * If a new password is provided, hash it. Otherwise, retain the existing hashed password.
        * **SQL `UPDATE`:** Update the customer's record in the `customers` table using the `cus_id`.
        * On successful update, redirect to `customer_view.php` with a success status.

#### 3. `customer_delete.php`

* **Purpose:** To process the deletion of a specific customer record.
* **Frontend:**
    * This file typically **does not** render a full page. It should be triggered by a "Delete" link/button from `customer_view.php`.
    * **Crucial:** Implement a **confirmation mechanism** before actual deletion (e.g., a JavaScript `confirm()` dialog on the delete link, or a dedicated confirmation page/modal that sends a POST request).
* **Backend (PHP/MySQLi):**
    * Get `cus_id` from `$_GET` or `$_POST`.
    * Verify the `cus_id` and ensure a valid confirmation has been received.
    * **SQL `DELETE`:** Remove the customer record from the `customers` table.
    * **Important Consideration:** Decide how to handle **related `orders`**. Options include:
        * Prevent deletion if the customer has existing orders.
        * Set `cus_id` in related `orders` to `NULL` (requires `NULL`able `cus_id` in `orders` table and potentially `ON DELETE SET NULL` foreign key constraint).
        * Cascade delete related orders (use `ON DELETE CASCADE` foreign key constraint - use with extreme caution!).
    * On successful deletion, redirect to `customer_view.php` with a success status.

#### 4. `customer_view.php`

* **Purpose:** To display a comprehensive list of all customer records in a tabular format.
* **Frontend:**
    * A responsive HTML table displaying key customer information (e.g., `ID`, `Name`, `Email`, `Phone`, `Address`).
    * An "Add New Customer" button that links to `customer_add.php`.
    * For each row, "Edit" buttons/links (linking to `customer_edit.php?id=...`) and "Delete" buttons/links (linking to `customer_delete.php?id=...`).
* **Backend (PHP/MySQLi):**
    * **SQL `SELECT`:** Retrieve all necessary customer data from the `customers` table.
    * Loop through the fetched data using a `while` loop and dynamically populate the rows of the HTML table.
    * Use `htmlspecialchars()` when displaying data fetched from the database to prevent XSS.

---
