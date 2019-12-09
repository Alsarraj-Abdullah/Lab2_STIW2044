-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 08, 2019 at 10:04 PM
-- Server version: 10.1.43-MariaDB-cll-lve
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
-- Table structure for table `BARBER`
--

CREATE TABLE `BARBER` (
  `NAME` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `PHONE` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `ADDRESS` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `PRICE` int(6) NOT NULL,
  `PPIC` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `BARBER`
--

INSERT INTO `BARBER` (`NAME`, `PHONE`, `ADDRESS`, `PRICE`, `PPIC`) VALUES
('Jesse L Hines', '+601155579', 'L2-02, Level 2, Robinsons, Shoppes At Four Seasons Place, 145, Jalan Ampang, 50450 Kuala Lumpur', 200, 'https://sharpns.net/mybarber3/images/barber1.png'),
('Christopher A Mintz', '+601255593', 't1, 29, Jalan Riong, Bangsar, 59100 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur', 300, 'https://sharpns.net/mybarber3/images/barber2.png'),
('Joseph C Harris', '+601355586', '51, Jalan Dwitasik Dataran Dwitasik, Bandar Sri Permaisuri, 56000 Cheras, Wilayah Persekutuan Kuala Lumpur', 100, 'https://sharpns.net/mybarber3/images/barber3.png'),
('Todd Y Taylor', '+601355572', '14 Jalan Liew Weng Chee, Off, Jalan Yap Kwan Seng, 50450 Kuala Lumpur', 155, 'https://sharpns.net/mybarber3/images/barber4.png'),
('Robert B Myrick', '+601455531', '18, Jalan 7/23e, Taman Danau Kota, 53100 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur', 500, 'https://sharpns.net/mybarber3/images/barber5.png'),
('Jacob M Acosta', '+601455517', '2nd floor, Wisma Central, Lot 3.01A-1, 147, Jalan Ampang, Kuala Lumpur, 50450 Kuala Lumpur, Federal Territory of Kuala Lumpur', 250, 'https://sharpns.net/mybarber3/images/barber6.png');

-- --------------------------------------------------------

--
-- Table structure for table `PAYMENT`
--

CREATE TABLE `PAYMENT` (
  `ORDERID` varchar(50) NOT NULL,
  `USERID` varchar(50) NOT NULL,
  `TOTAL` varchar(6) NOT NULL,
  `DATE` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `PAYMENT`
--

INSERT INTO `PAYMENT` (`ORDERID`, `USERID`, `TOTAL`, `DATE`) VALUES
('09122019105531-17v1360NEy', 'i3boodi03@gmail.com', '50', '2019-12-08 21:55:44.202199');

-- --------------------------------------------------------

--
-- Table structure for table `RECOVER_PSWD`
--

CREATE TABLE `RECOVER_PSWD` (
  `EMAIL` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `TOKEN` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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
  `VERIFY` varchar(1) NOT NULL,
  `BALANCE` int(11) DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`NAME`, `EMAIL`, `PASSWORD`, `PPIC`, `DATE`, `VERIFY`, `BALANCE`) VALUES
('testcamera', '858684f806@emailcu.icu', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/a30d266b6548397c33d720405b4841e4.jpeg', '2019-11-18 15:57:41.174903', '1', 0),
('testnopic', '48b9cd94c4@emailcu.icu', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/profilepic.png', '2019-11-18 15:34:11.162267', '1', 0),
('testwgallery', '72be3c9895@emailcu.icu', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/f05ff2f3eae6da00cf5cd32dccd6e52b.jpeg', '2019-11-18 15:53:04.563718', '1', 0),
('tttt', 'ttttt@ggg.com', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/profilepic.png', '2019-11-18 17:19:27.738070', '0', 0),
('abdullah', 'i3boodi03@gmail.com', '601f1889667efaebb33b8c12572835da3f027f78', 'https://sharpns.net/mybarber3/images/72933d82eae9c34ad1d38210b31ae92a.jpeg', '2019-11-13 19:14:01.899698', '1', 4700),
('TEST222', 'wwww@fgffdgg.jj', 'b2944a2a3f3b3094b609451cdb3c4931555095ca', 'https://sharpns.net/mybarber3/images/062f19c392672b21292e98764331ccd8.jpeg', '2019-12-08 18:20:12.284196', '0', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `BARBER`
--
ALTER TABLE `BARBER`
  ADD PRIMARY KEY (`PHONE`);

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
