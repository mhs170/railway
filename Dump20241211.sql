CREATE DATABASE  IF NOT EXISTS `cs336project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cs336project`;
-- MySQL dump 10.13  Distrib 8.0.40, for macos14 (x86_64)
--
-- Host: localhost    Database: cs336project
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `username` varchar(20) NOT NULL,
  `ssn` varchar(11) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('admin','9999');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_representatives`
--

DROP TABLE IF EXISTS `customer_representatives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_representatives` (
  `username` varchar(20) NOT NULL,
  `ssn` varchar(11) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `customer_representatives_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_representatives`
--

LOCK TABLES `customer_representatives` WRITE;
/*!40000 ALTER TABLE `customer_representatives` DISABLE KEYS */;
INSERT INTO `customer_representatives` VALUES ('rep','555');
/*!40000 ALTER TABLE `customer_representatives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `username` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES ('asmith2024','asmith2024@example.com'),('bwatson89','bwatson89@example.com'),('dchen56','dchen56@example.com'),('eclark01','eclark01@example.com'),('johndoe','johndoe@gmail.com'),('knguyen77','knguyen77@example.com'),('lstewart35','lstewart35@example.com'),('mjordan23','mjordan23@example.com'),('rpatel08','rpatel08@example.com'),('smiller20','smiller20@example.com');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has_destination`
--

DROP TABLE IF EXISTS `has_destination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has_destination` (
  `username` varchar(20) NOT NULL,
  `res_number` int NOT NULL,
  `transit_line_name` varchar(50) DEFAULT NULL,
  `station_id` int DEFAULT NULL,
  PRIMARY KEY (`username`,`res_number`),
  KEY `has_destination_ibfk_2` (`transit_line_name`,`station_id`),
  CONSTRAINT `has_destination_ibfk_1` FOREIGN KEY (`username`, `res_number`) REFERENCES `reservations` (`username`, `res_number`) ON DELETE CASCADE,
  CONSTRAINT `has_destination_ibfk_2` FOREIGN KEY (`transit_line_name`, `station_id`) REFERENCES `stops` (`transit_line_name`, `station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has_destination`
--

LOCK TABLES `has_destination` WRITE;
/*!40000 ALTER TABLE `has_destination` DISABLE KEYS */;
INSERT INTO `has_destination` VALUES ('johndoe',1,'Atlantic City Line',112),('johndoe',4,'Morris & Essex',106),('johndoe',5,'Morris & Essex',106),('dchen56',2,'North Jersey Coast',102),('dchen56',3,'Pascack Valley',106);
/*!40000 ALTER TABLE `has_destination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has_origin`
--

DROP TABLE IF EXISTS `has_origin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has_origin` (
  `username` varchar(20) NOT NULL,
  `res_number` int NOT NULL,
  `transit_line_name` varchar(50) DEFAULT NULL,
  `station_id` int DEFAULT NULL,
  PRIMARY KEY (`res_number`),
  KEY `has_origin_ibfk_1` (`username`,`res_number`),
  KEY `has_origin_ibfk_2` (`transit_line_name`,`station_id`),
  CONSTRAINT `has_origin_ibfk_1` FOREIGN KEY (`username`, `res_number`) REFERENCES `reservations` (`username`, `res_number`) ON DELETE CASCADE,
  CONSTRAINT `has_origin_ibfk_2` FOREIGN KEY (`transit_line_name`, `station_id`) REFERENCES `stops` (`transit_line_name`, `station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has_origin`
--

LOCK TABLES `has_origin` WRITE;
/*!40000 ALTER TABLE `has_origin` DISABLE KEYS */;
INSERT INTO `has_origin` VALUES ('johndoe',1,'Atlantic City Line',111),('dchen56',2,'North Jersey Coast',101),('dchen56',3,'Pascack Valley',108),('johndoe',4,'Morris & Essex',105),('johndoe',5,'Morris & Essex',105);
/*!40000 ALTER TABLE `has_origin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has_transit`
--

DROP TABLE IF EXISTS `has_transit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has_transit` (
  `username` varchar(20) NOT NULL,
  `res_number` int NOT NULL,
  `transit_line_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`,`res_number`),
  KEY `has_transit_ibfk_2` (`transit_line_name`),
  CONSTRAINT `has_transit_ibfk_1` FOREIGN KEY (`username`, `res_number`) REFERENCES `reservations` (`username`, `res_number`) ON DELETE CASCADE,
  CONSTRAINT `has_transit_ibfk_2` FOREIGN KEY (`transit_line_name`) REFERENCES `transit_lines_have` (`transit_line_name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has_transit`
--

LOCK TABLES `has_transit` WRITE;
/*!40000 ALTER TABLE `has_transit` DISABLE KEYS */;
INSERT INTO `has_transit` VALUES ('johndoe',1,'Atlantic City Line'),('johndoe',4,'Morris & Essex'),('johndoe',5,'Morris & Essex'),('dchen56',2,'North Jersey Coast'),('dchen56',3,'Pascack Valley');
/*!40000 ALTER TABLE `has_transit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `parent_id` int DEFAULT NULL,
  `type` enum('question','answer') NOT NULL,
  `username` varchar(20) NOT NULL,
  `body` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  CONSTRAINT `posts_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (36,NULL,'question','johndoe',''),(37,NULL,'question','johndoe',''),(38,NULL,'question','johndoe',''),(39,NULL,'question','johndoe',''),(40,NULL,'question','johndoe',''),(41,NULL,'question','johndoe',''),(42,NULL,'question','johndoe',''),(43,NULL,'question','johndoe',''),(44,NULL,'question','johndoe','332'),(45,NULL,'question','johndoe','tar'),(46,NULL,'question','johndoe','hey'),(47,NULL,'question','johndoe','we'),(48,NULL,'question','johndoe','da'),(49,NULL,'question','johndoe','rte'),(50,44,'answer','rep','yes');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation_portfolio`
