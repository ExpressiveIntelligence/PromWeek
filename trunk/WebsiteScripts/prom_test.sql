-- phpMyAdmin SQL Dump
-- version 3.3.7deb5build0.10.10.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 08, 2011 at 09:50 PM
-- Server version: 5.1.49
-- PHP Version: 5.3.3-1ubuntu9.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `prom_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `AchievementsUnlocked`
--

CREATE TABLE IF NOT EXISTS `AchievementsUnlocked` (
  `achievementCount` int(11) NOT NULL AUTO_INCREMENT COMMENT 'I had to add a primary key that didn''t fit into any of the other ones',
  `userId` int(11) NOT NULL COMMENT 'The userID of who this entry belongs to',
  `achievementId` int(11) NOT NULL COMMENT 'The achievement number taken from our achievements list',
  `levelTraceId` int(11) DEFAULT NULL COMMENT 'LevelTraces:id, points to which level trace it was unlocked from',
  PRIMARY KEY (`achievementCount`),
  KEY `userId` (`userId`),
  KEY `levelTraceId` (`levelTraceId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `AchievementsUnlocked`
--

INSERT INTO `AchievementsUnlocked` (`achievementCount`, `userId`, `achievementId`, `levelTraceId`) VALUES
(1, 1, 1, NULL),
(2, 1, 2, NULL),
(3, 1, 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `LevelTraceAnalysis`
--

CREATE TABLE IF NOT EXISTS `LevelTraceAnalysis` (
  `HashKey` varchar(512) NOT NULL,
  `LTID` int(11) NOT NULL,
  UNIQUE KEY `HashKey` (`HashKey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `LevelTraceAnalysis`
--


-- --------------------------------------------------------

--
-- Table structure for table `LevelTraces`
--

CREATE TABLE IF NOT EXISTS `LevelTraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID for a Level Trace (will be used in AchievementsUnlocked table)',
  `userId` int(11) NOT NULL COMMENT 'foreign key to Users:id',
  `createdAt` date NOT NULL COMMENT 'When this trace was made',
  `numTurns` int(11) NOT NULL COMMENT 'Number of turns this trace played',
  `story` varchar(50) NOT NULL COMMENT 'The story this trace revolves around',
  `level` varchar(50) NOT NULL COMMENT 'The level this trace is',
  `rulesTrue` varchar(25) NOT NULL COMMENT 'The rules that wound up being true. Using the numbers from the rules list',
  KEY `userId` (`userId`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `LevelTraces`
--


-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
  `id` int(11) NOT NULL,
  `facebookid` varchar(100) NOT NULL,
  `playCount` int(11) NOT NULL,
  `uniqueVisits` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`id`, `facebookid`, `playCount`, `uniqueVisits`) VALUES
(1, '100000145644104', 5, 5),
(2, '1845692369', 5, 10);
