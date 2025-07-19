# Module: Users

This README outlines the coding requirements for managing administrative user accounts in the admin panel. This includes handling login access, user creation, modification, and deletion.

---

### General Coding Requirements (Applicable to All User Module Files)

All PHP files within the `users` folder **must** adhere to the following:

1.  **Includes:**
    * Start each file by including `admin_header.php`:
        ```php
        <?php include '../admin_header.php'; ?>
        ```
    * Include `admin_footer.php` at the end:
        ```php
        <?php include '../admin_footer.php'; ?>
        ```
    * Include the database connection file:
        ```php
        <?php include '../db_connect.php'; ?>
        ```

2.  **Session Management & Authorization:**
    * Initiate session:
        ```php
        <?php session_start(); ?>
        ```
    * Implement **robust authentication checks** to ensure the user is logged in.
    * For user management, implement **strong authorization checks** (e.g., only super-admins should access `user_manage_admins.php`). Redirect to `login.php` or a restricted access page if unauthorized.

3.  **Database Interaction (MySQLi Object-Oriented Style):**
    * Use **prepared statements** for all SQL queries (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) involving user input.
    * Handle query results.
    * Close database connection: `$conn->close();`.

4.  **Password Hashing:**
    * **Crucial:** When creating or updating user passwords, **always use `password_hash()`** (e.g., `PASSWORD_DEFAULT`). **Never store passwords in plain text or MD5**, even though the current schema comment mentions MD5. Validate with `password_verify()` during login.

5.  **Input Validation & Sanitization:**
    * Validate all user input (`$_POST`, `$_GET`) for format, uniqueness (e.g., username), and length.
    * Sanitize input using `htmlspecialchars()`, `trim()` to prevent XSS.

6.  **Error Handling & User Feedback:**
    * Implement error checking for database operations.
    * Provide clear success/error messages (Bootstrap alerts).
    * Redirect using `header('Location: ...'); exit();` after POST requests.
7. **Database configuration
$host = 'localhost';
$username = 'root';      // Default XAMPP username
$password = '';          // Default XAMPP password (empty)
$database = 'audio_store_db';

---

### File-Specific Requirements

#### 1. `user_manage_admins.php`

* **Purpose:** To provide a CRUD interface for managing administrative user accounts (admins, staff) including their roles.
* **Database Table:** `users` (columns: `user_id`, `username`, `full_name`, `password`, `role`).
* **Frontend:**
    * A table listing existing users (Username, Full Name, Role).
    * "Add User" button.
    * "Edit" and "Delete" actions for each user row.
    * Forms for adding/editing user details (username, full name, password, and a **dropdown or input for selecting/assigning the user's role**).
* **Backend (PHP/MySQLi):**
    * **High-level Authorization Check:** Only highly privileged administrators should have access to this page.
    * **Read:** `SELECT` all users from the `users` table to display the list, including their `role`.
    * **Add:** Process form submission, validate input, **hash password**, `INSERT` into `users` table, ensuring the `role` is also saved.
    * **Edit:** Get `user_id` from `$_GET`, `SELECT` user data to pre-fill the form (including current `role`), process update, **hash new password if provided**, `UPDATE` `users` table (updating `role` if changed).
    * **Delete:** Get `user_id`, implement **confirmation**, `DELETE` from `users` table.
