<?php
function getFeaturedProducts($conn, $limit = 4) {
    $stmt = $conn->prepare("SELECT * FROM products WHERE featured = 1 LIMIT ?");
    $stmt->bind_param("i", $limit);
    $stmt->execute();
    $result = $stmt->get_result();
    return $result->fetch_all(MYSQLI_ASSOC);
}

function getProductCategories($conn) {
    $result = $conn->query("SELECT DISTINCT category FROM products");
    $categories = [];
    while($row = $result->fetch_assoc()) {
        $categories[] = $row['category'];
    }
    return $categories;
}

function shortenDescription($text, $length = 100) {
    if (strlen($text) <= $length) return $text;
    return substr($text, 0, $length) . '...';
}

function getCartItemCount() {
    return isset($_SESSION['cart']) ? count($_SESSION['cart']) : 0;
}

// Admin functions
function getProductCount($conn) {
    $result = $conn->query("SELECT COUNT(*) as count FROM products");
    $row = $result->fetch_assoc();
    return $row['count'];
}

function getOrderCount($conn) {
    $result = $conn->query("SELECT COUNT(*) as count FROM orders");
    $row = $result->fetch_assoc();
    return $row['count'];
}

function getUserCount($conn) {
    $result = $conn->query("SELECT COUNT(*) as count FROM customers");
    $row = $result->fetch_assoc();
    return $row['count'];
}

function getRecentOrders($conn, $limit = 5) {
    $stmt = $conn->prepare("SELECT * FROM orders ORDER BY date DESC LIMIT ?");
    $stmt->bind_param("i", $limit);
    $stmt->execute();
    $result = $stmt->get_result();
    return $result->fetch_all(MYSQLI_ASSOC);
}

function getStatusBadgeClass($status) {
    switch ($status) {
        case 'pending': return 'warning';
        case 'paid': return 'primary';
        case 'delivering': return 'info';
        case 'received': return 'success';
        default: return 'secondary';
    }
}
?>