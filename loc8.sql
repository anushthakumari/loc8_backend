-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 03, 2024 at 08:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `loc8`
--

-- --------------------------------------------------------

--
-- Table structure for table `assigned_budgets`
--

CREATE TABLE `assigned_budgets` (
  `id` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `budget_id` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assigned_budgets`
--

INSERT INTO `assigned_budgets` (`id`, `user_id`, `budget_id`) VALUES
('5c5ed223-e109-4655-936d-49e1f867de61', 39, 'bc82c708-8725-4d66-ba36-c6e0341a88fa'),
('65648f08-d4d4-48c5-8a9b-c1326fe15507', 39, '43dfd696-ea3a-434c-8c5d-a5a41244e68b');

-- --------------------------------------------------------

--
-- Table structure for table `billboards`
--

CREATE TABLE `billboards` (
  `id` varchar(36) NOT NULL,
  `video_id` varchar(36) DEFAULT NULL,
  `visibility_duration` float DEFAULT NULL,
  `distance_to_center` float DEFAULT NULL,
  `central_duration` float DEFAULT NULL,
  `near_p_duration` float DEFAULT NULL,
  `mid_p_duration` float DEFAULT NULL,
  `far_p_duration` float DEFAULT NULL,
  `central_distance` float DEFAULT NULL,
  `near_p_distance` float DEFAULT NULL,
  `mid_p_distance` float DEFAULT NULL,
  `far_p_distance` float DEFAULT NULL,
  `average_areas` float DEFAULT NULL,
  `confidence` float DEFAULT NULL,
  `tracker_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by_user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `billboards`
--

INSERT INTO `billboards` (`id`, `video_id`, `visibility_duration`, `distance_to_center`, `central_duration`, `near_p_duration`, `mid_p_duration`, `far_p_duration`, `central_distance`, `near_p_distance`, `mid_p_distance`, `far_p_distance`, `average_areas`, `confidence`, `tracker_id`, `created_at`, `created_by_user_id`) VALUES
('7864676f-8f31-47ca-90e8-2a0c756b8294', '9371b1e0-6542-4419-9d35-f05ecf247d40', 4.36667, 42.2614, 0, 1.83333, 1.56667, 0.766667, 0, 66.924, 75.9757, 87.507, 2.39415, 0.706747, 2, '2024-04-03 16:12:56', 1),
('8245b458-5541-4ef9-9c37-0b3bbb7e043e', '9371b1e0-6542-4419-9d35-f05ecf247d40', 0.933333, 12.7545, 0.233333, 0.7, 0, 0, 60.0628, 61.1341, 0, 0, 1.10103, 0.690164, 4, '2024-04-03 16:12:56', 1),
('886cd23b-f047-46a6-8d23-be62db3fd72e', '9371b1e0-6542-4419-9d35-f05ecf247d40', 2.9, 25.0201, 0, 2.43333, 0.466667, 0, 0, 65.7549, 72.5264, 0, 1.70951, 0.725351, 3, '2024-04-03 16:12:56', 1),
('e8e7b674-35fd-49f6-8ec4-a0ff039bb009', '9371b1e0-6542-4419-9d35-f05ecf247d40', 2, 42.2873, 0, 0, 0.966667, 1.03333, 0, 0, 77.9903, 86.8466, 3.0619, 0.670036, 1, '2024-04-03 16:12:56', 1);

-- --------------------------------------------------------

--
-- Table structure for table `briefs`
--

CREATE TABLE `briefs` (
  `brief_id` varchar(100) NOT NULL,
  `category` varchar(200) NOT NULL,
  `brand_name` varchar(200) NOT NULL,
  `brand_logo` varchar(300) NOT NULL,
  `target_audience` varchar(150) NOT NULL,
  `campaign_obj` varchar(200) NOT NULL,
  `media_approach` varchar(200) NOT NULL,
  `is_immediate_camp` tinyint(1) NOT NULL DEFAULT 0,
  `start_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by_user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `briefs`
--

INSERT INTO `briefs` (`brief_id`, `category`, `brand_name`, `brand_logo`, `target_audience`, `campaign_obj`, `media_approach`, `is_immediate_camp`, `start_date`, `notes`, `status`, `created_at`, `created_by_user_id`) VALUES
('d081a45a-b6a6-40d7-a955-47eabaa21ab8', 'category', 'brand', 'd081a45a-b6a6-40d7-a955-47eabaa21ab8loan-1.jpg', 'target', 'camp', 'med', 0, NULL, NULL, 0, '2024-04-03 01:18:46', 1);

-- --------------------------------------------------------

--
-- Table structure for table `brief_budgets`
--

CREATE TABLE `brief_budgets` (
  `budget_id` varchar(100) NOT NULL,
  `brief_id` varchar(100) NOT NULL,
  `zone_id` int(11) NOT NULL,
  `state_id` int(11) NOT NULL,
  `city_id` int(11) NOT NULL,
  `budget` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `brief_budgets`
--

INSERT INTO `brief_budgets` (`budget_id`, `brief_id`, `zone_id`, `state_id`, `city_id`, `budget`) VALUES
('43dfd696-ea3a-434c-8c5d-a5a41244e68b', 'd081a45a-b6a6-40d7-a955-47eabaa21ab8', 2, 10, 7, 9000),
('bc82c708-8725-4d66-ba36-c6e0341a88fa', 'd081a45a-b6a6-40d7-a955-47eabaa21ab8', 5, 9, 6, 8000);

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `city_id` int(11) NOT NULL,
  `city_name` varchar(50) NOT NULL,
  `state_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`city_id`, `city_name`, `state_id`) VALUES
(6, 'new york city', 9),
(7, 'south city', 10);

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE `plans` (
  `plan_id` varchar(40) NOT NULL,
  `brief_id` varchar(40) NOT NULL,
  `budget_id` varchar(40) NOT NULL,
  `user_id` int(11) NOT NULL,
  `video_id` varchar(40) NOT NULL,
  `location` varchar(100) NOT NULL,
  `lattitude` decimal(9,6) NOT NULL,
  `longititude` decimal(9,6) NOT NULL,
  `illumination` varchar(200) NOT NULL,
  `media_type` varchar(150) NOT NULL,
  `w` int(8) NOT NULL,
  `h` int(8) NOT NULL,
  `qty` int(5) NOT NULL,
  `size` int(10) NOT NULL,
  `duration` decimal(5,2) NOT NULL,
  `imp_per_month` int(10) NOT NULL,
  `rental_per_month` decimal(10,2) NOT NULL,
  `cost_for_duration` decimal(10,2) NOT NULL,
  `printing` decimal(10,2) NOT NULL,
  `mouting` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` int(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'planner'),
(2, 'admin'),
(3, 'controller'),
(4, 'superadmin');

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `state_id` int(11) NOT NULL,
  `state_name` varchar(50) NOT NULL,
  `zone_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`state_id`, `state_name`, `zone_id`) VALUES
(9, 'new york state', 5),
(10, 'south state', 2);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `employee_id` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by_user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role_id`, `first_name`, `last_name`, `employee_id`, `created_at`, `updated_at`, `created_by_user_id`) VALUES
(1, 'john@mail.com', '$2b$12$LGEvisGVlhfcCOF0R3KGD.EJNP4TZOyCv89zgHkbrC3Ucb5aO6x76', 4, 'John', 'Doe', '12345', '2024-03-06 18:00:33', '2024-03-20 15:38:18', 0),
(33, 'test@mail.com', '$2b$12$O7CNwBTngCzvIlPr430J6uilaOC6tKDG93C6.30DEFXMbaKNafQu6', 2, 'rem1', 'rem1', '123454', '2024-03-31 15:39:19', '2024-03-31 18:49:00', 1),
(34, 'test@gmail.com', '$2b$12$C5M5/QXsZ7N5X7262xeCMOPNWPRhhviFe636k8kVY1KyhyHX40z2O', 3, 'test', 'controller', '7895', '2024-04-01 16:25:17', '2024-04-01 16:49:19', 1),
(36, 'test@email.com', '$2b$12$47bl28GpPwOwnIMz4JFDRe4C5dJwP7tKbC4eLatWcbveLNxWVMNOu', 2, 'test', 'test', 'emp_4', '2024-04-01 16:48:01', '2024-04-01 16:48:29', 1),
(39, 'planner1@mail.com', '$2b$12$CliLWWqa/NLjbMMV7oGJ8eZGAhnNFo2WHh.YC05mJuVeGHSvJDqsW', 1, 'planner', '1', 'planner_emp_1', '2024-04-02 18:47:29', '2024-04-03 01:20:11', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_areas`
--

CREATE TABLE `user_areas` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_areas`
--

INSERT INTO `user_areas` (`id`, `user_id`, `zone_id`, `state_id`, `city_id`) VALUES
(1, 33, 2, NULL, NULL),
(2, 36, 1, NULL, NULL),
(5, 34, 5, 9, 6),
(6, 34, 2, 10, 7),
(8, 39, 5, 9, 6),
(9, 39, 2, 10, 7);

-- --------------------------------------------------------

--
-- Table structure for table `videofiles`
--

CREATE TABLE `videofiles` (
  `video_id` varchar(36) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by_user_id` int(11) DEFAULT NULL,
  `video_path` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `videofiles`
--

INSERT INTO `videofiles` (`video_id`, `filename`, `zone_id`, `state_id`, `city_id`, `created_at`, `created_by_user_id`, `video_path`) VALUES
('9371b1e0-6542-4419-9d35-f05ecf247d40', 'a7bd51c3-3d6d-4dba-9751-8cd81dff381d.mp4', 5, 9, 6, '2024-04-03 16:12:56', 1, './instance/a7bd51c3-3d6d-4dba-9751-8cd81dff381d.mp4');

-- --------------------------------------------------------

--
-- Table structure for table `zones`
--

CREATE TABLE `zones` (
  `zone_id` int(11) NOT NULL,
  `zone_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zones`
--

INSERT INTO `zones` (`zone_id`, `zone_name`) VALUES
(1, 'North'),
(2, 'South'),
(3, 'West'),
(4, 'East'),
(5, 'North East');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assigned_budgets`
--
ALTER TABLE `assigned_budgets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `budget_id` (`budget_id`);

--
-- Indexes for table `billboards`
--
ALTER TABLE `billboards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `video_id` (`video_id`),
  ADD KEY `fk_created_by_user_bill` (`created_by_user_id`);

--
-- Indexes for table `briefs`
--
ALTER TABLE `briefs`
  ADD PRIMARY KEY (`brief_id`),
  ADD KEY `created_by_user_id` (`created_by_user_id`);

--
-- Indexes for table `brief_budgets`
--
ALTER TABLE `brief_budgets`
  ADD PRIMARY KEY (`budget_id`),
  ADD KEY `brief_id` (`brief_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `zone_id` (`zone_id`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`city_id`),
  ADD UNIQUE KEY `city_name` (`city_name`),
  ADD KEY `state_id` (`state_id`);

--
-- Indexes for table `plans`
--
ALTER TABLE `plans`
  ADD KEY `brief_id` (`brief_id`),
  ADD KEY `budget_id` (`budget_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `video_id` (`video_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`state_id`),
  ADD UNIQUE KEY `state_name` (`state_name`),
  ADD KEY `zone_id` (`zone_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`,`employee_id`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD UNIQUE KEY `unique_epmloyee_id` (`employee_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `user_areas`
--
ALTER TABLE `user_areas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `zone_id` (`zone_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `city_id` (`city_id`);

--
-- Indexes for table `videofiles`
--
ALTER TABLE `videofiles`
  ADD PRIMARY KEY (`video_id`),
  ADD UNIQUE KEY `video_path` (`video_path`),
  ADD KEY `zone_id` (`zone_id`),
  ADD KEY `state_id` (`state_id`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `created_by_user_id` (`created_by_user_id`);

--
-- Indexes for table `zones`
--
ALTER TABLE `zones`
  ADD PRIMARY KEY (`zone_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `city_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `state_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `user_areas`
--
ALTER TABLE `user_areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `zones`
--
ALTER TABLE `zones`
  MODIFY `zone_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assigned_budgets`
--
ALTER TABLE `assigned_budgets`
  ADD CONSTRAINT `assigned_budgets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `assigned_budgets_ibfk_2` FOREIGN KEY (`budget_id`) REFERENCES `brief_budgets` (`budget_id`);

--
-- Constraints for table `billboards`
--
ALTER TABLE `billboards`
  ADD CONSTRAINT `billboards_ibfk_1` FOREIGN KEY (`video_id`) REFERENCES `videofiles` (`video_id`),
  ADD CONSTRAINT `fk_created_by_user_bill` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `briefs`
--
ALTER TABLE `briefs`
  ADD CONSTRAINT `briefs_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `brief_budgets`
--
ALTER TABLE `brief_budgets`
  ADD CONSTRAINT `brief_budgets_ibfk_1` FOREIGN KEY (`brief_id`) REFERENCES `briefs` (`brief_id`),
  ADD CONSTRAINT `brief_budgets_ibfk_2` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`),
  ADD CONSTRAINT `brief_budgets_ibfk_3` FOREIGN KEY (`state_id`) REFERENCES `states` (`state_id`),
  ADD CONSTRAINT `brief_budgets_ibfk_4` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`zone_id`);

--
-- Constraints for table `cities`
--
ALTER TABLE `cities`
  ADD CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `states` (`state_id`);

--
-- Constraints for table `plans`
--
ALTER TABLE `plans`
  ADD CONSTRAINT `plans_ibfk_1` FOREIGN KEY (`brief_id`) REFERENCES `briefs` (`brief_id`),
  ADD CONSTRAINT `plans_ibfk_2` FOREIGN KEY (`budget_id`) REFERENCES `brief_budgets` (`budget_id`),
  ADD CONSTRAINT `plans_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `plans_ibfk_4` FOREIGN KEY (`video_id`) REFERENCES `videofiles` (`video_id`);

--
-- Constraints for table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `states_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`zone_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Constraints for table `user_areas`
--
ALTER TABLE `user_areas`
  ADD CONSTRAINT `user_areas_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_areas_ibfk_2` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`zone_id`),
  ADD CONSTRAINT `user_areas_ibfk_3` FOREIGN KEY (`state_id`) REFERENCES `states` (`state_id`),
  ADD CONSTRAINT `user_areas_ibfk_4` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`);

--
-- Constraints for table `videofiles`
--
ALTER TABLE `videofiles`
  ADD CONSTRAINT `videofiles_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`zone_id`),
  ADD CONSTRAINT `videofiles_ibfk_2` FOREIGN KEY (`state_id`) REFERENCES `states` (`state_id`),
  ADD CONSTRAINT `videofiles_ibfk_3` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`),
  ADD CONSTRAINT `videofiles_ibfk_4` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
