-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 18, 2019 at 11:40 AM
-- Server version: 10.1.41-MariaDB-cll-lve
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shargtba_mybarber`
--

-- --------------------------------------------------------

--
-- Table structure for table `RECOVER_PSWD`
--

CREATE TABLE `RECOVER_PSWD` (
  `EMAIL` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `TOKEN` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `RECOVER_PSWD`
--

INSERT INTO `RECOVER_PSWD` (`EMAIL`, `TOKEN`) VALUES
('i3boodi03@gmail.com', '172ebcc675a92f3522396d8a103a1f322cd08e721ac5afbab9cab2e92f893f00c598280d2c1c49cd22b27533b6fce2158c8c'),
('i3boodi03@gmail.com', '9288f29d45be3d2f50cd934f613536b878f6fef13275aaaec48321e8a4a192cc12147e46341e7c07fad7bb4650ba2b3db0d7'),
('i3boodi03@gmail.com', '49f11e0b47b82fc7215c90c1cb0dfd36885159ddf3a37176b057720a511d612a0912dc5fc338f42cfb540d71609e5863553b'),
('i3boodi03@gmail.com', '6b2126a1684be3687ba7a4173d9c2a1f0fc94dc0ca16c55cebcebe003eea9983a104d6db0e46ab9f88fc893e8caec5d485e0');

-- --------------------------------------------------------

--
-- Table structure for table `USER`
--

CREATE TABLE `USER` (
  `NAME` varchar(150) NOT NULL,
  `EMAIL` varchar(100) NOT NULL,
  `PASSWORD` varchar(60) NOT NULL,
  `PPIC` varchar(255) NOT NULL,
  `DATE` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `VERIFY` varchar(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`NAME`, `EMAIL`, `PASSWORD`, `PPIC`, `DATE`, `VERIFY`) VALUES
('testcamera', '858684f806@emailcu.icu', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/a30d266b6548397c33d720405b4841e4.jpeg', '2019-11-18 15:57:41.174903', '1'),
('testnopic', '48b9cd94c4@emailcu.icu', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/profilepic.png', '2019-11-18 15:34:11.162267', '1'),
('testwgallery', '72be3c9895@emailcu.icu', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/f05ff2f3eae6da00cf5cd32dccd6e52b.jpeg', '2019-11-18 15:53:04.563718', '1'),
('abdullah', 'i3boodi03@gmail.com', '05fe7461c607c33229772d402505601016a7d0ea', 'https://sharpns.net/mybarber3/images/72933d82eae9c34ad1d38210b31ae92a.jpeg', '2019-11-13 19:14:01.899698', '1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `RECOVER_PSWD`
--
ALTER TABLE `RECOVER_PSWD`
  ADD UNIQUE KEY `TOKEN` (`TOKEN`);

--
-- Indexes for table `USER`
--
ALTER TABLE `USER`
  ADD PRIMARY KEY (`NAME`),
  ADD UNIQUE KEY `EMAIL` (`EMAIL`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
