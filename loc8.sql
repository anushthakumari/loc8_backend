-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2024 at 09:00 AM
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
('21dff05c-009e-4016-a4eb-fe82062f561d', 29, 'bafca95f-bc99-44c3-bbeb-138570dbe71b');

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
('2de1a75f-c768-4989-810c-c92fc8a45583', '1c7f09c5-74b6-40a9-893d-93c5fd643340', 3.83333, 37.7746, 0.233333, 3.13333, 0.466667, 0, 60.0628, 126.889, 72.5264, 0, 1.40527, 0.707758, 4, '2024-03-18 16:22:03', 1),
('517f80e7-a2ed-45f4-8f12-00b6227aad54', 'a3634162-fad6-41ff-8f96-1b415758d662', 3.83333, 37.7746, 0.233333, 3.13333, 0.466667, 0, 60.0628, 126.889, 72.5264, 0, 1.40527, 0.707758, 8, '2024-03-18 16:27:08', 1),
('8ec11a15-acfa-4dc4-9651-a188002e7c4a', '1c7f09c5-74b6-40a9-893d-93c5fd643340', 4.36667, 42.2614, 0, 1.83333, 1.56667, 0.766667, 0, 66.924, 75.9757, 87.507, 2.39415, 0.706747, 2, '2024-03-18 16:21:45', 1),
('96f5b5ab-b45b-480e-bc8d-b0705ff390bf', 'a3634162-fad6-41ff-8f96-1b415758d662', 2, 42.2873, 0, 0, 0.966667, 1.03333, 0, 0, 77.9903, 86.8466, 3.0619, 0.670036, 5, '2024-03-18 16:26:57', 1),
('a24e102d-dc0d-46a0-96a2-26ff9ed98b7c', 'a3634162-fad6-41ff-8f96-1b415758d662', 4.36667, 42.2614, 0, 1.83333, 1.56667, 0.766667, 0, 66.924, 75.9757, 87.507, 2.39415, 0.706747, 6, '2024-03-18 16:26:57', 1),
('fcb482ca-ae0b-4404-8e2e-5ab9b69225ae', '1c7f09c5-74b6-40a9-893d-93c5fd643340', 2, 42.2873, 0, 0, 0.966667, 1.03333, 0, 0, 77.9903, 86.8466, 3.0619, 0.670036, 1, '2024-03-18 16:21:45', 1);

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
('49e8478a-0fff-43a8-9835-1bd5bc3f29a1', 'category', 'brand', '49e8478a-0fff-43a8-9835-1bd5bc3f29a1Logo1.png', 'target', 'camo', 'med', 0, NULL, NULL, 0, '2024-03-26 17:53:55', 1),
('5434544c-3308-407a-ae0c-c5c6aa6efb1b', 'car', 'brand', '5434544c-3308-407a-ae0c-c5c6aa6efb1bloan-1.jpg', '23-male', 'camp', 'med', 0, NULL, NULL, 0, '2024-03-30 06:36:36', 31);

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
('3f6a5ba5-af5b-40d0-8d85-9b2b6c9ba306', '5434544c-3308-407a-ae0c-c5c6aa6efb1b', 2, 10, 7, 8000),
('89b83f87-e27a-4982-bc23-a107475192fb', '49e8478a-0fff-43a8-9835-1bd5bc3f29a1', 5, 9, 6, 8000),
('bafca95f-bc99-44c3-bbeb-138570dbe71b', '5434544c-3308-407a-ae0c-c5c6aa6efb1b', 5, 9, 6, 5000);

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
  `zone_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by_user_id` int(11) NOT NULL,
  `state_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role_id`, `first_name`, `last_name`, `employee_id`, `zone_id`, `created_at`, `updated_at`, `created_by_user_id`, `state_id`, `city_id`) VALUES
(1, 'john@mail.com', '$2b$12$LGEvisGVlhfcCOF0R3KGD.EJNP4TZOyCv89zgHkbrC3Ucb5aO6x76', 4, 'John', 'Doe', '12345', 1, '2024-03-06 18:00:33', '2024-03-20 15:38:18', 0, NULL, NULL),
(13, 'admin@mail.com', '$2b$12$7yfRX7.kLFAtOD7nvpIj7u76YbB20irAqQmTUpYV.8zYhccohU2sq', 2, 'user', 'admin', '123456', 1, '2024-03-17 14:28:39', '2024-03-17 14:28:39', 0, NULL, NULL),
(14, 'yo@mail.com', '$2b$12$rIJIEx7XSbKVubj4q5W32uiVP9pbFRs4vjz8RI7rJ1cMiXKai5VHa', 2, 'new', 'admin', '1234565', 2, '2024-03-17 14:40:42', '2024-03-17 14:40:42', 0, NULL, NULL),
(19, 'planner@admin.com', '$2b$12$vsqf/Nc77zLxi8Lpo83BH.T.8Q.oaJ11xRqfEltw8GIOnATIJ//Oe', 1, 'planner', 'admin', '78952', 1, '2024-03-17 15:52:29', '2024-03-17 15:52:29', 13, NULL, NULL),
(20, 'yeys@mail.com', '$2b$12$euK6VANjCvqQNCC3C4rEaO66x1mZ4STi6ZtGFgz4eUGsKYtGzVFpS', 2, 'yesy', 'yesy', '798465', 1, '2024-03-17 17:45:31', '2024-03-23 12:10:39', 1, NULL, NULL),
(29, 'ref@mail.com', '$2b$12$nH2hImpap6vdJV6jyCsTSOULk97PuuIoPrUXNGZ2DCNvziO2aVoeK', 1, 'rem', 'rem', 'ty79845', 5, '2024-03-21 17:53:07', '2024-03-23 11:52:15', 1, 9, 6),
(31, 'controller1@mail.com', '$2b$12$0Y1ZorF5R/EaOzA5J7uAr.yZ4mvi8WPFJvvwnjMZ2TzGTuF4Pf3kW', 3, 'controller', 'user', 'control1', 1, '2024-03-23 12:50:08', '2024-03-23 12:50:08', 1, NULL, NULL),
(32, 'testplanner@mail.com', '$2b$12$dpTVjq6VPeNqqeqBVq1cB.tG41XjySZr0uXst5zmEcHkxGtHfMTnO', 1, 'test', 'test', 'test12', 5, '2024-03-26 18:46:39', '2024-03-26 18:46:39', 1, NULL, NULL);

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
('1c7f09c5-74b6-40a9-893d-93c5fd643340', '751ef1b9-4402-4ffa-9a30-8e91c3eb10b9.mp4', 5, 9, 6, '2024-03-18 16:21:45', 1, './instance/751ef1b9-4402-4ffa-9a30-8e91c3eb10b9.mp4'),
('a3634162-fad6-41ff-8f96-1b415758d662', '12b6fe9c-73e2-4156-abb5-8e5015bc9355.mp4', 5, 9, 6, '2024-03-18 16:26:57', 1, './instance/12b6fe9c-73e2-4156-abb5-8e5015bc9355.mp4');

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
  ADD KEY `role_id` (`role_id`),
  ADD KEY `fk_user_sate` (`state_id`),
  ADD KEY `fk_user_city` (`city_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

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
-- Constraints for table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `states_ibfk_1` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`zone_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_city` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`),
  ADD CONSTRAINT `fk_user_sate` FOREIGN KEY (`state_id`) REFERENCES `states` (`state_id`),
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

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
