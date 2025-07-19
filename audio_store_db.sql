-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2025 at 06:01 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `audio_store_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `cus_id` int(10) NOT NULL COMMENT 'customer id',
  `cus_name` varchar(50) NOT NULL COMMENT 'customer''s name',
  `email` varchar(100) NOT NULL COMMENT 'customer''s email',
  `phone` varchar(15) NOT NULL COMMENT 'customer''s phone num',
  `address` varchar(100) NOT NULL COMMENT 'customer''s delivery address',
  `password` varchar(255) NOT NULL COMMENT 'customer log in password'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`cus_id`, `cus_name`, `email`, `phone`, `address`, `password`) VALUES
(1, 'Lim Dara', 'limdara1@gmail.com', '077115555', 'Sovanna market,St.271,S.K Tomnup Tek,Phnom Penh', '');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(10) NOT NULL COMMENT 'id for a specific order',
  `cus_id` int(10) NOT NULL COMMENT 'customer id',
  `cus_name` varchar(100) NOT NULL COMMENT '"customer name" got data by relating to customers table by cus_id',
  `date` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'date of order: update when customer drops order',
  `total_order_price` decimal(10,2) NOT NULL COMMENT 'It''s automatically calculated (the trigger already set)',
  `status` enum('pending','paid','delivering','received') NOT NULL DEFAULT 'pending' COMMENT 'Order status ONLY includes: pending(not yet paid), paid, delivering, received'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `cus_id`, `cus_name`, `date`, `total_order_price`, `status`) VALUES
(1, 1, 'Lim Dara', '2025-07-19 00:21:02', 278.00, 'paid');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `before_insert_orders` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
	DECLARE customer_name VARCHAR(100);
    SELECT cus_name INTO customer_name
    FROM customers WHERE cus_id = NEW.cus_id;
    
    SET NEW.cus_name = customer_name;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `item_id` int(10) NOT NULL COMMENT 'id for each item order',
  `order_id` int(10) NOT NULL COMMENT 'order id',
  `product_id` int(10) NOT NULL COMMENT 'id of product',
  `product_name` varchar(100) NOT NULL COMMENT 'product_name being set automatically by trigger',
  `quantity` int(10) NOT NULL COMMENT 'quantity of product',
  `unit_price` decimal(10,2) NOT NULL COMMENT 'unit_price being set automatically by trigger',
  `total_price` decimal(10,2) NOT NULL COMMENT 'total_price being calculated automatically by trigger'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`item_id`, `order_id`, `product_id`, `product_name`, `quantity`, `unit_price`, `total_price`) VALUES
(1, 1, 3, 'Air3 Deluxe HS', 1, 25.00, 25.00),
(2, 1, 8, 'StormBox 2', 2, 39.00, 78.00),
(3, 1, 15, 'Shell S1', 1, 175.00, 175.00);

--
-- Triggers `order_items`
--
DELIMITER $$
CREATE TRIGGER `after_order_items_insert` AFTER INSERT ON `order_items` FOR EACH ROW BEGIN
  UPDATE orders
  SET total_order_price = (
      SELECT SUM(total_price)
      FROM order_items
      WHERE order_id = NEW.order_id
  )
  WHERE order_id = NEW.order_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_order_items` BEFORE INSERT ON `order_items` FOR EACH ROW BEGIN
    DECLARE pd_name VARCHAR(100);
    DECLARE u_price DECIMAL(10,2);

    SELECT product_name, unit_price
    INTO pd_name, u_price
    FROM products
    WHERE product_id = NEW.product_id;

    SET NEW.product_name = pd_name;
    SET NEW.unit_price = u_price;
    SET NEW.total_price = NEW.quantity * u_price;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(10) NOT NULL COMMENT 'id for audio products',
  `product_name` varchar(100) NOT NULL COMMENT 'name for audio products',
  `brand` varchar(50) DEFAULT NULL COMMENT 'brand name of product',
  `description` varchar(500) DEFAULT NULL COMMENT 'product description',
  `category` varchar(100) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL COMMENT 'product unit price',
  `quantiy` int(10) NOT NULL COMMENT 'product quantity',
  `image_filename` varchar(255) DEFAULT NULL,
  `image_alt_text` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `brand`, `description`, `category`, `unit_price`, `quantiy`, `image_filename`, `image_alt_text`) VALUES
