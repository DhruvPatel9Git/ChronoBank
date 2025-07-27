-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 10, 2025 at 07:02 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chronobank`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `account_number` bigint NOT NULL,
  `account_type` enum('Savings','Investment','Loan') NOT NULL,
  `balance` varchar(6) DEFAULT NULL,
  `interest_rate` decimal(5,2) DEFAULT '0.00',
  `transaction_limit` decimal(10,2) DEFAULT '0.00',
  `account_status` enum('active','frozen','overdrawn','closed') DEFAULT 'active',
  `is_deleted` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `loan_blocked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_number` (`account_number`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_account_number` (`account_number`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `user_id`, `fullname`, `account_number`, `account_type`, `balance`, `interest_rate`, `transaction_limit`, `account_status`, `is_deleted`, `created_at`, `updated_at`, `loan_blocked`) VALUES
(10, 5, 'Kaival Shah', 61106629529, 'Savings', '529:13', 5.00, 8000.00, 'active', 0, '2025-04-12 13:46:18', '2025-05-10 04:05:47', 0),
(11, 2, 'Dhruv Patel', 71778320407, 'Savings', '305:45', 3.00, 6002.00, 'active', 0, '2025-04-12 13:50:17', '2025-05-10 06:59:51', 0);

--
-- Triggers `accounts`
--
DROP TRIGGER IF EXISTS `update_account_status_on_balance_change`;
DELIMITER $$
CREATE TRIGGER `update_account_status_on_balance_change` BEFORE UPDATE ON `accounts` FOR EACH ROW BEGIN
    DECLARE total_minutes INT DEFAULT 0;
    DECLARE hours_part INT DEFAULT 0;
    DECLARE minutes_part INT DEFAULT 0;

  
    IF NEW.balance IS NOT NULL THEN
      
        SET hours_part = CAST(SUBSTRING_INDEX(NEW.balance, ':', 1) AS UNSIGNED);
        SET minutes_part = CAST(SUBSTRING_INDEX(NEW.balance, ':', -1) AS UNSIGNED);
        SET total_minutes = (hours_part * 60) + minutes_part;

        
        IF total_minutes <= 0 THEN
            SET NEW.account_status = 'overdrawn';
        ELSE
            SET NEW.account_status = 'active';
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password`) VALUES
(1, 'admin', 'admin123');

-- --------------------------------------------------------

--
-- Table structure for table `goal_transactions`
--

DROP TABLE IF EXISTS `goal_transactions`;
CREATE TABLE IF NOT EXISTS `goal_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `goal_id` int NOT NULL,
  `hours` float NOT NULL,
  `type` varchar(20) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `goal_id` (`goal_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `goal_transactions`
--

INSERT INTO `goal_transactions` (`id`, `user_id`, `goal_id`, `hours`, `type`, `timestamp`) VALUES
(16, 2, 18, 2, 'allocate', '2025-05-10 06:45:28'),
(19, 2, 18, 1, 'withdraw', '2025-05-10 06:59:51'),
(18, 2, 18, 1, 'withdraw', '2025-05-10 06:59:44');

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
CREATE TABLE IF NOT EXISTS `loans` (
  `loan_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `loan_amount` varchar(20) NOT NULL,
  `status` enum('Pending','Approved','Rejected','Repaid','Suspicious') DEFAULT 'Pending',
  `applied_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `repayment_due` date DEFAULT NULL,
  `strategy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`loan_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`loan_id`, `user_id`, `loan_amount`, `status`, `applied_at`, `repayment_due`, `strategy`) VALUES
(132, 2, '8', 'Repaid', '2025-05-10 12:19:08', '2025-05-15', 'Installment'),
(131, 2, '8', 'Repaid', '2025-05-10 08:40:54', '2025-05-15', 'Fixed'),
(130, 2, '8', 'Repaid', '2025-05-10 08:39:27', '2025-05-15', 'Installment'),
(129, 2, '8', 'Repaid', '2025-05-10 08:36:45', '2025-05-15', 'Installment'),
(128, 2, '8', 'Repaid', '2025-05-10 08:31:28', '2025-05-15', 'Fixed');

-- --------------------------------------------------------

--
-- Table structure for table `money_time_transactions`
--

DROP TABLE IF EXISTS `money_time_transactions`;
CREATE TABLE IF NOT EXISTS `money_time_transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `account_type` varchar(20) NOT NULL,
  `transaction_type` varchar(20) NOT NULL,
  `time_amount` int NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `time_equivalent` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`)
) ENGINE=MyISAM AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `money_time_transactions`
--

INSERT INTO `money_time_transactions` (`transaction_id`, `user_id`, `account_type`, `transaction_type`, `time_amount`, `timestamp`, `time_equivalent`) VALUES
(88, 2, 'Savings', 'deposit', 10, '2025-05-10 05:21:27', '00:20'),
(89, 2, 'Savings', 'withdraw', 10, '2025-05-10 05:21:40', '00:20'),
(90, 2, 'Savings', 'deposit', 10, '2025-05-10 05:23:16', '00:20'),
(91, 2, 'Savings', 'withdraw', 10, '2025-05-10 05:24:47', '00:20');

-- --------------------------------------------------------

--
-- Table structure for table `repayments`
--

DROP TABLE IF EXISTS `repayments`;
CREATE TABLE IF NOT EXISTS `repayments` (
  `repayment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `loan_id` int NOT NULL,
  `strategy` varchar(50) NOT NULL,
  `amount` varchar(5) NOT NULL,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','paid','overdue') DEFAULT 'pending',
  `due_date` date DEFAULT NULL,
  `installment_number` int DEFAULT NULL,
  PRIMARY KEY (`repayment_id`)
) ENGINE=MyISAM AUTO_INCREMENT=243 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `repayments`
--

