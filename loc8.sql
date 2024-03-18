-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 18, 2024 at 05:47 PM
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
(6, 'new york city', 9);

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
(3, 'superadmin');

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
(9, 'new york state', 5);

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
  `created_by_user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `role_id`, `first_name`, `last_name`, `employee_id`, `zone_id`, `created_at`, `updated_at`, `created_by_user_id`) VALUES
(1, 'john@mail.com', '$2b$12$LGEvisGVlhfcCOF0R3KGD.EJNP4TZOyCv89zgHkbrC3Ucb5aO6x76', 3, 'John', 'Doe', '12345', 1, '2024-03-06 18:00:33', '2024-03-08 04:40:24', 0),
(9, 'anushthakumari12345@gmail.com', '$2b$12$qe2C.Rdodi2pDi3xxQeiGOe8GxQdg0ERQQtYh9oPQr1oDFXq84qE.', 1, 'anushtha', 'pandit', '89562', 1, '2024-03-10 13:40:31', '2024-03-10 13:40:31', 0),
(13, 'admin@mail.com', '$2b$12$7yfRX7.kLFAtOD7nvpIj7u76YbB20irAqQmTUpYV.8zYhccohU2sq', 2, 'user', 'admin', '123456', 1, '2024-03-17 14:28:39', '2024-03-17 14:28:39', 0),
(14, 'yo@mail.com', '$2b$12$rIJIEx7XSbKVubj4q5W32uiVP9pbFRs4vjz8RI7rJ1cMiXKai5VHa', 2, 'new', 'admin', '1234565', 2, '2024-03-17 14:40:42', '2024-03-17 14:40:42', 0),
(19, 'planner@admin.com', '$2b$12$vsqf/Nc77zLxi8Lpo83BH.T.8Q.oaJ11xRqfEltw8GIOnATIJ//Oe', 1, 'planner', 'admin', '78952', 1, '2024-03-17 15:52:29', '2024-03-17 15:52:29', 13),
(20, 'yeys@mail.com', '$2b$12$euK6VANjCvqQNCC3C4rEaO66x1mZ4STi6ZtGFgz4eUGsKYtGzVFpS', 2, 'yesy', 'yesy', '798465', 3, '2024-03-17 17:45:31', '2024-03-18 14:56:32', 1);

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
-- Indexes for table `billboards`
--
ALTER TABLE `billboards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `video_id` (`video_id`),
  ADD KEY `fk_created_by_user_bill` (`created_by_user_id`);

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
  ADD KEY `role_id` (`role_id`);

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
  MODIFY `city_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `state_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `zones`
--
ALTER TABLE `zones`
  MODIFY `zone_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billboards`
--
ALTER TABLE `billboards`
  ADD CONSTRAINT `billboards_ibfk_1` FOREIGN KEY (`video_id`) REFERENCES `videofiles` (`video_id`),
  ADD CONSTRAINT `fk_created_by_user_bill` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`);

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