(1, 'Mini HS', 'SoundPeats', 'Wireless earbuds', 'Headphone & Earphones', 19.00, 30, 'sp_mini_hs.jpg', 'Mini HS'),
(2, 'Air Pro 4', 'SoundPeats', 'Wireless earbuds', 'Headphone & Earphones', 40.00, 15, 'sp_air_4_pro.jpg', 'Air Pro 4'),
(3, 'Air3 Deluxe HS', 'SoundPeats', 'Wireless earbuds', 'Headphone & Earphones', 25.00, 10, 'sp_air3_deluxe.jpg', 'Air3 Deluxe HS'),
(4, 'Air4', 'SoundPeats', 'Wireless earbuds', 'Headphone & Earphones', 30.00, 22, 'sp_air_4.jpg', 'Air4'),
(5, 'XSound Plus 2', 'Tribit', 'Portable wireless speaker', 'Speakers', 58.00, 20, 'tb_xsound.jpg', 'XSound Plus 2'),
(6, 'Space', 'SoundPeats', 'Overear ANC headphone', 'Headphone & Earphones', 45.00, 31, 'sp_space.jpg', 'Space'),
(7, 'QuietPlus 71X', 'Tribit', 'Wireless ANC headphone', 'Headphone & Earphones', 45.00, 16, 'tb_quietplus71x.jpg', 'QuietPlus 71X'),
(8, 'StormBox 2', 'Tribit', 'Portable wireless speaker', 'Speakers', 39.00, 25, 'tb_stormbox_2.jpg', 'StormBox 2'),
(9, 'StormBox Mini', 'Tribit', 'Portable wireless speaker', 'Speakers', 19.00, 10, 'tb_stormbox_mini.jpg', 'StormBox Mini'),
(10, 'Capsule3 Pro+', 'SoundPeats', 'Hi-Res audio wirless earbuds', 'Headphone & Earphones', 40.00, 35, 'sp_capsule3.jpg', 'Capsule3 Pro+'),
(11, 'Air5 Lite', 'SoundPeats', 'Hi-Res audio wirless earbuds with cloud audio', 'Headphone & Earphones', 25.00, 15, 'sp_air5_lite.jpg', 'Air5 Lite'),
(12, 'Air 5', 'SoundPeats', 'Wireless earbuds', 'Headphone & Earphones', 40.00, 28, 'sp_air_5.jpg', 'Air 5'),
(13, 'Gofree2', 'SoundPeats', 'Open ear earphones', 'Headphone & Earphones', 55.00, 42, 'sp_gofree2.jpg', 'Gofree2'),
(14, 'Break X2', 'Ikarao', 'Karaoke machine', 'Karaoke', 125.00, 5, 'ikarao_break.jpg', 'Break X2'),
(15, 'Shell S1', 'Ikarao', 'Speaker and karaoke machine', 'Karaoke', 175.00, 10, 'Ikarao_Shell_S1.jpg', 'Shell S1'),
(16, 'S1 Pro', 'Bose', 'wireless bluetooth speaker', 'Speakers', 85.00, 10, 'bose_s1_pro.jpg', 'S1 Pro'),
(17, 'Uboom L', 'Earfun', 'bluetooth desktop speaker', 'Speakers', 45.00, 15, 'ef_uboom.jpg', 'Uboom L'),
(18, 'Button X-Bass', 'Tribit', 'wireless overear headphone', 'Headphone & Earphones', 55.00, 19, 'tb_button_xbass.jpg', 'Button X-Bass'),
(19, 'Flybuds C1', 'Tribit', 'True wireless earbuds', 'Headphone & Earphones', 20.70, 33, 'tb_flybud_c1.jpg', 'Flybuds C1'),
(20, 'Breezy', 'SoundPeat', 'Open ear 90degree adjustable earphone', 'Headphone & Earphones', 39.99, 17, 'sp_breezy.jpg', 'Breezy');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) NOT NULL COMMENT 'id for each user(admin,sale staffs)',
  `username` varchar(50) NOT NULL COMMENT 'username for each user',
  `full_name` varchar(50) NOT NULL COMMENT 'real name of each user',
  `password` varchar(255) NOT NULL COMMENT 'log in password(in form of MD5 password)',
  `role` enum('sales staff','admin','super-admin') NOT NULL COMMENT 'role for each user("sales staff" ,"admin" ,"super-admin")'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `full_name`, `password`, `role`) VALUES
(1, 'admin1', 'Kim Hong', 'e00cf25ad42683b3df678c61f42c6bda', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`cus_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `cus_id` (`cus_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `cus_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'customer id', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id for a specific order', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id for each item order', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id for audio products', AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'id for each user(admin,sale staffs)', AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`cus_id`) REFERENCES `customers` (`Cus_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