INSERT INTO `repayments` (`repayment_id`, `user_id`, `loan_id`, `strategy`, `amount`, `created_on`, `status`, `due_date`, `installment_number`) VALUES
(242, 2, 132, 'Installment', '2.0', '2025-05-10 12:19:08', 'paid', '2025-05-10', 4),
(241, 2, 132, 'Installment', '2.0', '2025-05-10 12:19:08', 'paid', '2025-05-10', 3),
(240, 2, 132, 'Installment', '2.0', '2025-05-10 12:19:08', 'paid', '2025-05-10', 2),
(239, 2, 132, 'Installment', '2.0', '2025-05-10 12:19:08', 'paid', '2025-05-10', 1),
(238, 2, 131, 'Fixed', '8.15', '2025-05-10 08:40:54', 'paid', '2025-05-10', 1),
(237, 2, 130, 'Installment', '2.0', '2025-05-10 08:39:27', 'paid', '2025-05-10', 4),
(236, 2, 130, 'Installment', '2.0', '2025-05-10 08:39:27', 'paid', '2025-05-10', 3),
(235, 2, 130, 'Installment', '2.0', '2025-05-10 08:39:27', 'paid', '2025-05-10', 2),
(234, 2, 130, 'Installment', '2.0', '2025-05-10 08:39:27', 'paid', '2025-05-10', 1),
(233, 2, 129, 'Installment', '2.0', '2025-05-10 08:36:45', 'paid', '2025-05-10', 4),
(232, 2, 129, 'Installment', '2.0', '2025-05-10 08:36:45', 'paid', '2025-05-10', 3),
(231, 2, 129, 'Installment', '2.0', '2025-05-10 08:36:45', 'paid', '2025-05-10', 2),
(230, 2, 129, 'Installment', '2.0', '2025-05-10 08:36:45', 'paid', '2025-05-10', 1),
(229, 2, 128, 'Fixed', '8.15', '2025-05-10 08:31:28', 'paid', '2025-05-10', 1);

-- --------------------------------------------------------

--
-- Table structure for table `time_goals`
--

DROP TABLE IF EXISTS `time_goals`;
CREATE TABLE IF NOT EXISTS `time_goals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `saved_hours` float DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `time_goals`
--

INSERT INTO `time_goals` (`id`, `user_id`, `title`, `saved_hours`) VALUES
(18, 2, 'Bogas', 0),
(19, 2, 'Hello', 1);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `sender_account_number` varchar(255) NOT NULL,
  `receiver_account_number` varchar(255) NOT NULL,
  `time_amount` varchar(5) DEFAULT NULL,
  `transaction_type` varchar(255) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tax` decimal(10,2) DEFAULT '0.00',
  `bonus` decimal(10,2) DEFAULT '0.00',
  `txn_hash` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`)
) ENGINE=MyISAM AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `total_balance` varchar(6) DEFAULT NULL,
  `total_balance_minutes` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `total_balance`, `total_balance_minutes`) VALUES
(2, 'Dhruv', '123', '305:45', 18345),
(5, 'Kaival', '123', '529:13', 31753);

--
-- Triggers `users`
--
DROP TRIGGER IF EXISTS `update_total_balance_minutes`;
DELIMITER $$
CREATE TRIGGER `update_total_balance_minutes` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    -- Convert the total_balance_minutes (INT) to total_balance (TIME)
    SET NEW.total_balance = SEC_TO_TIME(NEW.total_balance_minutes * 60);
END
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
