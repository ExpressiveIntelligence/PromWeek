-- phpMyAdmin SQL Dump
-- version 2.11.10
-- http://www.phpmyadmin.net
--
-- Host: db-01.soe.ucsc.edu
-- Generation Time: Jun 08, 2011 at 12:28 PM
-- Server version: 5.1.51
-- PHP Version: 5.3.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `promweek`
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
  PRIMARY KEY (`achievementCount`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Table structure for table `LevelTraces`
--

CREATE TABLE IF NOT EXISTS `LevelTraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID for a Level Trace (will be used in AchievementsUnlocked table)',
  `userId` int(11) NOT NULL COMMENT 'foreign key to Users:id',
  `createdAt` datetime NOT NULL COMMENT 'When this trace was made',
  `numTurns` int(11) NOT NULL COMMENT 'Number of turns this trace played',
  `story` varchar(50) NOT NULL COMMENT 'The story this trace revolves around',
  `level` varchar(50) NOT NULL COMMENT 'The level this trace is',
  `filename` varchar(255) NOT NULL,
  KEY `userId` (`userId`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `facebookid` varchar(100) NOT NULL,
  `playCount` int(11) NOT NULL,
  `uniqueVisits` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `LevelTraces`
--
ALTER TABLE `LevelTraces`
  ADD CONSTRAINT `LevelTraces_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `Users` (`id`);
