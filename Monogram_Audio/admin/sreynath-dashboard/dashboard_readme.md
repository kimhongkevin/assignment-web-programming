# Project: Audio Store Admin Panel

## Module: Dashboard

This section outlines the coding requirements and best practices for developing the "Dashboard" module of the admin panel. This module provides administrators with an overview of key business metrics and recent activities.

---

### General Coding Requirements (Applicable to All Dashboard Module Files)

All PHP files within the `dashboard` folder **must** adhere to the following:

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

2.  **Session Management & Authorization:**
    * Initiate session at the very beginning (`<?php session_start(); ?>`).
    * Implement robust checks to ensure the user is logged in and authorized to access dashboard information. Redirect to `login.php` if unauthorized.

3.  **Database Interaction (MySQLi Object-Oriented Style):**
    * The dashboard primarily involves **`SELECT` queries** to retrieve data for display.
    * Use prepared statements (`prepare()`, `bind_param()`, `execute()`) even for `SELECT` queries if dynamic parameters (e.g., date ranges for reports) are involved.
    * Handle query results using `get_result()`, `fetch_assoc()`.
    * Ensure database connection (`$conn->close();`) is closed at the end of the script.

4.  **Data Aggregation:**
    * Leverage SQL aggregate functions (`COUNT()`, `SUM()`, `AVG()`, `GROUP BY`) for calculating summary statistics and reports.

5.  **Performance Consideration:**
    * For dashboards with many metrics or complex reports, optimize SQL queries (e.g., proper indexing on database columns). Avoid N+1 query problems.

6.  **Error Handling & User Feedback:**
    * Implement basic error checking for database operations.
    * Provide user-friendly messages if data cannot be loaded.

---

### File-Specific Requirements

#### 1. `dashboard.php`

* **Purpose:** To serve as the main landing page for the admin panel, offering an at-a-glance summary of key business metrics and recent activities.
* **Frontend:**
    * Display "cards" (e.g., using Bootstrap's `.card` component) showing aggregated numbers such as:
        * **Total Products**: 
        * **New Orders Today**: 
        * **Pending Deliveries**: 
        * **Low Stock Items**: 
    * A "Recent Activities" section, typically a table listing recent events like new product additions, order status changes, or customer updates.
* **Backend (PHP/MySQLi):**
    * Execute multiple **`SELECT COUNT(*)`** queries to retrieve summary statistics from relevant tables:
        * `Total Products`: `SELECT COUNT(*) FROM products;`
        * `New Orders Today`: `SELECT COUNT(*) FROM orders WHERE DATE(date) = CURDATE();`
        * `Pending Deliveries`: `SELECT COUNT(*) FROM orders WHERE status = 'pending';`
        * `Low Stock Items`: `SELECT COUNT(*) FROM products WHERE quantity <= [your_threshold];`
    * **SQL `SELECT`** queries for "Recent Activities": Fetch recent entries from `orders`, `products`, and `customers` tables, ordered by date in descending order, with a `LIMIT` clause.
    * Dynamically embed the fetched counts and recent activity data into the HTML structure.

#### 2. `dashboard_reports.php`

* **Purpose:** To provide more detailed analytical reports and insights into various aspects of the business.
* **Frontend:**
    * Will likely feature more complex data presentations like detailed tables, and potentially charts (if a JavaScript charting library like Chart.js is integrated).
    * Include filtering options such as date range selectors, product categories, or customer filters to refine reports.
* **Backend (PHP/MySQLi):**
    * Involve more sophisticated **`SELECT` queries** with:
        * **`JOIN`s:** To combine data from multiple tables (e.g., `orders`, `order_items`, `products`, `customers`).
        * **`GROUP BY`:** To aggregate data based on specific criteria (e.g., sales by month, top-selling products by category).
        * **Aggregate Functions:** `SUM()`, `AVG()`, `COUNT()` to calculate totals, averages, and counts for reports.
    * Example queries:
        * `SELECT MONTH(date) as month, SUM(total_order_price) as total_sales FROM orders GROUP BY month ORDER BY month;`
        * `SELECT p.product_name, SUM(oi.quantity) as total_sold FROM order_items oi JOIN products p ON oi.product_id = p.product_id GROUP BY p.product_name ORDER BY total_sold DESC LIMIT 10;`
    * Process and structure the fetched report data for display in tables or for use with charting libraries.