--

DROP TABLE IF EXISTS `reservation_portfolio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation_portfolio` (
  `username` varchar(20) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `reservation_portfolio_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation_portfolio`
--

LOCK TABLES `reservation_portfolio` WRITE;
/*!40000 ALTER TABLE `reservation_portfolio` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservation_portfolio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `username` varchar(20) NOT NULL,
  `res_number` int NOT NULL,
  `total_fare` float DEFAULT NULL,
  `date` date DEFAULT NULL,
  `dateOfDeparture` date DEFAULT NULL,
  PRIMARY KEY (`username`,`res_number`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES ('dchen56',2,12.375,'2024-12-10','2024-12-09'),('dchen56',3,14.25,'2024-12-10','2024-12-11'),('johndoe',1,21,'2024-12-10','2024-12-09'),('johndoe',4,12.25,'2024-12-11','2024-12-11'),('johndoe',5,12.25,'2024-12-11','2024-12-11');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` int NOT NULL,
  `station_name` varchar(50) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `state_abb` char(2) DEFAULT NULL,
  PRIMARY KEY (`station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (14,'Newark Penn','Newark','NJ'),(22,'Raritan','Raritan','NJ'),(33,'Somerville','Somerville','NJ'),(101,'Long Branch','Long Branch','NJ'),(102,'New York Penn','New York','NY'),(104,'Newark Penn','Newark','NJ'),(105,'Dover','Dover','NJ'),(106,'Hoboken','Hoboken','NJ'),(107,'Trenton','Trenton','NJ'),(108,'Spring Valley','Spring Valley','NY'),(109,'Suffern','Suffern','NY'),(110,'Secaucus','Secaucus','NJ'),(111,'Atlantic City','Atlantic City','NJ'),(112,'Philadelphia 30th','Philadelphia','PA'),(113,'Montclair State','Montclair','NJ');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stops`
--

DROP TABLE IF EXISTS `stops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stops` (
  `transit_line_name` varchar(50) NOT NULL,
  `station_id` int NOT NULL,
  `stop_time` time DEFAULT NULL,
  PRIMARY KEY (`transit_line_name`,`station_id`),
  KEY `station_id` (`station_id`),
  CONSTRAINT `stops_ibfk_1` FOREIGN KEY (`transit_line_name`) REFERENCES `transit_lines_have` (`transit_line_name`) ON DELETE CASCADE,
  CONSTRAINT `stops_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `stations` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stops`
--

LOCK TABLES `stops` WRITE;
/*!40000 ALTER TABLE `stops` DISABLE KEYS */;
INSERT INTO `stops` VALUES ('Atlantic City Line',111,'07:00:00'),('Atlantic City Line',112,'08:20:00'),('Main/Bergen County',109,'06:25:00'),('Main/Bergen County',110,'07:40:00'),('Montclair-Boonton',102,'08:35:00'),('Montclair-Boonton',113,'07:15:00'),('Morris & Essex',105,'08:10:00'),('Morris & Essex',106,'09:30:00'),('North Jersey Coast',101,'07:00:00'),('North Jersey Coast',102,'08:15:00'),('Northeast Corridor',102,'07:50:00'),('Northeast Corridor',107,'06:20:00'),('Pascack Valley',106,'08:50:00'),('Pascack Valley',108,'07:30:00'),('Raritan Valley',103,'06:30:00'),('Raritan Valley',104,'07:45:00');
/*!40000 ALTER TABLE `stops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `train_id` int NOT NULL,
  PRIMARY KEY (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (1),(2),(11),(32),(212),(1259),(1764),(2312),(3927),(4683),(4721),(6523),(8123),(21111);
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transit_lines_have`
--

DROP TABLE IF EXISTS `transit_lines_have`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transit_lines_have` (
  `transit_line_name` varchar(50) NOT NULL,
  `train_id` int DEFAULT NULL,
  `origin` varchar(50) DEFAULT NULL,
  `destination` varchar(50) DEFAULT NULL,
  `arrival` datetime DEFAULT NULL,
  `departure` datetime DEFAULT NULL,
  `fare` float DEFAULT NULL,
  `num_stops` int DEFAULT NULL,
  PRIMARY KEY (`transit_line_name`),
  KEY `train_id` (`train_id`),
  CONSTRAINT `transit_lines_have_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transit_lines_have`
--

LOCK TABLES `transit_lines_have` WRITE;
/*!40000 ALTER TABLE `transit_lines_have` DISABLE KEYS */;
INSERT INTO `transit_lines_have` VALUES ('Atlantic City Line',4683,'Atlantic City','Philadelphia 30th','2024-12-10 08:20:00','2024-12-09 07:00:00',10.5,7),('Main/Bergen County',1764,'Suffern','Secaucus','2024-12-10 07:40:00','2024-12-10 06:25:00',12,6),('Montclair-Boonton',8123,'Montclair State','New York Penn','2024-12-10 08:35:00','2024-12-11 07:15:00',15,11),('Morris & Essex',6523,'Dover','Hoboken','2024-12-10 09:30:00','2024-12-11 08:10:00',12.25,10),('North Jersey Coast',2312,'Long Branch','New York Penn','2024-12-10 08:15:00','2024-12-09 07:00:00',16.5,12),('Northeast Corridor',3927,'Trenton','New York Penn','2024-12-10 07:50:00','2024-12-09 06:20:00',17,13),('Pascack Valley',1259,'Spring Valley','Hoboken','2024-12-10 08:50:00','2024-12-11 07:30:00',14.25,9),('Raritan Valley',4721,'Raritan','Newark Penn','2024-12-10 07:45:00','2024-12-10 06:30:00',10.75,8);
/*!40000 ALTER TABLE `transit_lines_have` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `f_name` varchar(20) DEFAULT NULL,
  `l_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('admin','pass','first','last'),('asmith2024','pass','Alice','Smith'),('bwatson89','pass','Brian','Watson'),('dchen56','pass','David','Chen'),('eclark01','pass','Emma','Clark'),('johndoe','pass','John','Doe'),('knguyen77','pass','Kimberly','Nguyen'),('lstewart35','pass','Laura','Stewart'),('mjordan23','pass','Michael','Jordan'),('rep','pass','first','last'),('rpatel08','pass','Raj','Patel'),('smiller20','pass','Sarah','Miller');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-11  0:38:55
