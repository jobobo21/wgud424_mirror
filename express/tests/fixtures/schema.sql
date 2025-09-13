-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: db-mysql-nyc3-24195-do-user-2303882-0.h.db.ondigitalocean.com    Database: D424
-- ------------------------------------------------------
-- Server version	8.0.35

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

-- SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'd2e12e14-7a0c-11f0-9612-22d0c7b7b446:1-1369';

--
-- Table structure for table `assessment_types`
--

DROP TABLE IF EXISTS `assessment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_types` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Types of assessments used at WGU';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_types`
--

LOCK TABLES `assessment_types` WRITE;
/*!40000 ALTER TABLE `assessment_types` DISABLE KEYS */;
INSERT INTO `assessment_types` VALUES (1,'Objective Assessment','Computer-scored assessments used to verify competency','2025-08-23 18:44:43'),(2,'Performance Assessment','Individual work created by students, scored by faculty according to rubrics','2025-08-23 18:44:43');
/*!40000 ALTER TABLE `assessment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments`
--

DROP TABLE IF EXISTS `assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `name` varchar(200) NOT NULL,
  `type` enum('O','P') NOT NULL,
  `description` text,
  `passing_score` decimal(5,2) DEFAULT NULL,
  `max_attempts` int DEFAULT '3',
  `time_limit_minutes` int DEFAULT NULL,
  `is_proctored` tinyint(1) DEFAULT '0',
  `is_required_to_pass` tinyint(1) DEFAULT '1',
  `sequence_order` int DEFAULT '1',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_course_sequence` (`course_id`,`sequence_order`),
  KEY `idx_assessments_course` (`course_id`),
  KEY `idx_assessments_type` (`type`),
  KEY `idx_assessments_active` (`is_active`),
  CONSTRAINT `assessments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Individual assessments within courses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments`
--

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;
INSERT INTO `assessments` VALUES (1,1,'Communication Final Assessment','O','Comprehensive test on communication principles and practices',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(2,2,'Essay Portfolio','P','Portfolio of academic essays demonstrating writing proficiency',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(3,3,'Research Paper','P','Comprehensive research paper with proper citations and argumentation',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(4,4,'College Algebra Final Assessment','O','Comprehensive algebraic problem-solving assessment',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(5,5,'Applied Statistics Final Assessment','O','Comprehensive assessment of statistical concepts and applications',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(6,6,'Integrated Natural Sciences Final Assessment','O','Comprehensive science concepts examination',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(7,7,'American Politics Final Assessment','O','Assessment of US government and political systems knowledge',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(8,8,'Introduction to Geography Final Assessment','O','Physical and human geography comprehensive exam',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(9,9,'Business Success Portfolio','P','Comprehensive business fundamentals project portfolio',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(10,10,'Humanities Final Assessment','O','Cultural and intellectual traditions examination',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(11,12,'Accounting Principles I Final Assessment','O','Comprehensive test on fundamental accounting principles',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(12,13,'Accounting Principles II Final Assessment','O','Advanced accounting concepts and managerial accounting exam',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(13,14,'Financial and Managerial Accounting Final Assessment','O','Integration of financial and managerial accounting assessment',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(14,15,'Intermediate Accounting I Final Assessment','O','Advanced financial accounting theory examination',80.00,3,180,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(15,16,'Intermediate Accounting II Final Assessment','O','Complex financial accounting topics assessment',80.00,3,180,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(16,17,'Advanced Accounting Final Assessment','O','Specialized accounting topics examination',80.00,3,180,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(17,18,'Cost and Managerial Accounting Final Assessment','O','Cost analysis and management decision-making exam',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(18,19,'Auditing Final Assessment','O','Auditing principles and professional standards exam',80.00,3,180,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(19,20,'Federal Income Tax I Final Assessment','O','Individual federal tax preparation assessment',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(20,21,'Federal Income Tax II Final Assessment','O','Business taxation and advanced tax topics exam',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(21,22,'Governmental Accounting Final Assessment','O','Government and nonprofit accounting examination',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(22,23,'Accounting Ethics Portfolio','P','Professional ethics case study analysis portfolio',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(23,24,'Accounting Information Systems Project','P','Technology applications in accounting systems project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(24,25,'Business Law Final Assessment','O','Legal environment of business examination',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(25,26,'Macroeconomics Final Assessment','O','National and international economic principles exam',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(26,27,'Microeconomics Final Assessment','O','Individual and firm economic behavior analysis exam',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(27,29,'Leadership Case Study Analysis','P','Analysis of organizational behavior scenarios and leadership challenges',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(28,30,'Operations Management Final Assessment','O','Operations and supply chain management examination',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(29,33,'Business Finance Final Assessment','O','Financial management and corporate finance exam',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(30,34,'Business Capstone Project','P','Comprehensive business strategy capstone project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(31,35,'Principles of Management Final Assessment','O','Fundamental management concepts examination',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(32,77,'Anatomy & Physiology I Final Assessment','O','Comprehensive examination of body systems',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(33,78,'Anatomy & Physiology II Final Assessment','O','Advanced anatomy and physiological processes exam',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(34,83,'Nursing Skills Demonstration','P','Practical demonstration of fundamental nursing skills',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(35,84,'Health Assessment Skills','P','Physical assessment and health history techniques demonstration',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(36,88,'Community Health Nursing Project','P','Public health and community-based nursing practice project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(37,89,'Nursing Leadership Portfolio','P','Leadership principles in nursing practice portfolio',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(38,90,'Evidence-Based Practice Project','P','Research methods and evidence-based nursing practice project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(39,66,'Critical Thinking Portfolio','P','Analytical thinking and logical reasoning project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(40,67,'Graduate Marketing Portfolio','P','Strategic marketing concepts project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(41,68,'Accounting for Managers Final Assessment','O','Financial and managerial accounting for non-accountants exam',80.00,3,120,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(42,69,'Corporate Finance Final Assessment','O','Graduate-level corporate finance and investment analysis exam',80.00,3,150,1,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(43,70,'Operations Strategy Portfolio','P','Operations strategy and process management project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(44,76,'MBA Capstone Project','P','Integrated business strategy capstone project',80.00,2,NULL,0,1,1,1,'2025-08-23 18:44:44','2025-08-23 18:44:44'),(45,103,'Introduction to Computer Science Final Assessment','O','Comprehensive exam on computer science fundamentals',80.00,3,120,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(46,104,'Programming Foundations Project','P','Programming project demonstrating basic scripting concepts',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(47,105,'Network and Security Fundamentals Final Assessment','O','Comprehensive exam on networking and security basics',80.00,3,150,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(48,106,'Web Development Portfolio','P','Website development project using HTML and CSS',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(49,107,'Database Design Project','P','Complete database design and modeling project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(50,108,'Version Control Implementation','P','Version control system setup and usage demonstration',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(51,109,'C++ Programming Portfolio','P','Advanced programming applications using C++ language',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(52,110,'Advanced Database Applications','P','Complex database queries and applications using MySQL',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(53,111,'Java OOP Project','P','Object-oriented programming project demonstrating Java fundamentals',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(54,112,'Java Framework Application','P','Advanced Java application using frameworks and UI components',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(55,113,'Back-End Development Project','P','Server-side application with database integration',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(56,114,'Advanced Java Applications','P','Multithreaded Java applications with cloud deployment',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(57,115,'Computer Architecture Final Assessment','O','Hardware organization and system design examination',80.00,3,150,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(58,116,'Data Structures and Algorithms I Final Assessment','O','Fundamental data structures and algorithms examination',80.00,3,180,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(59,117,'Advanced Algorithms Project','P','Implementation of advanced algorithms and data structures',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(60,118,'Discrete Mathematics I Final Assessment','O','Logic, Boolean algebra, and set theory examination',80.00,3,120,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(61,119,'Discrete Mathematics II Final Assessment','O','Advanced discrete mathematics and computational models exam',80.00,3,120,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(62,120,'Operating Systems Project','P','Operating system concepts implementation and analysis',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(63,121,'Calculus I Final Assessment','O','Comprehensive calculus examination with applications',80.00,3,150,1,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(64,122,'Scientific Method Laboratory Project','P','Experimental design and scientific inquiry demonstration',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(65,123,'Software Engineering Portfolio','P','Software development lifecycle and process implementation',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(66,124,'QA Testing Project','P','Quality assurance testing and methodology implementation',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(67,125,'AI Fundamentals Project','P','Artificial intelligence concepts and implementation project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(68,126,'AI Optimization Implementation','P','AI solution optimization and testing project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(69,127,'Advanced AI/ML Project','P','Complete AI/ML solution for real-world business problem',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(70,128,'Prompt Engineering Portfolio','P','Generative AI and prompt optimization project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(71,129,'Linux Administration Project','P','Linux system administration and command line proficiency',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(72,130,'Information Security Plan','P','Comprehensive security policy and implementation plan',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(73,131,'Systems Thinking Analysis','P','Complex systems analysis and solution design project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(74,132,'IT Service Management Project','P','ITIL implementation and IT service management project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(75,133,'Technology Ethics Analysis','P','Ethical decision-making framework and case study analysis',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(76,134,'Computer Science Team Capstone Project','P','Comprehensive team-based computer science project',80.00,2,NULL,0,1,1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00');
/*!40000 ALTER TABLE `assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colleges`
--

DROP TABLE IF EXISTS `colleges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `colleges` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Academic colleges/schools within WGU';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colleges`
--

LOCK TABLES `colleges` WRITE;
/*!40000 ALTER TABLE `colleges` DISABLE KEYS */;
INSERT INTO `colleges` VALUES (1,'School of Business','SOB','Business and management programs focusing on industry-relevant skills','2025-08-23 18:44:43','2025-08-23 18:44:43'),(2,'Leavitt School of Health','LSOH','Health and nursing programs with clinical components','2025-08-23 18:44:43','2025-08-23 18:44:43'),(3,'School of Technology','SOT','Information technology and computer science programs','2025-08-23 18:44:43','2025-08-23 18:44:43'),(4,'School of Education','SOE','Teacher preparation and educational leadership programs','2025-08-23 18:44:43','2025-08-23 18:44:43');
/*!40000 ALTER TABLE `colleges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competency_categories`
--

DROP TABLE IF EXISTS `competency_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competency_categories` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Categories for organizing competencies and courses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competency_categories`
--

LOCK TABLES `competency_categories` WRITE;
/*!40000 ALTER TABLE `competency_categories` DISABLE KEYS */;
INSERT INTO `competency_categories` VALUES (1,'General Education','Foundational knowledge across multiple disciplines','2025-08-23 18:44:43'),(2,'Core Program','Essential knowledge and skills for the specific program','2025-08-23 18:44:43'),(3,'Specialization','Advanced skills in specialized areas of study','2025-08-23 18:44:43'),(4,'Capstone','Integrated application of program knowledge and skills','2025-08-23 18:44:43');
/*!40000 ALTER TABLE `competency_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `course_prerequisites_view`
--

DROP TABLE IF EXISTS `course_prerequisites_view`;
/*!50001 DROP VIEW IF EXISTS `course_prerequisites_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `course_prerequisites_view` AS SELECT 
 1 AS `course_id`,
 1 AS `course_name`,
 1 AS `course_code`,
 1 AS `prerequisite_course_id`,
 1 AS `prerequisite_course_name`,
 1 AS `prerequisite_course_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL,
  `name` varchar(200) NOT NULL,
  `code` varchar(20) NOT NULL,
  `competency_units` int NOT NULL,
  `assessment_type` enum('Objective','Performance','Mixed') NOT NULL,
  `description` text,
  `competency_category_id` int DEFAULT '1',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_courses_category` (`competency_category_id`),
  KEY `idx_courses_active` (`is_active`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`competency_category_id`) REFERENCES `competency_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Individual courses with competency units and assessment information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Introduction to Communication','C464',3,'Objective','Fundamentals of effective communication in various contexts',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(2,'English Composition I','C455',3,'Performance','Development of writing skills and academic composition',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(3,'English Composition II','C456',3,'Performance','Advanced writing skills including research and argumentation',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(4,'College Algebra','C278',4,'Objective','Algebraic concepts and mathematical problem-solving',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(5,'Applied Probability and Statistics','C459',3,'Objective','Statistical analysis and probability theory applications',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(6,'Integrated Natural Sciences','C165',3,'Objective','Interdisciplinary approach to natural science concepts',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(7,'American Politics and the US Constitution','C963',3,'Objective','Structure and function of American government and political systems',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(8,'Introduction to Geography','C255',3,'Objective','Physical and human geography concepts and applications',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(9,'Fundamentals for Success in Business','C213',3,'Performance','Essential business concepts and professional skills',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(10,'Introduction to Humanities','C100',3,'Performance','Cultural, artistic, and intellectual traditions across civilizations',1,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(11,'Spreadsheets','C268',4,'Performance','Microsoft Excel for data analysis and business applications',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(12,'Principles of Accounting I','C248',4,'Objective','Fundamental accounting principles and financial statement preparation',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(13,'Principles of Accounting II','C249',4,'Objective','Advanced accounting concepts and managerial accounting principles',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(14,'Financial and Managerial Accounting','C214',4,'Objective','Integration of financial and managerial accounting concepts',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(15,'Intermediate Accounting I','C250',4,'Objective','Advanced financial accounting theory and practice',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(16,'Intermediate Accounting II','C251',4,'Objective','Complex financial accounting topics and reporting',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(17,'Advanced Accounting','C252',4,'Objective','Specialized accounting topics including partnerships and consolidations',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(18,'Cost and Managerial Accounting','C253',4,'Objective','Cost analysis and management decision-making tools',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(19,'Auditing','C254',4,'Objective','Auditing principles, procedures, and professional standards',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(20,'Federal Income Tax I','C256',4,'Objective','Individual federal income tax preparation and planning',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(21,'Federal Income Tax II','C257',4,'Objective','Business taxation and advanced tax topics',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(22,'Governmental and Not-for-Profit Accounting','C258',4,'Objective','Specialized accounting for government and nonprofit organizations',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(23,'Accounting Ethics','C259',3,'Performance','Professional ethics in accounting practice',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(24,'Accounting Information Systems','C260',4,'Performance','Technology applications in accounting systems',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(25,'Business Law','C241',4,'Objective','Legal environment of business and commercial law',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(26,'Macroeconomics','C719',3,'Objective','National and international economic principles',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(27,'Microeconomics','C718',3,'Objective','Individual and firm economic behavior analysis',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(28,'Introduction to Probability and Statistics','C951',3,'Objective','Statistical methods for business decision-making',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(29,'Organizational Behavior and Leadership','C484',4,'Performance','Human behavior in organizational settings and leadership principles',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(30,'Operations and Supply Chain Management','C720',4,'Objective','Management of operations and supply chain processes',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(31,'Global Business','C721',4,'Performance','International business environment and global strategy',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(32,'Strategic Management','C722',4,'Performance','Strategic planning and competitive analysis',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(33,'Business Finance','C723',4,'Objective','Financial management and corporate finance principles',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(34,'Capstone Project','C499',4,'Performance','Integrated application of program knowledge and skills',4,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(35,'Principles of Management','C483',4,'Objective','Fundamental management concepts and practices',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(36,'Human Resource Management Fundamentals','C232',4,'Performance','Core concepts in human resource management',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(37,'Employment Law','C238',4,'Objective','Legal aspects of employment and workplace regulations',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(38,'Compensation and Benefits','C234',4,'Performance','Design and administration of compensation systems',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(39,'Employee and Labor Relations','C235',4,'Performance','Managing employee relations and labor negotiations',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(40,'Training and Development','C236',4,'Performance','Employee training programs and professional development',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(41,'Information Technology Fundamentals','C182',3,'Objective','Basic concepts in information technology and computer systems',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(42,'Network and Security Foundations','C172',4,'Objective','Fundamentals of computer networks and cybersecurity',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(43,'Scripting and Programming Foundations','C173',3,'Performance','Introduction to programming concepts and scripting',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(44,'Web Development Foundations','C777',3,'Performance','HTML, CSS, and basic web development skills',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(45,'Introduction to Databases','C175',3,'Performance','Database design and SQL fundamentals',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(46,'Marketing Fundamentals','C212',4,'Objective','Core principles of marketing and consumer behavior',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(47,'Consumer Behavior','C215',4,'Performance','Psychology of consumer decision-making and market research',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(48,'Marketing Research','C216',4,'Performance','Research methods for marketing decision-making',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(49,'Digital Marketing','C217',4,'Performance','Online marketing strategies and digital advertising',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(50,'Brand Management','C218',4,'Performance','Building and managing brand identity and equity',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(51,'Mass Media and Society','C461',3,'Performance','Role of media in society and communication theory',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(52,'Introduction to Communication Theory','C462',3,'Performance','Theoretical foundations of human communication',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(53,'Interpersonal Communication','C463',3,'Performance','Communication in personal and professional relationships',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(54,'Public Speaking','C465',3,'Performance','Effective oral presentation and public speaking skills',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(55,'Corporate Finance','C724',4,'Objective','Advanced corporate financial management and analysis',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(56,'Investment Analysis','C725',4,'Objective','Securities analysis and portfolio management principles',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(57,'Financial Markets and Institutions','C726',4,'Objective','Structure and function of financial markets and institutions',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(58,'Healthcare Delivery Systems','C210',4,'Performance','Organization and delivery of healthcare services',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(59,'Healthcare Economics','C211',4,'Objective','Economic principles applied to healthcare markets',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(60,'Healthcare Law and Ethics','C727',4,'Performance','Legal and ethical issues in healthcare practice',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(61,'Supply Chain Strategy','C728',4,'Performance','Strategic planning for supply chain operations',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(62,'Procurement and Sourcing','C729',4,'Performance','Strategic sourcing and supplier management',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(63,'Introduction to UX Design','C730',4,'Performance','Fundamentals of user experience design principles',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(64,'User Research Methods','C731',4,'Performance','Research techniques for understanding user needs',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(65,'Information Architecture','C732',4,'Performance','Organizing and structuring digital information',3,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(66,'Critical Thinking and Logic','C168',3,'Performance','Analytical thinking and logical reasoning skills',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(67,'Marketing','C712',3,'Performance','Strategic marketing concepts for graduate level',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(68,'Accounting for Decision Makers','C570',3,'Objective','Financial and managerial accounting for non-accountants',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(69,'Finance','C714',3,'Objective','Corporate finance and investment analysis',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(70,'Operations Management','C715',3,'Performance','Operations strategy and process management',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(71,'Information Systems Management','C716',3,'Performance','Strategic use of information systems in business',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(72,'Legal Environment of Business','C717',3,'Objective','Legal issues affecting business operations',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(73,'Human Resource Management','C237',3,'Performance','Strategic human resource management practices',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(74,'Globalization','C750',3,'Performance','Global business environment and international strategy',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(75,'Strategy','C751',3,'Performance','Strategic management and competitive advantage',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(76,'MBA Capstone','C501',4,'Performance','Integrated business strategy capstone project',4,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(77,'Anatomy and Physiology I','C405',3,'Objective','Structure and function of human body systems',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(78,'Anatomy and Physiology II','C406',3,'Objective','Advanced anatomy and physiological processes',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(79,'Microbiology','C453',3,'Objective','Microbial biology and infectious disease principles',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(80,'Medical Terminology','C772',3,'Objective','Healthcare terminology and medical language',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(81,'Pathophysiology','C493',3,'Objective','Disease processes and pathological changes',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(82,'Pharmacology','C489',3,'Objective','Drug action and therapeutic applications',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(83,'Nursing Fundamentals','C475',6,'Performance','Basic nursing concepts and clinical skills',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(84,'Health Assessment','C430',4,'Performance','Physical assessment and health history techniques',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(85,'Medical-Surgical Nursing I','C155',6,'Performance','Care of adult patients with medical and surgical conditions',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(86,'Mental Health Nursing','C156',4,'Performance','Psychiatric nursing and mental health interventions',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(87,'Maternal-Child Nursing','C157',4,'Performance','Obstetric and pediatric nursing care',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(88,'Community Health Nursing','C158',4,'Performance','Public health and community-based nursing practice',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(89,'Nursing Leadership and Management','C490',3,'Performance','Leadership principles in nursing practice',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(90,'Nursing Research and Evidence-Based Practice','C361',3,'Performance','Research methods and evidence-based nursing practice',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(91,'Introduction to Psychology','C958',3,'Objective','Fundamental concepts in psychological science',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(92,'Research Methods in Psychology','C959',4,'Performance','Scientific methods in psychological research',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(93,'Developmental Psychology','C960',3,'Objective','Human development across the lifespan',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(94,'Abnormal Psychology','C961',3,'Objective','Psychological disorders and mental health conditions',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(95,'Social Psychology','C962',3,'Objective','Social influences on behavior and cognition',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(96,'Introduction to Health Information Management','C372',4,'Performance','Healthcare data management and information systems',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(97,'Health Data Management','C373',4,'Performance','Collection, analysis, and management of health data',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(98,'Electronic Health Records','C374',4,'Performance','Electronic health record systems and implementation',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(99,'Introduction to Public Health','C376',3,'Performance','Public health principles and population health',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(100,'Epidemiology','C377',4,'Objective','Disease patterns and public health surveillance',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(101,'Biostatistics','C378',4,'Objective','Statistical methods in health and medical research',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(102,'Environmental Health','C379',3,'Performance','Environmental factors affecting human health',2,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(103,'Introduction to Computer Science','C101',4,'Objective','Foundational computer science concepts including programming basics and computational thinking',1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(104,'Scripting and Programming - Foundations','C301',3,'Performance','Programming basics including variables, data types, flow control, and design concepts',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(105,'Network and Security - Foundations','C302',3,'Objective','Basic network systems and concepts related to networking technologies',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(106,'Web Development Foundations','C303',3,'Performance','HTML, CSS, and foundational web development skills',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(107,'Data Management - Foundations','C304',3,'Performance','Introduction to creating conceptual, logical and physical data models',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(108,'Version Control','C305',1,'Performance','Basics of version control systems for software development collaboration',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(109,'Scripting and Programming - Applications','C306',4,'Performance','Advanced programming concepts using C++ programming language',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(110,'Data Management - Applications','C307',4,'Performance','Advanced database concepts including MySQL and complex queries',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(111,'Java Fundamentals','C308',3,'Performance','Object-oriented programming fundamentals in Java language',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(112,'Java Frameworks','C309',3,'Performance','Advanced Java programming using frameworks and user interfaces',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(113,'Back-End Programming','C310',3,'Performance','Server-side programming with database integration and web services',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(114,'Advanced Java','C311',3,'Performance','Multithreaded programming and cloud deployment using Java',3,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(115,'Computer Architecture','C312',3,'Objective','Computer hardware organization, performance, and system design principles',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(116,'Data Structures and Algorithms I','C313',4,'Objective','Fundamental data structures including bags, lists, stacks, queues, trees, and hash tables',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(117,'Data Structures and Algorithms II','C314',4,'Performance','Advanced algorithms, graphs, hashing, and dynamic programming techniques',3,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(118,'Discrete Mathematics I','C315',4,'Objective','Logic, Boolean algebra, set theory, and mathematical foundations for computer science',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(119,'Discrete Mathematics II','C316',4,'Objective','Advanced discrete math including algorithms, cryptography, and computational models',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(120,'Operating Systems for Computer Scientists','C317',3,'Performance','Operating system principles including processes, memory management, and file systems',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(121,'Calculus I','C318',4,'Objective','Limits, derivatives, integrals, and differential equations for computer science applications',1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(122,'Natural Science Lab','C319',2,'Performance','Scientific method and experimental design through hands-on laboratory work',1,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(123,'Software Engineering','C320',4,'Performance','Software development lifecycle, process models, and engineering principles',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(124,'Software Design and Quality Assurance','C321',3,'Performance','Quality assurance practices throughout the software development lifecycle',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(125,'Introduction to AI for Computer Scientists','C322',2,'Performance','Foundational AI concepts, terminology, and algorithmic approaches',3,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(126,'Artificial Intelligence Optimization for Computer Scientists','C323',3,'Performance','Implementation and optimization of AI solutions for various applications',3,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(127,'Advanced AI and ML','C324',3,'Performance','Design and development of AI/ML solutions for real-world business problems',3,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(128,'Practical Applications of Prompt','C325',2,'Performance','Generative AI and prompt engineering for effective AI interactions',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(129,'Linux Foundations','C326',3,'Performance','Linux operating system fundamentals and command line operations',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(130,'Fundamentals of Information Security','C327',3,'Performance','Security principles, policies, and practices for information asset protection',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(131,'Introduction to Systems Thinking and Applications','C328',3,'Performance','Systems-based approach to analyzing complex problems and solutions',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(132,'Business of IT - Applications','C329',4,'Performance','ITIL principles and IT service management practices',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(133,'Ethics in Technology','C330',3,'Performance','Ethical considerations and decision-making frameworks in technology',2,1,'2025-08-24 15:00:00','2025-08-24 15:00:00'),(134,'Computer Science Project Development with a Team','C331',3,'Performance','Team-based capstone project demonstrating computer science competencies',4,1,'2025-08-24 15:00:00','2025-08-24 15:00:00');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prerequisites`
--

DROP TABLE IF EXISTS `prerequisites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prerequisites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `prerequisite_course_id` int NOT NULL,
  `is_required` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_prerequisite` (`course_id`,`prerequisite_course_id`),
  KEY `idx_prerequisites_course` (`course_id`),
  KEY `idx_prerequisites_prereq` (`prerequisite_course_id`),
  CONSTRAINT `prerequisites_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `prerequisites_ibfk_2` FOREIGN KEY (`prerequisite_course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Course prerequisite relationships';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prerequisites`
--

LOCK TABLES `prerequisites` WRITE;
/*!40000 ALTER TABLE `prerequisites` DISABLE KEYS */;
INSERT INTO `prerequisites` VALUES (1,3,2,1,'2025-08-23 18:44:44'),(2,13,12,1,'2025-08-23 18:44:44'),(3,15,13,1,'2025-08-23 18:44:44'),(4,16,15,1,'2025-08-23 18:44:44'),(5,17,16,1,'2025-08-23 18:44:44'),(6,21,20,1,'2025-08-23 18:44:44'),(7,78,77,1,'2025-08-23 18:44:44'),(8,85,83,1,'2025-08-23 18:44:44'),(9,86,83,1,'2025-08-23 18:44:44'),(10,87,83,1,'2025-08-23 18:44:44'),(11,88,83,1,'2025-08-23 18:44:44'),(26,110,107,1,'2025-08-24 15:00:00'),(27,109,104,1,'2025-08-24 15:00:00'),(28,111,109,1,'2025-08-24 15:00:00'),(29,112,111,1,'2025-08-24 15:00:00'),(30,113,112,1,'2025-08-24 15:00:00'),(31,114,113,1,'2025-08-24 15:00:00'),(32,116,118,1,'2025-08-24 15:00:00'),(33,117,116,1,'2025-08-24 15:00:00'),(34,117,119,1,'2025-08-24 15:00:00'),(35,118,121,1,'2025-08-24 15:00:00'),(36,119,118,1,'2025-08-24 15:00:00'),(37,123,109,1,'2025-08-24 15:00:00'),(38,126,125,1,'2025-08-24 15:00:00'),(39,127,126,1,'2025-08-24 15:00:00');
/*!40000 ALTER TABLE `prerequisites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `program_course_sequence`
--

DROP TABLE IF EXISTS `program_course_sequence`;
/*!50001 DROP VIEW IF EXISTS `program_course_sequence`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `program_course_sequence` AS SELECT 
 1 AS `program_name`,
 1 AS `program_code`,
 1 AS `course_name`,
 1 AS `course_code`,
 1 AS `sequence_order`,
 1 AS `competency_units`,
 1 AS `assessment_type`,
 1 AS `competency_category`,
 1 AS `is_required`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `program_courses`
--

DROP TABLE IF EXISTS `program_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `program_id` int NOT NULL,
  `course_id` int NOT NULL,
  `sequence_order` int NOT NULL,
  `is_required` tinyint(1) DEFAULT '1',
  `competency_category_id` int DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_program_course` (`program_id`,`course_id`),
  UNIQUE KEY `unique_program_sequence` (`program_id`,`sequence_order`),
  KEY `competency_category_id` (`competency_category_id`),
  KEY `idx_program_courses_program` (`program_id`),
  KEY `idx_program_courses_course` (`course_id`),
  CONSTRAINT `program_courses_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `program_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `program_courses_ibfk_3` FOREIGN KEY (`competency_category_id`) REFERENCES `competency_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Junction table linking programs to their required courses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_courses`
--

LOCK TABLES `program_courses` WRITE;
/*!40000 ALTER TABLE `program_courses` DISABLE KEYS */;
INSERT INTO `program_courses` VALUES (1,1,1,1,1,1,'2025-08-23 18:44:43'),(2,1,2,2,1,1,'2025-08-23 18:44:43'),(3,1,3,3,1,1,'2025-08-23 18:44:43'),(4,1,4,4,1,1,'2025-08-23 18:44:43'),(5,1,5,5,1,1,'2025-08-23 18:44:43'),(6,1,6,6,1,1,'2025-08-23 18:44:43'),(7,1,7,7,1,1,'2025-08-23 18:44:43'),(8,1,8,8,1,1,'2025-08-23 18:44:43'),(9,1,9,9,1,1,'2025-08-23 18:44:43'),(10,1,10,10,1,1,'2025-08-23 18:44:43'),(11,1,11,11,1,2,'2025-08-23 18:44:43'),(12,1,12,12,1,2,'2025-08-23 18:44:43'),(13,1,13,13,1,2,'2025-08-23 18:44:43'),(14,1,14,14,1,2,'2025-08-23 18:44:43'),(15,1,15,15,1,2,'2025-08-23 18:44:43'),(16,1,16,16,1,2,'2025-08-23 18:44:43'),(17,1,17,17,1,3,'2025-08-23 18:44:43'),(18,1,18,18,1,2,'2025-08-23 18:44:43'),(19,1,19,19,1,3,'2025-08-23 18:44:43'),(20,1,20,20,1,3,'2025-08-23 18:44:43'),(21,1,21,21,1,3,'2025-08-23 18:44:43'),(22,1,22,22,1,3,'2025-08-23 18:44:43'),(23,1,23,23,1,2,'2025-08-23 18:44:43'),(24,1,24,24,1,2,'2025-08-23 18:44:43'),(25,1,25,25,1,2,'2025-08-23 18:44:43'),(26,1,26,26,1,2,'2025-08-23 18:44:43'),(27,1,27,27,1,2,'2025-08-23 18:44:43'),(28,1,28,28,1,2,'2025-08-23 18:44:43'),(29,1,29,29,1,2,'2025-08-23 18:44:43'),(30,1,30,30,1,2,'2025-08-23 18:44:43'),(31,1,31,31,1,2,'2025-08-23 18:44:43'),(32,1,32,32,1,3,'2025-08-23 18:44:43'),(33,1,33,33,1,2,'2025-08-23 18:44:43'),(34,1,34,34,1,4,'2025-08-23 18:44:43'),(35,2,1,1,1,1,'2025-08-23 18:44:43'),(36,2,2,2,1,1,'2025-08-23 18:44:43'),(37,2,3,3,1,1,'2025-08-23 18:44:43'),(38,2,4,4,1,1,'2025-08-23 18:44:43'),(39,2,5,5,1,1,'2025-08-23 18:44:43'),(40,2,6,6,1,1,'2025-08-23 18:44:43'),(41,2,7,7,1,1,'2025-08-23 18:44:43'),(42,2,8,8,1,1,'2025-08-23 18:44:43'),(43,2,9,9,1,1,'2025-08-23 18:44:43'),(44,2,10,10,1,1,'2025-08-23 18:44:43'),(45,2,11,11,1,2,'2025-08-23 18:44:43'),(46,2,35,12,1,2,'2025-08-23 18:44:43'),(47,2,29,13,1,2,'2025-08-23 18:44:43'),(48,2,36,14,1,2,'2025-08-23 18:44:43'),(49,2,37,15,1,2,'2025-08-23 18:44:43'),(50,2,38,16,1,3,'2025-08-23 18:44:43'),(51,2,39,17,1,3,'2025-08-23 18:44:43'),(52,2,40,18,1,3,'2025-08-23 18:44:43'),(53,2,26,19,1,2,'2025-08-23 18:44:43'),(54,2,91,20,1,1,'2025-08-23 18:44:43'),(55,2,34,21,1,4,'2025-08-23 18:44:43'),(56,24,1,1,1,1,'2025-08-23 18:44:43'),(57,24,2,2,1,1,'2025-08-23 18:44:43'),(58,24,3,3,1,1,'2025-08-23 18:44:43'),(59,24,5,4,1,1,'2025-08-23 18:44:43'),(60,24,9,5,1,1,'2025-08-23 18:44:43'),(61,24,10,6,1,1,'2025-08-23 18:44:43'),(62,24,6,7,1,1,'2025-08-23 18:44:43'),(63,24,7,8,1,1,'2025-08-23 18:44:43'),(64,24,8,9,1,1,'2025-08-23 18:44:43'),(65,24,90,10,1,2,'2025-08-23 18:44:43'),(66,24,89,11,1,2,'2025-08-23 18:44:43'),(67,24,88,12,1,2,'2025-08-23 18:44:43'),(68,24,84,13,1,2,'2025-08-23 18:44:43'),(69,24,34,14,1,4,'2025-08-23 18:44:43'),(70,11,66,1,1,2,'2025-08-23 18:44:43'),(71,11,29,2,1,2,'2025-08-23 18:44:43'),(72,11,67,3,1,2,'2025-08-23 18:44:43'),(73,11,68,4,1,2,'2025-08-23 18:44:43'),(74,11,69,5,1,2,'2025-08-23 18:44:43'),(75,11,70,6,1,2,'2025-08-23 18:44:43'),(76,11,71,7,1,2,'2025-08-23 18:44:43'),(77,11,72,8,1,2,'2025-08-23 18:44:43'),(78,11,73,9,1,2,'2025-08-23 18:44:43'),(79,11,74,10,1,2,'2025-08-23 18:44:43'),(80,11,75,11,1,2,'2025-08-23 18:44:43'),(81,11,76,12,1,4,'2025-08-23 18:44:43'),(82,31,1,1,1,1,'2025-08-24 15:00:00'),(83,31,2,2,1,1,'2025-08-24 15:00:00'),(84,31,3,3,1,1,'2025-08-24 15:00:00'),(85,31,5,4,1,1,'2025-08-24 15:00:00'),(86,31,6,5,1,1,'2025-08-24 15:00:00'),(87,31,7,6,1,1,'2025-08-24 15:00:00'),(88,31,10,7,1,1,'2025-08-24 15:00:00'),(89,31,103,8,1,2,'2025-08-24 15:00:00'),(90,31,104,9,1,2,'2025-08-24 15:00:00'),(91,31,107,10,1,2,'2025-08-24 15:00:00'),(92,31,105,11,1,2,'2025-08-24 15:00:00'),(93,31,121,12,1,1,'2025-08-24 15:00:00'),(94,31,106,13,1,2,'2025-08-24 15:00:00'),(95,31,110,14,1,2,'2025-08-24 15:00:00'),(96,31,108,15,1,2,'2025-08-24 15:00:00'),(97,31,128,16,1,2,'2025-08-24 15:00:00'),(98,31,109,17,1,2,'2025-08-24 15:00:00'),(99,31,131,18,1,2,'2025-08-24 15:00:00'),(100,31,118,19,1,2,'2025-08-24 15:00:00'),(101,31,115,20,1,2,'2025-08-24 15:00:00'),(102,31,122,21,1,1,'2025-08-24 15:00:00'),(103,31,111,22,1,2,'2025-08-24 15:00:00'),(104,31,119,23,1,2,'2025-08-24 15:00:00'),(105,31,112,24,1,2,'2025-08-24 15:00:00'),(106,31,129,25,1,2,'2025-08-24 15:00:00'),(107,31,130,26,1,2,'2025-08-24 15:00:00'),(108,31,113,27,1,2,'2025-08-24 15:00:00'),(109,31,120,28,1,2,'2025-08-24 15:00:00'),(110,31,114,29,1,3,'2025-08-24 15:00:00'),(111,31,133,30,1,2,'2025-08-24 15:00:00'),(112,31,116,31,1,2,'2025-08-24 15:00:00'),(113,31,132,32,1,2,'2025-08-24 15:00:00'),(114,31,123,33,1,2,'2025-08-24 15:00:00'),(115,31,117,34,1,3,'2025-08-24 15:00:00'),(116,31,124,35,1,3,'2025-08-24 15:00:00'),(117,31,125,36,1,3,'2025-08-24 15:00:00'),(118,31,126,37,1,3,'2025-08-24 15:00:00'),(119,31,127,38,1,3,'2025-08-24 15:00:00'),(120,31,134,39,1,4,'2025-08-24 15:00:00'),(121,35,1,1,1,1,'2025-08-24 15:00:00'),(122,35,2,2,1,1,'2025-08-24 15:00:00'),(123,35,3,3,1,1,'2025-08-24 15:00:00'),(124,35,5,4,1,1,'2025-08-24 15:00:00'),(125,35,6,5,1,1,'2025-08-24 15:00:00'),(126,35,7,6,1,1,'2025-08-24 15:00:00'),(127,35,103,7,1,2,'2025-08-24 15:00:00'),(128,35,104,8,1,2,'2025-08-24 15:00:00'),(129,35,105,9,1,2,'2025-08-24 15:00:00'),(130,35,106,10,1,2,'2025-08-24 15:00:00'),(131,35,107,11,1,2,'2025-08-24 15:00:00'),(132,35,108,12,1,2,'2025-08-24 15:00:00'),(133,35,109,13,1,2,'2025-08-24 15:00:00'),(134,35,110,14,1,2,'2025-08-24 15:00:00'),(135,35,118,15,1,2,'2025-08-24 15:00:00'),(136,35,111,16,1,2,'2025-08-24 15:00:00'),(137,35,112,17,1,2,'2025-08-24 15:00:00'),(138,35,115,18,1,2,'2025-08-24 15:00:00'),(139,35,113,19,1,2,'2025-08-24 15:00:00'),(140,35,116,20,1,2,'2025-08-24 15:00:00'),(141,35,114,21,1,3,'2025-08-24 15:00:00'),(142,35,123,22,1,2,'2025-08-24 15:00:00'),(143,35,124,23,1,3,'2025-08-24 15:00:00'),(144,35,120,24,1,2,'2025-08-24 15:00:00'),(145,35,129,25,1,2,'2025-08-24 15:00:00'),(146,35,130,26,1,2,'2025-08-24 15:00:00'),(147,35,133,27,1,2,'2025-08-24 15:00:00'),(148,35,132,28,1,2,'2025-08-24 15:00:00'),(149,35,128,29,1,2,'2025-08-24 15:00:00'),(150,35,134,30,1,4,'2025-08-24 15:00:00'),(151,34,104,37,1,2,'2025-08-24 15:00:00'),(152,34,105,38,1,2,'2025-08-24 15:00:00'),(153,34,106,39,1,2,'2025-08-24 15:00:00'),(154,34,107,40,1,2,'2025-08-24 15:00:00'),(155,34,108,41,1,2,'2025-08-24 15:00:00'),(156,34,129,42,1,2,'2025-08-24 15:00:00'),(157,34,130,43,1,2,'2025-08-24 15:00:00'),(158,34,132,44,1,2,'2025-08-24 15:00:00');
/*!40000 ALTER TABLE `program_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `program_summary`
--

DROP TABLE IF EXISTS `program_summary`;
/*!50001 DROP VIEW IF EXISTS `program_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `program_summary` AS SELECT 
 1 AS `id`,
 1 AS `program_name`,
 1 AS `program_code`,
 1 AS `degree_level`,
 1 AS `college_name`,
 1 AS `total_competency_units`,
 1 AS `tuition_per_term`,
 1 AS `total_courses`,
 1 AS `total_assigned_units`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `degree_level` enum('Certificate','Bachelor','Master','Doctoral') NOT NULL,
  `college_id` int NOT NULL,
  `total_competency_units` int NOT NULL,
  `tuition_per_term` decimal(8,2) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_programs_college` (`college_id`),
  KEY `idx_programs_active` (`is_active`),
  KEY `idx_programs_degree_level` (`degree_level`),
  CONSTRAINT `programs_ibfk_1` FOREIGN KEY (`college_id`) REFERENCES `colleges` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Degree programs offered by WGU';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'B.S. Accounting','BSAC','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(2,'B.S. Human Resource Management','BSHR','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(3,'B.S. Information Technology Management','BSITM','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(4,'B.S. Business Management','BSBM','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(5,'B.S. Marketing','BSMK','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(6,'B.S. Communications','BSCOM','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(7,'B.S. Finance','BSFN','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(8,'B.S. Healthcare Administration','BSHA','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(9,'B.S. Supply Chain and Operations Management','BSSC','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(10,'B.S. User Experience Design','BSUX','Bachelor',1,120,3755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(11,'Master of Business Administration','MBA','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(12,'MBA Information Technology Management','MBAITM','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(13,'MBA Healthcare Administration','MBAHA','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(14,'M.S. Management and Leadership','MSML','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(15,'M.S. Marketing (Digital Marketing Specialization)','MSMKD','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(16,'M.S. Marketing (Marketing Analytics Specialization)','MSMKA','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(17,'M.S. Accounting - Auditing','MSACA','Master',1,30,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(18,'M.S. Accounting - Financial Reporting','MSACF','Master',1,30,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(19,'M.S. Accounting - Management Accounting','MSACM','Master',1,30,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(20,'M.S. Accounting - Taxation','MSACT','Master',1,30,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(21,'M.S. Human Resource Management','MSHR','Master',1,36,4755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(22,'B.S. Nursing Prelicensure (Pre-Nursing)','BSNP','Bachelor',2,120,8755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(23,'B.S. Nursing Prelicensure (Nursing)','BSNU','Bachelor',2,120,8755.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(24,'B.S. Nursing (RN to BSN)','BSNR','Bachelor',2,120,5325.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(25,'B.S. Health Information Management','BSHIM','Bachelor',2,120,4210.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(26,'B.S. Health and Human Services','BSHHS','Bachelor',2,120,4210.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(27,'B.S. Health Science','BSHS','Bachelor',2,120,4210.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(28,'B.S. Psychology','BSPY','Bachelor',2,120,4085.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(29,'B.S. Public Health','BSPH','Bachelor',2,120,4210.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(30,'B.S. Cloud and Network Engineering','BSCNE','Bachelor',3,120,4085.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(31,'B.S. Computer Science','BSCS','Bachelor',3,120,4085.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(32,'B.S. Cybersecurity and Information Assurance','BSCIA','Bachelor',3,120,4365.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(33,'B.S. Data Analytics','BSDA','Bachelor',3,120,3835.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(34,'B.S. Information Technology','BSIT','Bachelor',3,120,3725.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(35,'B.S. Software Engineering','BSSWE','Bachelor',3,120,4085.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(36,'B.A. Elementary Education','BAEED','Bachelor',4,120,3825.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(37,'B.A. Special Education and Elementary Education (Dual Licensure)','BASEED','Bachelor',4,120,3825.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43'),(38,'B.S. Mathematics Education (Secondary)','BSMAED','Bachelor',4,120,3825.00,1,'2025-08-23 18:44:43','2025-08-23 18:44:43');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_assessment`
--

DROP TABLE IF EXISTS `student_assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_assessment` (
  `student_assessmentId` int NOT NULL AUTO_INCREMENT,
  `student_courseId` int DEFAULT NULL,
  `assessmentId` int DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  PRIMARY KEY (`student_assessmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_assessment`
--

LOCK TABLES `student_assessment` WRITE;
/*!40000 ALTER TABLE `student_assessment` DISABLE KEYS */;
INSERT INTO `student_assessment` VALUES (1,1,1,'2023-09-26 00:00:00','2023-09-28 00:00:00'),(2,2,2,'2024-01-22 00:00:00','2024-02-12 00:00:00'),(3,3,3,'2024-02-15 00:00:00','2024-03-07 00:00:00'),(4,4,5,'2024-04-12 00:00:00','2024-04-14 00:00:00'),(5,5,6,'2024-08-03 00:00:00','2024-08-04 00:00:00'),(6,6,7,'2024-09-05 00:00:00','2024-09-07 00:00:00'),(7,7,45,'2024-10-27 00:00:00','2024-10-28 00:00:00'),(8,8,46,'2024-10-15 00:00:00','2024-11-12 00:00:00'),(9,9,47,'2024-11-29 00:00:00','2024-11-30 00:00:00'),(10,10,48,'2024-12-15 00:00:00','2025-01-05 00:00:00'),(11,11,49,'2025-01-08 00:00:00','2025-01-22 00:00:00'),(12,12,50,'2025-02-08 00:00:00','2025-03-08 00:00:00'),(13,13,51,'2025-03-22 00:00:00','2025-04-05 00:00:00'),(14,14,52,'2025-04-22 00:00:00','2025-05-27 00:00:00'),(15,15,60,'2025-09-02 20:07:16',NULL),(16,16,53,'2025-08-30 20:07:16',NULL),(32,17,7,NULL,NULL),(33,18,75,NULL,NULL),(34,19,46,NULL,NULL),(35,20,50,NULL,NULL),(36,21,50,NULL,NULL),(37,22,56,NULL,NULL),(38,23,60,NULL,NULL),(39,24,60,NULL,NULL),(40,25,74,NULL,NULL),(41,26,6,NULL,NULL);
/*!40000 ALTER TABLE `student_assessment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_course`
--

DROP TABLE IF EXISTS `student_course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_course` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `instructorId` int DEFAULT NULL,
  `courseId` int DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL,
  `term_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='used to tie a student to a specific instance of a course.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_course`
--

LOCK TABLES `student_course` WRITE;
/*!40000 ALTER TABLE `student_course` DISABLE KEYS */;
INSERT INTO `student_course` VALUES (1,4,108,1,'2023-08-01 00:00:00','2023-12-15 00:00:00','c',1),(2,4,58,2,'2024-01-01 00:00:00','2024-05-15 00:00:00','c',1),(3,4,43,3,'2024-02-01 00:00:00','2024-06-15 00:00:00','c',1),(4,4,68,5,'2024-03-01 00:00:00','2024-07-15 00:00:00','c',1),(5,4,68,6,'2024-06-01 00:00:00','2024-10-15 00:00:00','c',1),(6,4,118,7,'2024-08-01 00:00:00','2024-12-15 00:00:00','c',1),(7,4,13,103,'2024-09-01 00:00:00','2025-01-15 00:00:00','c',1),(8,4,38,104,'2024-10-01 00:00:00','2025-02-15 00:00:00','c',1),(9,4,63,105,'2024-11-01 00:00:00','2025-03-15 00:00:00','c',1),(10,4,23,106,'2024-12-01 00:00:00','2025-04-15 00:00:00','c',1),(11,4,123,107,'2025-01-01 00:00:00','2025-05-15 00:00:00','c',2),(13,4,73,109,'2025-03-01 00:00:00','2025-07-15 00:00:00','c',2),(14,4,53,110,'2025-04-01 00:00:00','2025-08-15 00:00:00','c',2),(25,4,28,132,'2025-09-08 00:00:00','2025-09-12 00:00:00','i',2),(26,4,88,6,'2025-09-09 00:00:00','2025-09-29 00:00:00','a',2);
/*!40000 ALTER TABLE `student_course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terms`
--

DROP TABLE IF EXISTS `terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `term_no` int DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terms`
--

LOCK TABLES `terms` WRITE;
/*!40000 ALTER TABLE `terms` DISABLE KEYS */;
INSERT INTO `terms` VALUES (1,1,'2024-10-01 00:00:00','2025-03-31 00:00:00',4),(2,2,'2025-04-01 00:00:00','2025-09-30 00:00:00',4);
/*!40000 ALTER TABLE `terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `mentor_id` int DEFAULT NULL,
  `user_type` varchar(10) DEFAULT NULL,
  `grad_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'jtell73@wgu.edu','Johan','Teller','$2b$10$4JDfMpKqX12Jpp1AvfBw7OULwlff82tJXawBdnxEv1zFAOOMjZfxe',11,'s','2025-11-01 04:00:00','2025-08-23 19:30:51','2025-08-23 19:30:51',35),(5,'sarah.johnson@wgu.edu','Sarah','Johnson','$2b$10$sbvGjyiuNyM7W.cYZuF0OejPBHm4RxCn9.6CPewD89dHrG6Fuzhjy',71,'s','2026-05-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',38),(6,'michael.chen@wgu.edu','Michael','Chen','$2b$10$0cA76rrWGtkqL1JeMUue1OL1e/c8CJMqo3xIoAmWvLKMc9DZ22Xii',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(7,'amanda.rodriguez@wgu.edu','Amanda','Rodriguez','$2b$10$CCctEByJQ6cwju0qx28BneXR1.qwsNTvWUBqVH3QW3uqmub326GiO',111,'s','2025-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',18),(8,'david.williams@wgu.edu','David','Williams','$2b$10$VaJSFUSd07e.4lIUIRT70.6nSbIUQzJRphTu4n8gLR4.LycNKgIBG',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(9,'jennifer.brown@wgu.edu','Jennifer','Brown','$2b$10$xYX6.7yRnlS14lfQIfRlLutjNDP9uWxQ5uuZpJoBCQdlWDknF9Z0.',116,'s','2026-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',16),(10,'robert.davis@wgu.edu','Robert','Davis','$2b$10$d9NtH/Gso/doXm3fDYwfK.pXZPvgbKZkEB9ZZAxPUaall5tEVTLBG',116,'s','2025-12-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',25),(11,'lisa.martinez@wgu.edu','Lisa','Martinez','$2b$10$Idj16JlyOAsHkV1FXJjeoOcnam2/FqiCIkg9OSKJKyfHa5k24IlOq',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(12,'james.thompson@wgu.edu','James','Thompson','$2b$10$q/E7IwUK/r3ZiCIX8IWcguTJdUItrXHyCSEJ.9ZpFI3eccxdDgl0C',126,'s','2026-02-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',33),(13,'patricia.garcia@wgu.edu','Patricia','Garcia','$2b$10$P1nph6ik1XCJyOv5VfmieeMRAZQ9hL2HgHOXlGXn0ZfwacfSUxX5K',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(14,'christopher.anderson@wgu.edu','Christopher','Anderson','$2b$10$rAl0HnkkUWpkisR8rADjDuxMSEgZPCDkAQFO.nMLkz/iuVK42gyBu',11,'s','2026-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',28),(15,'mary.taylor@wgu.edu','Mary','Taylor','$2b$10$TX8JY4R73.SKZRnBb72Ca.lCojiXx7AersQbpeUt8VigiCrpGd/we',81,'s','2025-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',29),(16,'matthew.thomas@wgu.edu','Matthew','Thomas','$2b$10$nIFay8lJB6arVozcmSsxWuevAeqeBFwdEAXZPkC9GBIYBjyicxfVy',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(17,'elizabeth.hernandez@wgu.edu','Elizabeth','Hernandez','$2b$10$qcE/aJJiAtCFfXN6SgsaA.AN2g7h5TLE5z1eVkwMAiIn01k5q1xmG',76,'s','2026-04-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',33),(18,'daniel.moore@wgu.edu','Daniel','Moore','$2b$10$/pglDoEubG.vEcKkg7z.WeGHAVTQDeLV3RW1cNqAByr9Q6BdCyMJe',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(19,'nancy.jackson@wgu.edu','Nancy','Jackson','$2b$10$3flmpMGuHCo6QeN2kWndUeGYZlR0HeOkNv298MsesgHYRB9kVicsa',91,'s','2026-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',8),(20,'anthony.martin@wgu.edu','Anthony','Martin','$2b$10$HHztkIauBiVKTS5V/GUewOdicnQDHOFjOxsUr2pq9/mA9J04pQbmi',91,'s','2025-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',14),(21,'karen.lee@wgu.edu','Karen','Lee','$2b$10$t9AUXhkccvcemCPhlcdv3uyNQ/6z3rdMP4Ci1bsweImyCDDejORdG',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(22,'mark.perez@wgu.edu','Mark','Perez','$2b$10$dYwLk.tALo3tQEWItfqLHOg0LtGDYDzisJ5l.IZf6/qNlK4J2kNva',121,'s','2026-01-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',19),(23,'susan.white@wgu.edu','Susan','White','$2b$10$aDSME4KI7jkQECzPHBM.yevWO3zBuYfW/xl4OmIljpG5Rg0nbCzty',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(24,'kevin.harris@wgu.edu','Kevin','Harris','$2b$10$SNt5tRcaFXhdGfklo5LpbOmE/cpZO6tPjOKbhjQWCFRITh158cAbm',46,'s','2026-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',12),(25,'michelle.clark@wgu.edu','Michelle','Clark','$2b$10$yIytVISVcFQpMBCpT31Jwu.Fvg5WowjyjjiC5PDa5V5bVA0G55ax.',91,'s','2025-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',16),(26,'steven.lewis@wgu.edu','Steven','Lewis','$2b$10$diEyk4EhLPIsf18JzEHj/ehWstpKfCVytO8RmFomE2tEeFurj54we',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(27,'donna.robinson@wgu.edu','Donna','Robinson','$2b$10$LYVoK7S60WWCknapH5U84OrGC3opyeiZawWlFMDwdQl9TTfafVIEG',51,'s','2026-03-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',8),(28,'joshua.walker@wgu.edu','Joshua','Walker','$2b$10$wu0wkcQhTBebbNhifnrNp.xL2uCs/pOc6GO9ZGZDggGQhOwwcdtmK',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(29,'carol.young@wgu.edu','Carol','Young','$2b$10$JNZAFzbx3Grs1n5bru1mEeKEBy2FpM16nqUIYby24qaPFeZnMDgam',21,'s','2026-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',32),(30,'kenneth.hall@wgu.edu','Kenneth','Hall','$2b$10$hdtuLNqCpwAcEpvQy9Wrg..qQW1gUW1JlKmCgN5rC86A5oOIWo/yq',101,'s','2025-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',22),(31,'helen.allen@wgu.edu','Helen','Allen','$2b$10$KQtWShPu/esT3c/oqtxzlu/ipI7g5YvJI1/WTXNaTwmyubCo7oIsu',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(32,'jason.wright@wgu.edu','Jason','Wright','$2b$10$nj7rRV10Gtr.XtYssjqzUOl8zc6AmTiug6B94CNLB25bWEdcUomhu',46,'s','2026-12-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',18),(33,'betty.lopez@wgu.edu','Betty','Lopez','$2b$10$x1EH0OYm5.0EwGmedchylORUEg7ZFeFx0swgmf8aMkG/hlo1H6yuS',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(34,'gary.hill@wgu.edu','Gary','Hill','$2b$10$brDYPAsVzgh7.sW14O.zs.77e8NGgL6mT3e86X/xoR55U65yAIQJ6',31,'s','2026-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',27),(35,'deborah.green@wgu.edu','Deborah','Green','$2b$10$2tE93AqNriZ4dDIaB2w6ruEHg3aMlW/hgoBM.uzA9SLFoUpYo5dIK',96,'s','2025-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',12),(36,'ronald.adams@wgu.edu','Ronald','Adams','$2b$10$hrcZFttkkbivnoGhTLmhU.DwP4F/4ZiDTdN6ldhqWkmmgQYVXoZYK',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(37,'cynthia.baker@wgu.edu','Cynthia','Baker','$2b$10$uwjHj/YbRCChjP.SHWXa8.waKPWGrYyQ8tDymd0wPxRgjNnbJi4Qi',11,'s','2026-05-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',16),(38,'ryan.gonzalez@wgu.edu','Ryan','Gonzalez','$2b$10$t6VHe8X3M.slSyu0TY7yf.FVUUHVTRU79wcrtvzfuSkFsjsoGGOHW',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(39,'shirley.nelson@wgu.edu','Shirley','Nelson','$2b$10$1ks7iQJaJVb2/tCZzSMu9u3uLp8UoyffH3jg.w8O9Mz8Aqu3xW8Nm',71,'s','2026-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',32),(40,'jacob.carter@wgu.edu','Jacob','Carter','$2b$10$35zV4JDg3IiMdYcbx5q3eurOsr.gJaGHeEkFIf0XcKctPfepdJB8y',56,'s','2025-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',29),(41,'amy.mitchell@wgu.edu','Amy','Mitchell','$2b$10$Dns9fsFvs5EvX9Rq9fAskeexBSmmKQ0PNQFOUbgbaPCCqUxJ9JgYG',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(42,'benjamin.roberts@wgu.edu','Benjamin','Roberts','$2b$10$vxH/JepQZ1sctelOF6zgn.p9UH8h4Ze52OW25QI7SgnF7dQ9QadkS',6,'s','2026-02-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',31),(43,'kimberly.turner@wgu.edu','Kimberly','Turner','$2b$10$lVJiii0Tap6NJlfnlKjKu.laXavPRgU3IddagfAwwAcnfuj5p0ixS',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(44,'nicholas.phillips@wgu.edu','Nicholas','Phillips','$2b$10$2LGUdhDES3Pz./HIC5qsD.Tr7JLkLSg9G2OKAJJ7FIU0LX0oMFT02',41,'s','2026-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',13),(45,'brenda.campbell@wgu.edu','Brenda','Campbell','$2b$10$1vlu6Me/RXTVwPPpIZhSDuHWlQPnYoB0qeHxJ.iRIn4BpxFAESw2.',26,'s','2025-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',26),(46,'alexander.parker@wgu.edu','Alexander','Parker','$2b$10$jUkygfMFkMRamcvaBu2Qg.3jqoTs6NP0M7L/VE19YHl9IvH3YykZ6',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(47,'catherine.evans@wgu.edu','Catherine','Evans','$2b$10$YjJfW7AfzWCMNy2ENSsnfOpHBw8DS5ncvnxGgzBcYBjpdrD8eqcy6',11,'s','2026-04-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',3),(48,'jonathan.edwards@wgu.edu','Jonathan','Edwards','$2b$10$8wd4RVssrXCTI7RFhFlEQeQUTQxIBumAsN5Yh0IVcveiywvQvt5Iy',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(49,'frances.collins@wgu.edu','Frances','Collins','$2b$10$t6LnvJVD/pGfH5i4yZ6nL.Epz0vpcvU7ep7qTDOcwGSc3CpS9Uzme',86,'s','2026-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',37),(50,'samuel.stewart@wgu.edu','Samuel','Stewart','$2b$10$5pdi0UiehhgUCt.5rRsQEOFUqNYKNRrAXNuB9AqzotwjdgNf6pQ4G',121,'s','2025-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',36),(51,'christine.sanchez@wgu.edu','Christine','Sanchez','$2b$10$gwf6leV.WLecETia639mje6ewk6dURXiuslAZIrmDP0gqt6hl7YYS',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(52,'gregory.morris@wgu.edu','Gregory','Morris','$2b$10$wqpmxnDBdrYjDowg1CDSEukcMj8AXEMSig7Sz.83RvVb03vwI036K',141,'s','2026-01-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',12),(53,'janet.rogers@wgu.edu','Janet','Rogers','$2b$10$D4KYzPNpDc3ryF.qRWuMQOaVxt4KGytm3bBiLdnMXm4Rcj2mZJwba',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(54,'patrick.reed@wgu.edu','Patrick','Reed','$2b$10$QZdJpTo0MeRZX8tsvw5bl.kzYUS899GpPRWCZivD0fgAQBJC9rjBi',16,'s','2026-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',8),(55,'maria.cook@wgu.edu','Maria','Cook','$2b$10$QaUdVfyPkXToEvqhPuvj4OSndo327yZrqzIsp4DC941w9e3vw/mIC',61,'s','2025-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',15),(56,'timothy.morgan@wgu.edu','Timothy','Morgan','$2b$10$NdnF.HcMf.lTmQP6fROhWeyf7fp6EHzIUEZ8a.2/qmyeErA12/IWS',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(57,'debra.bell@wgu.edu','Debra','Bell','$2b$10$00CAGtbVGr5zIY8TKOkmduAQuS/Jaa9uO5Pd71SnTQWNgq/OntMKu',106,'s','2026-03-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',18),(58,'harold.murphy@wgu.edu','Harold','Murphy','$2b$10$MdHcu5YCbmOjDAfus1/KleffGy4cUCb55oEQBPDvyVkfGLPl/DyZa',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(59,'rachel.bailey@wgu.edu','Rachel','Bailey','$2b$10$mIo6bQlONsZffA79C51KvOv1OXeC8SECQfsRcyVzpLQtg4sPMzKlm',116,'s','2026-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',35),(60,'jordan.rivera@wgu.edu','Jordan','Rivera','$2b$10$N1Vhp/hXn2LWO.ryhuVk5.9vx6fRJmPJsTKjGEVJ2rbsjYoTOUbiq',31,'s','2025-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',26),(61,'carolyn.cooper@wgu.edu','Carolyn','Cooper','$2b$10$JkD5l7h81hPLqNUta.acEOMocVVE/NAtpHAZkg1P.qq/SlZUjiRRq',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(62,'douglas.richardson@wgu.edu','Douglas','Richardson','$2b$10$y4H5pvmDornLrupijy2YBOxZfFDCS6y.9vliB8TL4RseuPSF/xAqy',46,'s','2026-12-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',25),(63,'virginia.cox@wgu.edu','Virginia','Cox','$2b$10$C/2jbvyjwQh3AR3Y1kDWI.W9qkMM0pVALxe0644KePGln2eCtR2Ca',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(64,'peter.howard@wgu.edu','Peter','Howard','$2b$10$hvMeaS/MkZln7GcUA3gL/eRGWMCsLmAuX0J8Dt5oYnQUP7tOiPwF6',121,'s','2026-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',28),(65,'maria.ward@wgu.edu','Maria','Ward','$2b$10$1Hl0kainGBvQn5Y8YTs.5.ANyci168dXUgp25aWJa1MiAmoxXh.Ze',16,'s','2025-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',38),(66,'henry.torres@wgu.edu','Henry','Torres','$2b$10$.SegoNLRsXw43rnDIqpSw.Z0v8YguRmlP5vF0V7nUcOwU5BKvMA/K',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(67,'julie.peterson@wgu.edu','Julie','Peterson','$2b$10$2CXhXZ1rAdp0sZc6hPipnehCz.99P0Jrr6swLxf7d7/DDjH/sJV5S',41,'s','2026-05-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',17),(68,'jose.gray@wgu.edu','Jose','Gray','$2b$10$Cw1186kIo1DmTZPX0o/vYu2sO6R1YhclOICfqHHhS5p4SRI5FRb1K',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(69,'ann.ramirez@wgu.edu','Ann','Ramirez','$2b$10$ui37zjVy8E435AqAwlG/GOKiMoWsCvqUiNwaPaJzsD8rqPKdpgFEW',76,'s','2026-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',37),(70,'arthur.james@wgu.edu','Arthur','James','$2b$10$SCrN9js2twL5v6qjW.ItA.bzxqBgd3Q1kT3arsTq4DTeNNaOEuow6',16,'s','2025-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',28),(71,'joyce.watson@wgu.edu','Joyce','Watson','$2b$10$9snwEYrin5fYRX1hvz8HPOUbUwaL//VPDV2wFdSe2p0KDjk0ucugG',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(72,'carl.brooks@wgu.edu','Carl','Brooks','$2b$10$TsGhmosrnMdAhLY76qNTM.2JNWehuRTBgZTK5ladumRfCb6et5KJW',36,'s','2026-02-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',35),(73,'diane.kelly@wgu.edu','Diane','Kelly','$2b$10$yiPkmuHJEZ9ppAbJzTvqGOvVjiG1uu14CKqrvSRS2MddfGC/eVSvG',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(74,'noah.sanders@wgu.edu','Noah','Sanders','$2b$10$ibdLtkAwN.3cZPPdwUZKeuLrXmSJVruJVSTZ0Oy7UyA/9gZfXz55G',111,'s','2026-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',14),(75,'gloria.price@wgu.edu','Gloria','Price','$2b$10$2Octou6WmgaBHkw6pOi6pehyKOn7TFeALGFE710IX/ziP800Xgd6a',96,'s','2025-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',30),(76,'willie.bennett@wgu.edu','Willie','Bennett','$2b$10$USg8ulBXIKqTQOtpVHxwROhUSp1TSt08bxLV/A8.FijcKMNKdWdKy',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(77,'ruth.wood@wgu.edu','Ruth','Wood','$2b$10$CaAiAUhZjt0MdFs28S2MCu6SfdQRUSyyeStr.IH8Mh3G5K2mMLtAK',31,'s','2026-04-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',37),(78,'wayne.barnes@wgu.edu','Wayne','Barnes','$2b$10$kYr/Zeo0ZpETnWl5B5IETuPLgI434hqxy3rF1U./4ddu2520dnCT.',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(79,'kathryn.ross@wgu.edu','Kathryn','Ross','$2b$10$OsSrMRMcWAxoI1vfOI.QH.y1fAIjOFq2akB76XHdmEtSfXwI2dPhm',126,'s','2026-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',1),(80,'ralph.henderson@wgu.edu','Ralph','Henderson','$2b$10$Xl1IRFEuBYKGb2iuKkvpZeqLOlLybVXQ8h8eoMTNTArSrREIp67pO',121,'s','2025-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',29),(81,'laura.coleman@wgu.edu','Laura','Coleman','$2b$10$dKYdapCBn9mtpOmkyjWK0ewnC4/apZre9mlbsaFI86vTrWXI7O8xu',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(82,'eugene.jenkins@wgu.edu','Eugene','Jenkins','$2b$10$lJeyM31rTd37YbnhCFIFP.sJ9a4pd6WmJUn9oFOycD/nZ.8SGAAYG',66,'s','2026-01-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',26),(83,'theresa.perry@wgu.edu','Theresa','Perry','$2b$10$P9aGTKaBPY7VfpAVj1I8wOl1XamhUe3SezrG./ajlW7T4nNBU3iPW',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(84,'louis.powell@wgu.edu','Louis','Powell','$2b$10$jBPPgh4CE7Ko6lAq3T8pQuHUS43MARAK9CeYcvSA4mB1NwRqME4Pe',66,'s','2026-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',2),(85,'sara.long@wgu.edu','Sara','Long','$2b$10$i05zX1X//52G4j05ef06RObBWnn3ncY/hf4Kkb4xC3ixQuS65lCUC',11,'s','2025-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',2),(86,'philip.patterson@wgu.edu','Philip','Patterson','$2b$10$ReXjGjvzYj7CMV4FBK/ha.r8M5c9fQFPDvw10zlbBEw1fCp6LivRe',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(87,'janice.hughes@wgu.edu','Janice','Hughes','$2b$10$2l1Nq9rxBf1G7ALjlkEl2eyb8SYY8g2XbP.MC73kNHql1yE.50RCW',66,'s','2026-03-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',22),(88,'johnny.flores@wgu.edu','Johnny','Flores','$2b$10$77zMIcfbH3opR2o5Qk.AAexrW/ymC5Nrw4sou5.gZh4hm5YQWZdWG',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(89,'marie.washington@wgu.edu','Marie','Washington','$2b$10$gf0EZWc/X9uTr7KAnn.tl.j7Zm0X44hexv9jYuO0kUhahmX8T5rZe',6,'s','2026-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',19),(90,'adam.butler@wgu.edu','Adam','Butler','$2b$10$NSLaEhGA.inSK6SGHdgN8..pT/bkEPVKM/Aie8Hj4Gm0ITxnnBQYW',26,'s','2025-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',20),(91,'kelly.simmons@wgu.edu','Kelly','Simmons','$2b$10$6Zg1xG9gUQ2k0/MDiRWrROlaFtxtfi/XMWa6IoPbWrsxEg4COMChm',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(92,'todd.foster@wgu.edu','Todd','Foster','$2b$10$IgpeRfAp58V9CB7eKYGUU.IrJpJg8xPI6dYCcGEC1qMCZOwOXalGu',76,'s','2026-12-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',7),(93,'beverly.gonzales@wgu.edu','Beverly','Gonzales','$2b$10$L.q0TfMj8jkjq4ZYs7Ngb.uEhtG6Nh9ZvCqtUu0DwX03gr.gVdFsK',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(94,'alan.bryant@wgu.edu','Alan','Bryant','$2b$10$xa6juM/fA1pwhZmjgQAzm.N2yEwP7nyccffdEmMnkXrsju5hcREn2',71,'s','2026-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',12),(95,'cheryl.alexander@wgu.edu','Cheryl','Alexander','$2b$10$R0OzPH5PMy6P75m.SqkzaOOZKsgCP2xqxPE7anJ0hYpprecYERiky',66,'s','2025-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',4),(96,'keith.russell@wgu.edu','Keith','Russell','$2b$10$GrW/GEO1N7SNPiu6Zl4p/uWBFZD1knmB0CmIlEGiy6YUHsRLQTSFO',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(97,'megan.griffin@wgu.edu','Megan','Griffin','$2b$10$W6b8HVV6GLYKjXbGMQi1I.RDlGoD.7RsLVlYOBYfOHY9rbIvQekBy',51,'s','2026-05-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',18),(98,'sean.diaz@wgu.edu','Sean','Diaz','$2b$10$wLX0rFybLX8J5G.Fda7aDu7WPBt3sJIx674W4HHtNT4aDjRhInbiO',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(99,'denise.hayes@wgu.edu','Denise','Hayes','$2b$10$cq20jV96hpLSPjz1m8NW7.ItM04gsiLK4NYL6uSb9de8bdRnwZL9a',6,'s','2026-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',11),(100,'eric.myers@wgu.edu','Eric','Myers','$2b$10$5yb4tg2h4XrvYyFCbB4zH.SarspPZMhv2QFU/HcY7QomHDTdwz7Pu',136,'s','2025-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',23),(101,'marilyn.ford@wgu.edu','Marilyn','Ford','$2b$10$/o3HO6.eXF5CQQO4mRy0SucUTmtUV/Lbri2hB/WhNvKaTSl9.1R32',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(102,'terry.hamilton@wgu.edu','Terry','Hamilton','$2b$10$7UwxpSDdrVlTsAZJwdTYNeK92s.v/xHjc/7H5ojyfK./hW70hucEW',71,'s','2026-02-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',26),(103,'lois.graham@wgu.edu','Lois','Graham','$2b$10$5NPdj0iEpHJ/exAQXD.mROTr7wzESpKGSgqp61d6irIHBI0P9leLK',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(104,'bobby.sullivan@wgu.edu','Bobby','Sullivan','$2b$10$1Y9Csd31j/Vy.GVBFDyIS.3xcJ6Qo/fSwuO1yYsmar/aHiR9dR0L2',96,'s','2026-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',28),(105,'norma.wallace@wgu.edu','Norma','Wallace','$2b$10$/UBQ0q2kiMp3Ebvi1Iw0w.xNedY.pm39vzMGzgA2d8A4ofXn7W9ou',126,'s','2025-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',2),(106,'clarence.woods@wgu.edu','Clarence','Woods','$2b$10$NQY7/8sDrgxExnV5SCCuie8X9LZHbeSFjoHPuiiPG1iEMeqgEZgC6',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(107,'paula.cole@wgu.edu','Paula','Cole','$2b$10$/LoIlGY8ypMBEh63b7anVutMBgWbblH5oJJquc2Uy/XsbB0D.Iq2e',96,'s','2026-04-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',13),(108,'frank.west@wgu.edu','Frank','West','$2b$10$1I4o4ZCN1rqCbekig5MyTOGmJbMbG39QFscLBhwDzwADqqnQERkVS',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(109,'diana.jordan@wgu.edu','Diana','Jordan','$2b$10$p5jH4N/45wki7hv1seKREeGsUlLvpPsMayqZ6Pr.4mbP5rkhyXA36',81,'s','2026-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',29),(110,'joe.owens@wgu.edu','Joe','Owens','$2b$10$nmGHjP0fm8PIDRPv1LL0YeJBQat1TnzhFcC.Us4oABAc1xJOWy1Ji',131,'s','2025-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',23),(111,'evelyn.reynolds@wgu.edu','Evelyn','Reynolds','$2b$10$ZAIsByxa7jWogtGN80S0bO8pzdKCkrFijoEKmLJSfajX6YGZ1fE0y',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(112,'jeremy.fisher@wgu.edu','Jeremy','Fisher','$2b$10$ljISZ9jp659Sd3xwt/YNBOlSo5YAotsPxmyAXfRIjbAuGmf279rKa',96,'s','2026-01-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',10),(113,'ruby.ellis@wgu.edu','Ruby','Ellis','$2b$10$9O6nYOiyA2ZvHIybGXIAVOzfV0/fZxg5ed7kDEWfStw9NYe00mlcm',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(114,'scott.harrison@wgu.edu','Scott','Harrison','$2b$10$yPJ5CepERgn5jTaYAk/mVuB/EHE7oRD/m07xmG3m9W10f7BdqjnOm',66,'s','2026-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',27),(115,'alice.gibson@wgu.edu','Alice','Gibson','$2b$10$AAhIjIzmtXILPiEogBRwkOe4k5CML/oCnD6bpJjHoyrs4lVBuolMW',16,'s','2025-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',5),(116,'howard.mcdonald@wgu.edu','Howard','McDonald','$2b$10$SKjZBzy9SDa4p1LeHTRIxOE6sxYKKmm62y0TcJ01bK3gi6Yn.8D0y',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(117,'tammy.cruz@wgu.edu','Tammy','Cruz','$2b$10$ymBLZSmMmr16rUro05ThaOqL6XpfZxv3v90067VztwSOX8.qCDSEa',121,'s','2026-03-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',38),(118,'billy.marshall@wgu.edu','Billy','Marshall','$2b$10$s3vWZIghTTMVOjn8djfmjuqwUCoa.PCoZKB5gyW2RnjvIp12HdrlG',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(119,'christina.ortiz@wgu.edu','Christina','Ortiz','$2b$10$1GZSg24BjW7O4bhvLkYjleskuM.QYxuaoPQp/WQijgIX4iTi8dZdO',51,'s','2026-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',21),(120,'bruce.gomez@wgu.edu','Bruce','Gomez','$2b$10$qqfo/Qfx5W9b7.zibvG0nOS64N6grcpJPJtWBrVjgHf.TleOw7DKC',81,'s','2025-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',29),(121,'janice.murray@wgu.edu','Janice','Murray','$2b$10$J9sJrJy1AoMx7xyayuaE.emt4G0B/JALyTuKpoKIXWKDlgmJy/2Ca',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(122,'roger.freeman@wgu.edu','Roger','Freeman','$2b$10$6GcyKCpfzj2IB1n35cST9O6lQSHUSzAuW7ckPcNC2DfGDE3cN7Yw6',71,'s','2026-12-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',31),(123,'jean.wells@wgu.edu','Jean','Wells','$2b$10$Xea.gArCehG0uw1rfL7dIeBlbkqduoSPph5DdsFMMgzMm3uIOnj86',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(124,'brandon.webb@wgu.edu','Brandon','Webb','$2b$10$oH6BiGZMPxOdoQgeZYSG8.zWDRnymAE4KZhfDP3AWw2v58AciemQy',41,'s','2026-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',16),(125,'rachel.simpson@wgu.edu','Rachel','Simpson','$2b$10$Cu2vHGdZzugsZRgrldOHu.JJWU8F3Os3n40cnoCPTP778vX1GKJMu',116,'s','2025-06-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',9),(126,'carlos.stevens@wgu.edu','Carlos','Stevens','$2b$10$cldCNX5uInKWpOWyPOxuz.rOlsFIgBUWQnCovAoe/xT5itdMADsp6',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(127,'stephanie.tucker@wgu.edu','Stephanie','Tucker','$2b$10$bHy3oxh/i8VbvtzbJijsW.9SLeB1NGBZT6YlVvZPCDTXS/S8E3zz6',121,'s','2026-05-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',8),(128,'fred.porter@wgu.edu','Fred','Porter','$2b$10$N5lOXDCgJ/k8aFwAU3TDFOvcHTIV75b15Q0GCQy6PMng0bFT3EGWq',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(129,'andrea.hunter@wgu.edu','Andrea','Hunter','$2b$10$jp2Y6zBTLeGHvc/KdSj8GezJfoS72D4EoSsVb9knaQD2/wQfj5Xq6',81,'s','2026-08-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',14),(130,'walter.hicks@wgu.edu','Walter','Hicks','$2b$10$JFVlztIaXb5MDN6umC.2DOkJejH31Wy0TAt4laCNVjATbUv9a28d.',16,'s','2025-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',27),(131,'jacqueline.crawford@wgu.edu','Jacqueline','Crawford','$2b$10$ztAtfLvcMOLg2Xwc2GB0/O1vpT0Aw5qB4e5f5iDW/wD4LPEitSZD2',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(132,'mason.boyd@wgu.edu','Mason','Boyd','$2b$10$gWOCjUYBijx7tOuAMefDcOYG8.aL2hRda8mLezoWieLnFIAXcpKx2',101,'s','2026-02-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',2),(133,'hannah.mason@wgu.edu','Hannah','Mason','$2b$10$iPBMh.9tL8dqKCUZnzQe6.LlqBlpNiMo/c2EWEwILF8sLXpIa8.Q6',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(134,'gerald.morales@wgu.edu','Gerald','Morales','$2b$10$W4qk8cKbSpG30BrJlD0MbuQpAsNYjzcEVdRhwVDlNn51.pUz7n4qi',36,'s','2026-07-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',33),(135,'heather.murphy@wgu.edu','Heather','Murphy','$2b$10$D1XTjZDNYQnht1gRZqNS/.2JhRA2wfHQq1JmO3PPUyDcmkWyKAM/.',46,'s','2025-10-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',2),(136,'victor.kennedy@wgu.edu','Victor','Kennedy','$2b$10$8fmCdxAklbCmnDzUsDduhuhnMmqlHJ4ki6lbDpbEtrW7MfNbMVXJC',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(137,'julie.warren@wgu.edu','Julie','Warren','$2b$10$vS9JwprdZqbWH2T0nRVTjuuAQT9oC8g73y8E.N1Rf7S1Fl18S4m8W',116,'s','2026-04-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',28),(138,'roy.dixon@wgu.edu','Roy','Dixon','$2b$10$MdkdRp/YzBwQ1UZS8ezYfeHAoWnHCsFON6TXilkpoBBFQn7TMQGkO',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(139,'kathryn.andrews@wgu.edu','Kathryn','Andrews','$2b$10$OCRRD44A7UGKGEnzIJtbZObVBBFfqscOqc34eLHOWNOTb0UJDUMaO',111,'s','2026-11-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',10),(140,'nathan.austin@wgu.edu','Nathan','Austin','$2b$10$QiYIO2hPEflfgCsAHOUipuig1LIpIOHc5XE06EmdDeOmWs91QscL6',41,'s','2025-09-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',21),(141,'doris.pierce@wgu.edu','Doris','Pierce','$2b$10$8.pX9C1FBd3k4ORuhIYQROWrcf1ajAmSu264RxYe8llPPnJ5DXt0C',NULL,'m',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL),(142,'zachary.knight@wgu.edu','Zachary','Knight','$2b$10$E7YpxpQF.xpz3Tcy7hIuZu5NcEUsJH5e2jopgf7shP0JzeGeW4Fey',41,'s','2026-01-01 00:00:00','2025-08-24 14:09:16','2025-08-24 14:09:16',34),(143,'barbara.armstrong@wgu.edu','Barbara','Armstrong','$2b$10$Om7/zATth9Mo4rM5QCGkjOg0.elxZgO7gk0uDMql0Q0xHLdbYARde',NULL,'i',NULL,'2025-08-24 14:09:16','2025-08-24 14:09:16',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `course_prerequisites_view`
--

/*!50001 DROP VIEW IF EXISTS `course_prerequisites_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`doadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `course_prerequisites_view` AS select `c`.`id` AS `course_id`,`c`.`name` AS `course_name`,`c`.`code` AS `course_code`,`pc`.`id` AS `prerequisite_course_id`,`pc`.`name` AS `prerequisite_course_name`,`pc`.`code` AS `prerequisite_course_code` from ((`courses` `c` join `prerequisites` `p` on((`c`.`id` = `p`.`course_id`))) join `courses` `pc` on((`p`.`prerequisite_course_id` = `pc`.`id`))) where ((`c`.`is_active` = true) and (`pc`.`is_active` = true)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `program_course_sequence`
--

/*!50001 DROP VIEW IF EXISTS `program_course_sequence`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`doadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `program_course_sequence` AS select `p`.`name` AS `program_name`,`p`.`code` AS `program_code`,`c`.`name` AS `course_name`,`c`.`code` AS `course_code`,`pc`.`sequence_order` AS `sequence_order`,`c`.`competency_units` AS `competency_units`,`c`.`assessment_type` AS `assessment_type`,`cc`.`name` AS `competency_category`,`pc`.`is_required` AS `is_required` from (((`programs` `p` join `program_courses` `pc` on((`p`.`id` = `pc`.`program_id`))) join `courses` `c` on((`pc`.`course_id` = `c`.`id`))) left join `competency_categories` `cc` on((`pc`.`competency_category_id` = `cc`.`id`))) where ((`p`.`is_active` = true) and (`c`.`is_active` = true)) order by `p`.`code`,`pc`.`sequence_order` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `program_summary`
--

/*!50001 DROP VIEW IF EXISTS `program_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`doadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `program_summary` AS select `p`.`id` AS `id`,`p`.`name` AS `program_name`,`p`.`code` AS `program_code`,`p`.`degree_level` AS `degree_level`,`c`.`name` AS `college_name`,`p`.`total_competency_units` AS `total_competency_units`,`p`.`tuition_per_term` AS `tuition_per_term`,count(`pc`.`course_id`) AS `total_courses`,sum(`co`.`competency_units`) AS `total_assigned_units` from (((`programs` `p` join `colleges` `c` on((`p`.`college_id` = `c`.`id`))) left join `program_courses` `pc` on((`p`.`id` = `pc`.`program_id`))) left join `courses` `co` on((`pc`.`course_id` = `co`.`id`))) where (`p`.`is_active` = true) group by `p`.`id`,`p`.`name`,`p`.`code`,`p`.`degree_level`,`c`.`name`,`p`.`total_competency_units`,`p`.`tuition_per_term` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-10 16:12:02
