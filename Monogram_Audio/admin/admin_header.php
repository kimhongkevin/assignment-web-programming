<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audio Store Admin Panel</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        #sidebar {
            min-width: 250px;
            max-width: 250px;
            background: #1a2456; /* Sidebar background color */
            color: #fff;
            transition: all 0.3s;
            padding-top: 20px;
        }
        #sidebar.active {
            margin-left: -250px;
        }
        #sidebar .sidebar-header {
            padding: 20px;
            background: #ff8b68; /* Sidebar header background color */
            text-align: center;
        }
        #sidebar ul.components {
            padding: 20px 0;
            border-bottom: 1px solid #080b1b; /* Separator line */
        }
        #sidebar ul li a {
            padding: 10px;
            font-size: 1.1em;
            display: block;
            color: #f0efed; /* Link color */
        }
        #sidebar ul li a:hover {
            color: #ff8b68; /* Link hover text color */
            background: #fff; /* Link hover background */
            text-decoration: none;
        }
        #content {
            width: 100%;
            padding: 20px;
            min-height: 100vh;
            transition: all 0.3s;
        }
        .navbar-toggler {
            border: none;
        }
    </style>
</head>
<body>

    <nav id="sidebar">
        <div class="sidebar-header">
            <h3>🎧 Monogram Audio Store Admin</h3>
        </div>

        <ul class="list-unstyled components">
            <p class="text-center">Main Navigation</p>
            <li>
                <a href="#dashboardSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <ul class="collapse list-unstyled" id="dashboardSubmenu">
                    <li><a href="./dashboard/dashboard.php">Overview</a></li>
                    <li><a href="./dashboard/dashboard_reports.php">Reports</a></li>
                </ul>
            </li>
            <li>
                <a href="#productManagementSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                    <i class="fas fa-boxes"></i> Product Management
                </a>
                <ul class="collapse list-unstyled" id="productManagementSubmenu">
                    <li><a href="./products/product_add.php">Add Product</a></li>
                    <li><a href="./products/product_view.php">View Products</a></li>
                    <li><a href="./products/product_low_stock.php">Low Stock Alerts</a></li>
                </ul>
            </li>
            <li>
                <a href="#salesTransactionsSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                    <i class="fas fa-shopping-cart"></i> Sales Transactions
                </a>
                <ul class="collapse list-unstyled" id="salesTransactionsSubmenu">
                    <li><a href="./sales/order_view.php">View Orders</a></li>
                    <li><a href="./sales/orders_history.php">Order History</a></li>
                </ul>
            </li>
            <li>
                <a href="#customerManagementSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                    <i class="fas fa-users"></i> Customer Management
                </a>
                <ul class="collapse list-unstyled" id="customerManagementSubmenu">
                    <li><a href="./customers/customer_view.php">View Customers</a></li>
                    <li><a href="./customers/customer_add.php">Add Customer</a></li>
                </ul>
            </li>
            <li>
                <a href="#userAuthenticationSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">
                    <i class="fas fa-user-shield"></i> User Authentication
                </a>
                <ul class="collapse list-unstyled" id="userAuthenticationSubmenu">
                    <li><a href="./users/user_manage_admins.php">Manage Admins</a></li>
                    <li><a href="./users/user_roles_permissions.php">Roles & Permissions</a></li>
                </ul>
            </li>
        </ul>

        <ul class="list-unstyled CTAs">
            <li>
                <a href="./logout.php" class="download">Logout</a>
            </li>
        </ul>
    </nav>

    <div id="content">
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid">
                <button type="button" id="sidebarCollapse" class="btn btn-outline-dark">
                    <i class="fas fa-align-left"></i>
                    <span>Toggle Sidebar</span>
                </button>
                <div class="ml-auto">
                    <h5>Welcome, Admin!</h5>
                </div>
            </div>
        </nav>
