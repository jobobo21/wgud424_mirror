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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'd2e12e14-7a0c-11f0-9612-22d0c7b7b446:1-1369';

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
-- Dumping events for database 'D424'
--

--
-- Dumping routines for database 'D424'
--
/*!50003 DROP FUNCTION IF EXISTS `rand_instructor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="doadmin"@"%" FUNCTION "rand_instructor"() RETURNS int
BEGIN
	SELECT id into @inst_id FROM users WHERE user_type = 'i' order by RAND() Limit 1;
    return @inst_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `rand_program` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="doadmin"@"%" FUNCTION "rand_program"() RETURNS int
BEGIN
	SELECT id into @prog_id FROM programs order by RAND() Limit 1;
    return @prog_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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

-- Dump completed on 2025-09-10 14:24:53
