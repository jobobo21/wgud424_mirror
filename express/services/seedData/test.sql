-- WGU Database Schema and Seed Data - FIXED VERSION
-- Western Governors University - August 2025 Catalog
-- Using Schema: D424

USE D424;

-- Drop existing tables if they exist (in reverse order due to foreign key constraints)
DROP TABLE IF EXISTS D424.assessments;
DROP TABLE IF EXISTS D424.prerequisites;
DROP TABLE IF EXISTS D424.program_courses;
DROP TABLE IF EXISTS D424.courses;
DROP TABLE IF EXISTS D424.programs;
DROP TABLE IF EXISTS D424.colleges;
DROP TABLE IF EXISTS D424.assessment_types;
DROP TABLE IF EXISTS D424.competency_categories;

-- Create tables
CREATE TABLE D424.colleges (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE D424.assessment_types (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE D424.competency_categories (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE D424.programs (
    id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    degree_level ENUM('Certificate', 'Bachelor', 'Master', 'Doctoral') NOT NULL,
    college_id INT NOT NULL,
    total_competency_units INT NOT NULL,
    tuition_per_term DECIMAL(8,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (college_id) REFERENCES D424.colleges(id) ON DELETE RESTRICT
);

CREATE TABLE D424.courses (
    id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    competency_units INT NOT NULL,
    assessment_type ENUM('Objective', 'Performance', 'Mixed') NOT NULL,
    description TEXT,
    competency_category_id INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (competency_category_id) REFERENCES D424.competency_categories(id) ON DELETE SET NULL
);

CREATE TABLE D424.program_courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    program_id INT NOT NULL,
    course_id INT NOT NULL,
    sequence_order INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    competency_category_id INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES D424.programs(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES D424.courses(id) ON DELETE CASCADE,
    FOREIGN KEY (competency_category_id) REFERENCES D424.competency_categories(id) ON DELETE SET NULL,
    UNIQUE KEY unique_program_course (program_id, course_id),
    UNIQUE KEY unique_program_sequence (program_id, sequence_order)
);

CREATE TABLE D424.prerequisites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    prerequisite_course_id INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES D424.courses(id) ON DELETE CASCADE,
    FOREIGN KEY (prerequisite_course_id) REFERENCES D424.courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_prerequisite (course_id, prerequisite_course_id)
);

CREATE TABLE D424.assessments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    type ENUM('O', 'P') NOT NULL,
    description TEXT,
    passing_score DECIMAL(5,2),
    max_attempts INT DEFAULT 3,
    time_limit_minutes INT,
    is_proctored BOOLEAN DEFAULT FALSE,
    is_required_to_pass BOOLEAN DEFAULT TRUE,
    sequence_order INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES D424.courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_course_sequence (course_id, sequence_order)
);

-- Insert seed data

-- Insert assessment types
INSERT INTO D424.assessment_types (id, name, description) VALUES
(1, 'Objective Assessment', 'Computer-scored assessments used to verify competency'),
(2, 'Performance Assessment', 'Individual work created by students, scored by faculty according to rubrics');

-- Insert competency categories
INSERT INTO D424.competency_categories (id, name, description) VALUES
(1, 'General Education', 'Foundational knowledge across multiple disciplines'),
(2, 'Core Program', 'Essential knowledge and skills for the specific program'),
(3, 'Specialization', 'Advanced skills in specialized areas of study'),
(4, 'Capstone', 'Integrated application of program knowledge and skills');

-- Insert colleges
INSERT INTO D424.colleges (id, name, code, description) VALUES
(1, 'School of Business', 'SOB', 'Business and management programs focusing on industry-relevant skills'),
(2, 'Leavitt School of Health', 'LSOH', 'Health and nursing programs with clinical components'),
(3, 'School of Technology', 'SOT', 'Information technology and computer science programs'),
(4, 'School of Education', 'SOE', 'Teacher preparation and educational leadership programs');

-- Insert programs
INSERT INTO D424.programs (id, name, code, degree_level, college_id, total_competency_units, tuition_per_term, is_active) VALUES
(1, 'B.S. Accounting', 'BSAC', 'Bachelor', 1, 120, 3755.00, TRUE),
(2, 'B.S. Human Resource Management', 'BSHR', 'Bachelor', 1, 120, 3755.00, TRUE),
(3, 'B.S. Information Technology Management', 'BSITM', 'Bachelor', 1, 120, 3755.00, TRUE),
(4, 'B.S. Business Management', 'BSBM', 'Bachelor', 1, 120, 3755.00, TRUE),
(5, 'B.S. Marketing', 'BSMK', 'Bachelor', 1, 120, 3755.00, TRUE),
(6, 'B.S. Communications', 'BSCOM', 'Bachelor', 1, 120, 3755.00, TRUE),
(7, 'B.S. Finance', 'BSFN', 'Bachelor', 1, 120, 3755.00, TRUE),
(8, 'B.S. Healthcare Administration', 'BSHA', 'Bachelor', 1, 120, 3755.00, TRUE),
(9, 'B.S. Supply Chain and Operations Management', 'BSSC', 'Bachelor', 1, 120, 3755.00, TRUE),
(10, 'B.S. User Experience Design', 'BSUX', 'Bachelor', 1, 120, 3755.00, TRUE),
(11, 'Master of Business Administration', 'MBA', 'Master', 1, 36, 4755.00, TRUE),
(12, 'MBA Information Technology Management', 'MBAITM', 'Master', 1, 36, 4755.00, TRUE),
(13, 'MBA Healthcare Administration', 'MBAHA', 'Master', 1, 36, 4755.00, TRUE),
(14, 'M.S. Management and Leadership', 'MSML', 'Master', 1, 36, 4755.00, TRUE),
(15, 'M.S. Marketing (Digital Marketing Specialization)', 'MSMKD', 'Master', 1, 36, 4755.00, TRUE),
(16, 'M.S. Marketing (Marketing Analytics Specialization)', 'MSMKA', 'Master', 1, 36, 4755.00, TRUE),
(17, 'M.S. Accounting - Auditing', 'MSACA', 'Master', 1, 30, 4755.00, TRUE),
(18, 'M.S. Accounting - Financial Reporting', 'MSACF', 'Master', 1, 30, 4755.00, TRUE),
(19, 'M.S. Accounting - Management Accounting', 'MSACM', 'Master', 1, 30, 4755.00, TRUE),
(20, 'M.S. Accounting - Taxation', 'MSACT', 'Master', 1, 30, 4755.00, TRUE),
(21, 'M.S. Human Resource Management', 'MSHR', 'Master', 1, 36, 4755.00, TRUE),
(22, 'B.S. Nursing Prelicensure (Pre-Nursing)', 'BSNP', 'Bachelor', 2, 120, 8755.00, TRUE),
(23, 'B.S. Nursing Prelicensure (Nursing)', 'BSNU', 'Bachelor', 2, 120, 8755.00, TRUE),
(24, 'B.S. Nursing (RN to BSN)', 'BSNR', 'Bachelor', 2, 120, 5325.00, TRUE),
(25, 'B.S. Health Information Management', 'BSHIM', 'Bachelor', 2, 120, 4210.00, TRUE),
(26, 'B.S. Health and Human Services', 'BSHHS', 'Bachelor', 2, 120, 4210.00, TRUE),
(27, 'B.S. Health Science', 'BSHS', 'Bachelor', 2, 120, 4210.00, TRUE),
(28, 'B.S. Psychology', 'BSPY', 'Bachelor', 2, 120, 4085.00, TRUE),
(29, 'B.S. Public Health', 'BSPH', 'Bachelor', 2, 120, 4210.00, TRUE),
(30, 'B.S. Cloud and Network Engineering', 'BSCNE', 'Bachelor', 3, 120, 4085.00, TRUE),
(31, 'B.S. Computer Science', 'BSCS', 'Bachelor', 3, 120, 4085.00, TRUE),
(32, 'B.S. Cybersecurity and Information Assurance', 'BSCIA', 'Bachelor', 3, 120, 4365.00, TRUE),
(33, 'B.S. Data Analytics', 'BSDA', 'Bachelor', 3, 120, 3835.00, TRUE),
(34, 'B.S. Information Technology', 'BSIT', 'Bachelor', 3, 120, 3725.00, TRUE),
(35, 'B.S. Software Engineering', 'BSSWE', 'Bachelor', 3, 120, 4085.00, TRUE),
(36, 'B.A. Elementary Education', 'BAEED', 'Bachelor', 4, 120, 3825.00, TRUE),
(37, 'B.A. Special Education and Elementary Education (Dual Licensure)', 'BASEED', 'Bachelor', 4, 120, 3825.00, TRUE),
(38, 'B.S. Mathematics Education (Secondary)', 'BSMAED', 'Bachelor', 4, 120, 3825.00, TRUE);

-- Insert courses (first 102 courses only to keep within reasonable limits)
INSERT INTO D424.courses (id, name, code, competency_units, assessment_type, description, competency_category_id) VALUES
(1, 'Introduction to Communication', 'C464', 3, 'Objective', 'Fundamentals of effective communication in various contexts', 1),
(2, 'English Composition I', 'C455', 3, 'Performance', 'Development of writing skills and academic composition', 1),
(3, 'English Composition II', 'C456', 3, 'Performance', 'Advanced writing skills including research and argumentation', 1),
(4, 'College Algebra', 'C278', 4, 'Objective', 'Algebraic concepts and mathematical problem-solving', 1),
(5, 'Applied Probability and Statistics', 'C459', 3, 'Objective', 'Statistical analysis and probability theory applications', 1),
(6, 'Integrated Natural Sciences', 'C165', 3, 'Objective', 'Interdisciplinary approach to natural science concepts', 1),
(7, 'American Politics and the US Constitution', 'C963', 3, 'Objective', 'Structure and function of American government and political systems', 1),
(8, 'Introduction to Geography', 'C255', 3, 'Objective', 'Physical and human geography concepts and applications', 1),
(9, 'Fundamentals for Success in Business', 'C213', 3, 'Performance', 'Essential business concepts and professional skills', 2),
(10, 'Introduction to Humanities', 'C100', 3, 'Performance', 'Cultural, artistic, and intellectual traditions across civilizations', 1),
(11, 'Spreadsheets', 'C268', 4, 'Performance', 'Microsoft Excel for data analysis and business applications', 2),
(12, 'Principles of Accounting I', 'C248', 4, 'Objective', 'Fundamental accounting principles and financial statement preparation', 2),
(13, 'Principles of Accounting II', 'C249', 4, 'Objective', 'Advanced accounting concepts and managerial accounting principles', 2),
(14, 'Financial and Managerial Accounting', 'C214', 4, 'Objective', 'Integration of financial and managerial accounting concepts', 2),
(15, 'Intermediate Accounting I', 'C250', 4, 'Objective', 'Advanced financial accounting theory and practice', 2),
(16, 'Intermediate Accounting II', 'C251', 4, 'Objective', 'Complex financial accounting topics and reporting', 2),
(17, 'Advanced Accounting', 'C252', 4, 'Objective', 'Specialized accounting topics including partnerships and consolidations', 3),
(18, 'Cost and Managerial Accounting', 'C253', 4, 'Objective', 'Cost analysis and management decision-making tools', 2),
(19, 'Auditing', 'C254', 4, 'Objective', 'Auditing principles, procedures, and professional standards', 3),
(20, 'Federal Income Tax I', 'C256', 4, 'Objective', 'Individual federal income tax preparation and planning', 3),
(21, 'Federal Income Tax II', 'C257', 4, 'Objective', 'Business taxation and advanced tax topics', 3),
(22, 'Governmental and Not-for-Profit Accounting', 'C258', 4, 'Objective', 'Specialized accounting for government and nonprofit organizations', 3),
(23, 'Accounting Ethics', 'C259', 3, 'Performance', 'Professional ethics in accounting practice', 2),
(24, 'Accounting Information Systems', 'C260', 4, 'Performance', 'Technology applications in accounting systems', 2),
(25, 'Business Law', 'C241', 4, 'Objective', 'Legal environment of business and commercial law', 2),
(26, 'Macroeconomics', 'C719', 3, 'Objective', 'National and international economic principles', 2),
(27, 'Microeconomics', 'C718', 3, 'Objective', 'Individual and firm economic behavior analysis', 2),
(28, 'Introduction to Probability and Statistics', 'C951', 3, 'Objective', 'Statistical methods for business decision-making', 2),
(29, 'Organizational Behavior and Leadership', 'C484', 4, 'Performance', 'Human behavior in organizational settings and leadership principles', 2),
(30, 'Operations and Supply Chain Management', 'C720', 4, 'Objective', 'Management of operations and supply chain processes', 2),
(31, 'Global Business', 'C721', 4, 'Performance', 'International business environment and global strategy', 2),
(32, 'Strategic Management', 'C722', 4, 'Performance', 'Strategic planning and competitive analysis', 3),
(33, 'Business Finance', 'C723', 4, 'Objective', 'Financial management and corporate finance principles', 2),
(34, 'Capstone Project', 'C499', 4, 'Performance', 'Integrated application of program knowledge and skills', 4),
(35, 'Principles of Management', 'C483', 4, 'Objective', 'Fundamental management concepts and practices', 2),
(36, 'Human Resource Management Fundamentals', 'C232', 4, 'Performance', 'Core concepts in human resource management', 2),
(37, 'Employment Law', 'C238', 4, 'Objective', 'Legal aspects of employment and workplace regulations', 2),
(38, 'Compensation and Benefits', 'C234', 4, 'Performance', 'Design and administration of compensation systems', 3),
(39, 'Employee and Labor Relations', 'C235', 4, 'Performance', 'Managing employee relations and labor negotiations', 3),
(40, 'Training and Development', 'C236', 4, 'Performance', 'Employee training programs and professional development', 3),
(41, 'Information Technology Fundamentals', 'C182', 3, 'Objective', 'Basic concepts in information technology and computer systems', 2),
(42, 'Network and Security Foundations', 'C172', 4, 'Objective', 'Fundamentals of computer networks and cybersecurity', 2),
(43, 'Scripting and Programming Foundations', 'C173', 3, 'Performance', 'Introduction to programming concepts and scripting', 2),
(44, 'Web Development Foundations', 'C777', 3, 'Performance', 'HTML, CSS, and basic web development skills', 2),
(45, 'Introduction to Databases', 'C175', 3, 'Performance', 'Database design and SQL fundamentals', 2),
(46, 'Marketing Fundamentals', 'C212', 4, 'Objective', 'Core principles of marketing and consumer behavior', 2),
(47, 'Consumer Behavior', 'C215', 4, 'Performance', 'Psychology of consumer decision-making and market research', 2),
(48, 'Marketing Research', 'C216', 4, 'Performance', 'Research methods for marketing decision-making', 3),
(49, 'Digital Marketing', 'C217', 4, 'Performance', 'Online marketing strategies and digital advertising', 3),
(50, 'Brand Management', 'C218', 4, 'Performance', 'Building and managing brand identity and equity', 3),
(51, 'Mass Media and Society', 'C461', 3, 'Performance', 'Role of media in society and communication theory', 2),
(52, 'Introduction to Communication Theory', 'C462', 3, 'Performance', 'Theoretical foundations of human communication', 2),
(53, 'Interpersonal Communication', 'C463', 3, 'Performance', 'Communication in personal and professional relationships', 2),
(54, 'Public Speaking', 'C465', 3, 'Performance', 'Effective oral presentation and public speaking skills', 2),
(55, 'Corporate Finance', 'C724', 4, 'Objective', 'Advanced corporate financial management and analysis', 3),
(56, 'Investment Analysis', 'C725', 4, 'Objective', 'Securities analysis and portfolio management principles', 3),
(57, 'Financial Markets and Institutions', 'C726', 4, 'Objective', 'Structure and function of financial markets and institutions', 3),
(58, 'Healthcare Delivery Systems', 'C210', 4, 'Performance', 'Organization and delivery of healthcare services', 2),
(59, 'Healthcare Economics', 'C211', 4, 'Objective', 'Economic principles applied to healthcare markets', 2),
(60, 'Healthcare Law and Ethics', 'C727', 4, 'Performance', 'Legal and ethical issues in healthcare practice', 2),
(61, 'Supply Chain Strategy', 'C728', 4, 'Performance', 'Strategic planning for supply chain operations', 3),
(62, 'Procurement and Sourcing', 'C729', 4, 'Performance', 'Strategic sourcing and supplier management', 3),
(63, 'Introduction to UX Design', 'C730', 4, 'Performance', 'Fundamentals of user experience design principles', 2),
(64, 'User Research Methods', 'C731', 4, 'Performance', 'Research techniques for understanding user needs', 2),
(65, 'Information Architecture', 'C732', 4, 'Performance', 'Organizing and structuring digital information', 3),
(66, 'Critical Thinking and Logic', 'C168', 3, 'Performance', 'Analytical thinking and logical reasoning skills', 2),
(67, 'Marketing', 'C712', 3, 'Performance', 'Strategic marketing concepts for graduate level', 2),
(68, 'Accounting for Decision Makers', 'C570', 3, 'Objective', 'Financial and managerial accounting for non-accountants', 2),
(69, 'Finance', 'C714', 3, 'Objective', 'Corporate finance and investment analysis', 2),
(70, 'Operations Management', 'C715', 3, 'Performance', 'Operations strategy and process management', 2),
(71, 'Information Systems Management', 'C716', 3, 'Performance', 'Strategic use of information systems in business', 2),
(72, 'Legal Environment of Business', 'C717', 3, 'Objective', 'Legal issues affecting business operations', 2),
(73, 'Human Resource Management', 'C237', 3, 'Performance', 'Strategic human resource management practices', 2),
(74, 'Globalization', 'C750', 3, 'Performance', 'Global business environment and international strategy', 2),
(75, 'Strategy', 'C751', 3, 'Performance', 'Strategic management and competitive advantage', 2),
(76, 'MBA Capstone', 'C501', 4, 'Performance', 'Integrated business strategy capstone project', 4),
(77, 'Anatomy and Physiology I', 'C405', 3, 'Objective', 'Structure and function of human body systems', 2),
(78, 'Anatomy and Physiology II', 'C406', 3, 'Objective', 'Advanced anatomy and physiological processes', 2),
(79, 'Microbiology', 'C453', 3, 'Objective', 'Microbial biology and infectious disease principles', 2),
(80, 'Medical Terminology', 'C772', 3, 'Objective', 'Healthcare terminology and medical language', 2),
(81, 'Pathophysiology', 'C493', 3, 'Objective', 'Disease processes and pathological changes', 2),
(82, 'Pharmacology', 'C489', 3, 'Objective', 'Drug action and therapeutic applications', 2),
(83, 'Nursing Fundamentals', 'C475', 6, 'Performance', 'Basic nursing concepts and clinical skills', 2),
(84, 'Health Assessment', 'C430', 4, 'Performance', 'Physical assessment and health history techniques', 2),
(85, 'Medical-Surgical Nursing I', 'C155', 6, 'Performance', 'Care of adult patients with medical and surgical conditions', 2),
(86, 'Mental Health Nursing', 'C156', 4, 'Performance', 'Psychiatric nursing and mental health interventions', 2),
(87, 'Maternal-Child Nursing', 'C157', 4, 'Performance', 'Obstetric and pediatric nursing care', 2),
(88, 'Community Health Nursing', 'C158', 4, 'Performance', 'Public health and community-based nursing practice', 2),
(89, 'Nursing Leadership and Management', 'C490', 3, 'Performance', 'Leadership principles in nursing practice', 2),
(90, 'Nursing Research and Evidence-Based Practice', 'C361', 3, 'Performance', 'Research methods and evidence-based nursing practice', 2),
(91, 'Introduction to Psychology', 'C958', 3, 'Objective', 'Fundamental concepts in psychological science', 2),
(92, 'Research Methods in Psychology', 'C959', 4, 'Performance', 'Scientific methods in psychological research', 2),
(93, 'Developmental Psychology', 'C960', 3, 'Objective', 'Human development across the lifespan', 2),
(94, 'Abnormal Psychology', 'C961', 3, 'Objective', 'Psychological disorders and mental health conditions', 2),
(95, 'Social Psychology', 'C962', 3, 'Objective', 'Social influences on behavior and cognition', 2),
(96, 'Introduction to Health Information Management', 'C372', 4, 'Performance', 'Healthcare data management and information systems', 2),
(97, 'Health Data Management', 'C373', 4, 'Performance', 'Collection, analysis, and management of health data', 2),
(98, 'Electronic Health Records', 'C374', 4, 'Performance', 'Electronic health record systems and implementation', 2),
(99, 'Introduction to Public Health', 'C376', 3, 'Performance', 'Public health principles and population health', 2),
(100, 'Epidemiology', 'C377', 4, 'Objective', 'Disease patterns and public health surveillance', 2),
(101, 'Biostatistics', 'C378', 4, 'Objective', 'Statistical methods in health and medical research', 2),
(102, 'Environmental Health', 'C379', 3, 'Performance', 'Environmental factors affecting human health', 2);

-- Insert program_courses relationships (sample for major programs)
INSERT INTO D424.program_courses (program_id, course_id, sequence_order, is_required, competency_category_id) VALUES
-- B.S. Accounting (Program ID: 1) - Sample courses
(1, 1, 1, TRUE, 1), (1, 2, 2, TRUE, 1), (1, 3, 3, TRUE, 1), (1, 4, 4, TRUE, 1), (1, 5, 5, TRUE, 1),
(1, 6, 6, TRUE, 1), (1, 7, 7, TRUE, 1), (1, 8, 8, TRUE, 1), (1, 9, 9, TRUE, 1), (1, 10, 10, TRUE, 1),
(1, 11, 11, TRUE, 2), (1, 12, 12, TRUE, 2), (1, 13, 13, TRUE, 2), (1, 14, 14, TRUE, 2), (1, 15, 15, TRUE, 2),
(1, 16, 16, TRUE, 2), (1, 17, 17, TRUE, 3), (1, 18, 18, TRUE, 2), (1, 19, 19, TRUE, 3), (1, 20, 20, TRUE, 3),
(1, 21, 21, TRUE, 3), (1, 22, 22, TRUE, 3), (1, 23, 23, TRUE, 2), (1, 24, 24, TRUE, 2), (1, 25, 25, TRUE, 2),
(1, 26, 26, TRUE, 2), (1, 27, 27, TRUE, 2), (1, 28, 28, TRUE, 2), (1, 29, 29, TRUE, 2), (1, 30, 30, TRUE, 2),
(1, 31, 31, TRUE, 2), (1, 32, 32, TRUE, 3), (1, 33, 33, TRUE, 2), (1, 34, 34, TRUE, 4),

-- B.S. Human Resource Management (Program ID: 2)
(2, 1, 1, TRUE, 1), (2, 2, 2, TRUE, 1), (2, 3, 3, TRUE, 1), (2, 4, 4, TRUE, 1), (2, 5, 5, TRUE, 1),
(2, 6, 6, TRUE, 1), (2, 7, 7, TRUE, 1), (2, 8, 8, TRUE, 1), (2, 9, 9, TRUE, 1), (2, 10, 10, TRUE, 1),
(2, 11, 11, TRUE, 2), (2, 35, 12, TRUE, 2), (2, 29, 13, TRUE, 2), (2, 36, 14, TRUE, 2), (2, 37, 15, TRUE, 2),
(2, 38, 16, TRUE, 3), (2, 39, 17, TRUE, 3), (2, 40, 18, TRUE, 3), (2, 26, 19, TRUE, 2), (2, 91, 20, TRUE, 1),
(2, 34, 21, TRUE, 4),

-- B.S. Nursing (RN to BSN) (Program ID: 24)
(24, 1, 1, TRUE, 1), (24, 2, 2, TRUE, 1), (24, 3, 3, TRUE, 1), (24, 5, 4, TRUE, 1), (24, 9, 5, TRUE, 1),
(24, 10, 6, TRUE, 1), (24, 6, 7, TRUE, 1), (24, 7, 8, TRUE, 1), (24, 8, 9, TRUE, 1), (24, 90, 10, TRUE, 2),
(24, 89, 11, TRUE, 2), (24, 88, 12, TRUE, 2), (24, 84, 13, TRUE, 2), (24, 34, 14, TRUE, 4),

-- Master of Business Administration (Program ID: 11)
(11, 66, 1, TRUE, 2), (11, 29, 2, TRUE, 2), (11, 67, 3, TRUE, 2), (11, 68, 4, TRUE, 2), (11, 69, 5, TRUE, 2),
(11, 70, 6, TRUE, 2), (11, 71, 7, TRUE, 2), (11, 72, 8, TRUE, 2), (11, 73, 9, TRUE, 2), (11, 74, 10, TRUE, 2),
(11, 75, 11, TRUE, 2), (11, 76, 12, TRUE, 4);

-- Insert prerequisites
INSERT INTO D424.prerequisites (course_id, prerequisite_course_id, is_required) VALUES
(3, 2, TRUE),           -- English Composition II requires English Composition I
(13, 12, TRUE),         -- Principles of Accounting II requires Principles of Accounting I
(15, 13, TRUE),         -- Intermediate Accounting I requires Principles of Accounting II
(16, 15, TRUE),         -- Intermediate Accounting II requires Intermediate Accounting I
(17, 16, TRUE),         -- Advanced Accounting requires Intermediate Accounting II
(21, 20, TRUE),         -- Federal Income Tax II requires Federal Income Tax I
(78, 77, TRUE),         -- Anatomy and Physiology II requires Anatomy and Physiology I
(85, 83, TRUE),         -- Medical-Surgical Nursing I requires Nursing Fundamentals
(86, 83, TRUE),         -- Mental Health Nursing requires Nursing Fundamentals
(87, 83, TRUE),         -- Maternal-Child Nursing requires Nursing Fundamentals
(88, 83, TRUE);         -- Community Health Nursing requires Nursing Fundamentals

-- Insert sample assessments for courses
INSERT INTO D424.assessments (course_id, name, type, description, passing_score, max_attempts, time_limit_minutes, is_proctored, is_required_to_pass, sequence_order) VALUES
-- General Education Courses (1-10)
(1, 'Communication Final Assessment', 'O', 'Comprehensive test on communication principles and practices', 80.00, 3, 120, TRUE, TRUE, 1),
(2, 'Essay Portfolio', 'P', 'Portfolio of academic essays demonstrating writing proficiency', 80.00, 2, NULL, FALSE, TRUE, 1),
(3, 'Research Paper', 'P', 'Comprehensive research paper with proper citations and argumentation', 80.00, 2, NULL, FALSE, TRUE, 1),
(4, 'College Algebra Final Assessment', 'O', 'Comprehensive algebraic problem-solving assessment', 80.00, 3, 120, TRUE, TRUE, 1),
(5, 'Applied Statistics Final Assessment', 'O', 'Comprehensive assessment of statistical concepts and applications', 80.00, 3, 120, TRUE, TRUE, 1),
(6, 'Integrated Natural Sciences Final Assessment', 'O', 'Comprehensive science concepts examination', 80.00, 3, 150, TRUE, TRUE, 1),
(7, 'American Politics Final Assessment', 'O', 'Assessment of US government and political systems knowledge', 80.00, 3, 120, TRUE, TRUE, 1),
(8, 'Introduction to Geography Final Assessment', 'O', 'Physical and human geography comprehensive exam', 80.00, 3, 120, TRUE, TRUE, 1),
(9, 'Business Success Portfolio', 'P', 'Comprehensive business fundamentals project portfolio', 80.00, 2, NULL, FALSE, TRUE, 1),
(10, 'Humanities Final Assessment', 'O', 'Cultural and intellectual traditions examination', 80.00, 3, 120, TRUE, TRUE, 1),

-- Accounting Courses (12-24)
(12, 'Accounting Principles I Final Assessment', 'O', 'Comprehensive test on fundamental accounting principles', 80.00, 3, 150, TRUE, TRUE, 1),
(13, 'Accounting Principles II Final Assessment', 'O', 'Advanced accounting concepts and managerial accounting exam', 80.00, 3, 150, TRUE, TRUE, 1),
(14, 'Financial and Managerial Accounting Final Assessment', 'O', 'Integration of financial and managerial accounting assessment', 80.00, 3, 150, TRUE, TRUE, 1),
(15, 'Intermediate Accounting I Final Assessment', 'O', 'Advanced financial accounting theory examination', 80.00, 3, 180, TRUE, TRUE, 1),
(16, 'Intermediate Accounting II Final Assessment', 'O', 'Complex financial accounting topics assessment', 80.00, 3, 180, TRUE, TRUE, 1),
(17, 'Advanced Accounting Final Assessment', 'O', 'Specialized accounting topics examination', 80.00, 3, 180, TRUE, TRUE, 1),
(18, 'Cost and Managerial Accounting Final Assessment', 'O', 'Cost analysis and management decision-making exam', 80.00, 3, 150, TRUE, TRUE, 1),
(19, 'Auditing Final Assessment', 'O', 'Auditing principles and professional standards exam', 80.00, 3, 180, TRUE, TRUE, 1),
(20, 'Federal Income Tax I Final Assessment', 'O', 'Individual federal tax preparation assessment', 80.00, 3, 150, TRUE, TRUE, 1),
(21, 'Federal Income Tax II Final Assessment', 'O', 'Business taxation and advanced tax topics exam', 80.00, 3, 150, TRUE, TRUE, 1),
(22, 'Governmental Accounting Final Assessment', 'O', 'Government and nonprofit accounting examination', 80.00, 3, 150, TRUE, TRUE, 1),
(23, 'Accounting Ethics Portfolio', 'P', 'Professional ethics case study analysis portfolio', 80.00, 2, NULL, FALSE, TRUE, 1),
(24, 'Accounting Information Systems Project', 'P', 'Technology applications in accounting systems project', 80.00, 2, NULL, FALSE, TRUE, 1),

-- Business Core Courses (25-40)
(25, 'Business Law Final Assessment', 'O', 'Legal environment of business examination', 80.00, 3, 150, TRUE, TRUE, 1),
(26, 'Macroeconomics Final Assessment', 'O', 'National and international economic principles exam', 80.00, 3, 120, TRUE, TRUE, 1),
(27, 'Microeconomics Final Assessment', 'O', 'Individual and firm economic behavior analysis exam', 80.00, 3, 120, TRUE, TRUE, 1),
(29, 'Leadership Case Study Analysis', 'P', 'Analysis of organizational behavior scenarios and leadership challenges', 80.00, 2, NULL, FALSE, TRUE, 1),
(30, 'Operations Management Final Assessment', 'O', 'Operations and supply chain management examination', 80.00, 3, 120, TRUE, TRUE, 1),
(33, 'Business Finance Final Assessment', 'O', 'Financial management and corporate finance exam', 80.00, 3, 150, TRUE, TRUE, 1),
(34, 'Business Capstone Project', 'P', 'Comprehensive business strategy capstone project', 80.00, 2, NULL, FALSE, TRUE, 1),
(35, 'Principles of Management Final Assessment', 'O', 'Fundamental management concepts examination', 80.00, 3, 120, TRUE, TRUE, 1),

-- Healthcare Courses (77-102)
(77, 'Anatomy & Physiology I Final Assessment', 'O', 'Comprehensive examination of body systems', 80.00, 3, 150, TRUE, TRUE, 1),
(78, 'Anatomy & Physiology II Final Assessment', 'O', 'Advanced anatomy and physiological processes exam', 80.00, 3, 150, TRUE, TRUE, 1),
(83, 'Nursing Skills Demonstration', 'P', 'Practical demonstration of fundamental nursing skills', 80.00, 2, NULL, FALSE, TRUE, 1),
(84, 'Health Assessment Skills', 'P', 'Physical assessment and health history techniques demonstration', 80.00, 2, NULL, FALSE, TRUE, 1),
(88, 'Community Health Nursing Project', 'P', 'Public health and community-based nursing practice project', 80.00, 2, NULL, FALSE, TRUE, 1),
(89, 'Nursing Leadership Portfolio', 'P', 'Leadership principles in nursing practice portfolio', 80.00, 2, NULL, FALSE, TRUE, 1),
(90, 'Evidence-Based Practice Project', 'P', 'Research methods and evidence-based nursing practice project', 80.00, 2, NULL, FALSE, TRUE, 1),

-- Graduate Business Courses (66-76)
(66, 'Critical Thinking Portfolio', 'P', 'Analytical thinking and logical reasoning project', 80.00, 2, NULL, FALSE, TRUE, 1),
(67, 'Graduate Marketing Portfolio', 'P', 'Strategic marketing concepts project', 80.00, 2, NULL, FALSE, TRUE, 1),
(68, 'Accounting for Managers Final Assessment', 'O', 'Financial and managerial accounting for non-accountants exam', 80.00, 3, 120, TRUE, TRUE, 1),
(69, 'Corporate Finance Final Assessment', 'O', 'Graduate-level corporate finance and investment analysis exam', 80.00, 3, 150, TRUE, TRUE, 1),
(70, 'Operations Strategy Portfolio', 'P', 'Operations strategy and process management project', 80.00, 2, NULL, FALSE, TRUE, 1),
(76, 'MBA Capstone Project', 'P', 'Integrated business strategy capstone project', 80.00, 2, NULL, FALSE, TRUE, 1);

-- Create indexes for better performance
CREATE INDEX idx_programs_college ON D424.programs(college_id);
CREATE INDEX idx_program_courses_program ON D424.program_courses(program_id);
CREATE INDEX idx_program_courses_course ON D424.program_courses(course_id);
CREATE INDEX idx_prerequisites_course ON D424.prerequisites(course_id);
CREATE INDEX idx_prerequisites_prereq ON D424.prerequisites(prerequisite_course_id);
CREATE INDEX idx_courses_category ON D424.courses(competency_category_id);
CREATE INDEX idx_courses_active ON D424.courses(is_active);
CREATE INDEX idx_programs_active ON D424.programs(is_active);
CREATE INDEX idx_programs_degree_level ON D424.programs(degree_level);
CREATE INDEX idx_assessments_course ON D424.assessments(course_id);
CREATE INDEX idx_assessments_type ON D424.assessments(type);
CREATE INDEX idx_assessments_active ON D424.assessments(is_active);

-- Add useful views for common queries
CREATE VIEW D424.program_summary AS
SELECT 
    p.id,
    p.name as program_name,
    p.code as program_code,
    p.degree_level,
    c.name as college_name,
    p.total_competency_units,
    p.tuition_per_term,
    COUNT(pc.course_id) as total_courses,
    SUM(co.competency_units) as total_assigned_units
FROM D424.programs p
JOIN D424.colleges c ON p.college_id = c.id
LEFT JOIN D424.program_courses pc ON p.id = pc.program_id
LEFT JOIN D424.courses co ON pc.course_id = co.id
WHERE p.is_active = TRUE
GROUP BY p.id, p.name, p.code, p.degree_level, c.name, p.total_competency_units, p.tuition_per_term;

CREATE VIEW D424.course_prerequisites_view AS
SELECT 
    c.id as course_id,
    c.name as course_name,
    c.code as course_code,
    pc.id as prerequisite_course_id,
    pc.name as prerequisite_course_name,
    pc.code as prerequisite_course_code
FROM D424.courses c
JOIN D424.prerequisites p ON c.id = p.course_id
JOIN D424.courses pc ON p.prerequisite_course_id = pc.id
WHERE c.is_active = TRUE AND pc.is_active = TRUE;

CREATE VIEW D424.program_course_sequence AS
SELECT 
    p.name as program_name,
    p.code as program_code,
    c.name as course_name,
    c.code as course_code,
    pc.sequence_order,
    c.competency_units,
    c.assessment_type,
    cc.name as competency_category,
    pc.is_required
FROM D424.programs p
JOIN D424.program_courses pc ON p.id = pc.program_id
JOIN D424.courses c ON pc.course_id = c.id
LEFT JOIN D424.competency_categories cc ON pc.competency_category_id = cc.id
WHERE p.is_active = TRUE AND c.is_active = TRUE
ORDER BY p.code, pc.sequence_order;

-- Add table comments for documentation
ALTER TABLE D424.colleges COMMENT = 'Academic colleges/schools within WGU';
ALTER TABLE D424.programs COMMENT = 'Degree programs offered by WGU';
ALTER TABLE D424.courses COMMENT = 'Individual courses with competency units and assessment information';
ALTER TABLE D424.program_courses COMMENT = 'Junction table linking programs to their required courses';
ALTER TABLE D424.prerequisites COMMENT = 'Course prerequisite relationships';
ALTER TABLE D424.assessment_types COMMENT = 'Types of assessments used at WGU';
ALTER TABLE D424.competency_categories COMMENT = 'Categories for organizing competencies and courses';
ALTER TABLE D424.assessments COMMENT = 'Individual assessments within courses';