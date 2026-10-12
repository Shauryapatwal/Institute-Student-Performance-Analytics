/*
===============================================================
Institute & Student Performance Analytics
===============================================================

Business Goal:
Analyze student enrollment, course performance, faculty performance,
fees, attendance, placement, admissions and batch capacity.

Tables:
1. students
2. faculty
3. batch

Skills demonstrated:
FILE IMPORT, SELECT, WHERE, ORDER BY, CASE, Aggregations, GROUP BY, HAVING,
JOINs, Subqueries, CTEs, Window Functions, Date Functions,
Conditional Aggregation, Views, Stored Procedures, Transactions,
Indexes and EXPLAIN.

*/

CREATE DATABASE IF NOT EXISTS institute_analytics;
USE institute_analytics;

-- =============================================================
-- SECTION 1: TABLE STRUCTURE
-- =============================================================

DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS batch;
DROP TABLE IF EXISTS faculty;

CREATE TABLE students (
  StudentID          VARCHAR(20) PRIMARY KEY,
  Name                VARCHAR(100),
  Email                VARCHAR(100),
  Phone                BIGINT,
  City                 VARCHAR(50),
  CourseID             VARCHAR(20),
  Course               VARCHAR(100),
  BatchID              VARCHAR(20),
  BatchShift           VARCHAR(20),
  Mode                 VARCHAR(20),
  FacultyID            VARCHAR(20),
  FacultyName          VARCHAR(100),
  InternName           VARCHAR(100),
  JoinDate             VARCHAR(20),
  ExpectedEndDate      VARCHAR(20),
  Status               VARCHAR(20),
  AdmissionSource      VARCHAR(50),
  PlacementStatus      VARCHAR(20),
  Fees                 INT,
  Paid                 INT,
  OutstandingFees      INT,
  FeePaidPercent       INT,
  FeeStatus            VARCHAR(20),
  FeeStatusDerived     VARCHAR(20),
  FeeStatusCheck       VARCHAR(20),
  AttendancePercent    INT,
  Score                INT,
  ClassPattern         VARCHAR(20),
  BatchStartTime       VARCHAR(20),
  PhotoPath            VARCHAR(255)
);

CREATE TABLE faculty (
    FacultyID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    CourseID VARCHAR(10),
    PrimarySpecialization VARCHAR(100),
    Batch VARCHAR(30),
    ClassPattern VARCHAR(20),
    BatchStartTime TIME,
    JoinDate DATE,
    ExperienceYears INT,
    ClassesTaken INT,
    AttendancePercent DECIMAL(5,2),
    Feedback DECIMAL(3,2),
    Salary DECIMAL(12,2),
    Status VARCHAR(30),
    FacultyStatus VARCHAR(30),
    PhotoPath VARCHAR(255)
);

CREATE TABLE batch (
    BatchID VARCHAR(10) PRIMARY KEY,
    CourseID VARCHAR(10),
    Course VARCHAR(100),
    FacultyID VARCHAR(10),
    FacultyName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    StudentsCount INT,
    ClassPattern VARCHAR(20),
    BatchStartTime TIME,
    Mode VARCHAR(30),
    Status VARCHAR(30),
    AssignedStudentsCount INT,
    CapacityGap INT,

    INDEX idx_batch_course (CourseID),
    INDEX idx_batch_faculty (FacultyID),
    INDEX idx_batch_start_date (StartDate),
    INDEX idx_batch_status (Status)
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/01_Student_Master_Enhanced.csv'
INTO TABLE students
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @StudentID,
    @Name,
    @Email,
    @Phone,
    @City,
    @CourseID,
    @Course,
    @BatchID,
    @BatchShift,
    @Mode,
    @FacultyID,
    @FacultyName,
    @InternName,
    @JoinDate,
    @ExpectedEndDate,
    @Status,
    @AdmissionSource,
    @PlacementStatus,
    @Fees,
    @Paid,
    @OutstandingFees,
    @FeePaidPercent,
    @FeeStatus,
    @FeeStatusDerived,
    @FeeStatusCheck,
    @AttendancePercent,
    @Score,
    @ClassPattern,
    @BatchStartTime,
    @PhotoPath
)
SET
    StudentID = NULLIF(@StudentID, ''),
    Name = NULLIF(@Name, ''),
    Email = NULLIF(@Email, ''),
    Phone = NULLIF(@Phone, ''),
    City = NULLIF(@City, ''),
    CourseID = NULLIF(@CourseID, ''),
    Course = NULLIF(@Course, ''),
    BatchID = NULLIF(@BatchID, ''),
    BatchShift = NULLIF(@BatchShift, ''),
    Mode = NULLIF(@Mode, ''),
    FacultyID = NULLIF(@FacultyID, ''),
    FacultyName = NULLIF(@FacultyName, ''),
    InternName = NULLIF(@InternName, ''),
    JoinDate = STR_TO_DATE(NULLIF(@JoinDate, ''), '%d-%m-%Y'),
    ExpectedEndDate = STR_TO_DATE(NULLIF(@ExpectedEndDate, ''), '%d-%m-%Y'),
    Status = NULLIF(@Status, ''),
    AdmissionSource = NULLIF(@AdmissionSource, ''),
    PlacementStatus = NULLIF(@PlacementStatus, ''),
    Fees = NULLIF(@Fees, ''),
    Paid = NULLIF(@Paid, ''),
    OutstandingFees = NULLIF(@OutstandingFees, ''),
    FeePaidPercent = NULLIF(@FeePaidPercent, ''),
    FeeStatus = NULLIF(@FeeStatus, ''),
    FeeStatusDerived = NULLIF(@FeeStatusDerived, ''),
    FeeStatusCheck = NULLIF(@FeeStatusCheck, ''),
    AttendancePercent = NULLIF(@AttendancePercent, ''),
    Score = NULLIF(@Score, ''),
    ClassPattern = NULLIF(@ClassPattern, ''),
    BatchStartTime = NULLIF(@BatchStartTime, ''),
    PhotoPath = NULLIF(@PhotoPath, '');
    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/02_Faculty_Master_Enhanced.csv'
INTO TABLE faculty
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @FacultyID,
    @Name,
    @Email,
    @Phone,
    @CourseID,
    @PrimarySpecialization,
    @Batch,
    @ClassPattern,
    @BatchStartTime,
    @JoinDate,
    @ExperienceYears,
    @ClassesTaken,
    @AttendancePercent,
    @Feedback,
    @Salary,
    @Status,
    @FacultyStatus,
    @PhotoPath
)
SET
    FacultyID = NULLIF(@FacultyID, ''),
    Name = NULLIF(@Name, ''),
    Email = NULLIF(@Email, ''),
    Phone = NULLIF(@Phone, ''),
    CourseID = NULLIF(@CourseID, ''),
    PrimarySpecialization = NULLIF(@PrimarySpecialization, ''),
    Batch = NULLIF(@Batch, ''),
    ClassPattern = NULLIF(@ClassPattern, ''),
    BatchStartTime = STR_TO_DATE(NULLIF(@BatchStartTime, ''), '%H:%i'),
    JoinDate = STR_TO_DATE(NULLIF(@JoinDate, ''), '%Y-%m-%d'),
    ExperienceYears = NULLIF(@ExperienceYears, ''),
    ClassesTaken = NULLIF(@ClassesTaken, ''),
    AttendancePercent = NULLIF(@AttendancePercent, ''),
    Feedback = NULLIF(@Feedback, ''),
    Salary = NULLIF(@Salary, ''),
    Status = NULLIF(@Status, ''),
    FacultyStatus = NULLIF(@FacultyStatus, ''),
    PhotoPath = NULLIF(@PhotoPath, '');
    
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/03_Batch_Master_Enhanced.csv'
INTO TABLE batch
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @BatchID,
    @CourseID,
    @Course,
    @FacultyID,
    @FacultyName,
    @StartDate,
    @EndDate,
    @StudentsCount,
    @ClassPattern,
    @BatchStartTime,
    @Mode,
    @Status,
    @AssignedStudentsCount,
    @CapacityGap
)
SET
    BatchID = NULLIF(@BatchID, ''),
    CourseID = NULLIF(@CourseID, ''),
    Course = NULLIF(@Course, ''),
    FacultyID = NULLIF(@FacultyID, ''),
    FacultyName = NULLIF(@FacultyName, ''),

    StartDate = STR_TO_DATE(
        NULLIF(@StartDate, ''),
        '%d-%m-%Y'
    ),

    EndDate = STR_TO_DATE(
        NULLIF(@EndDate, ''),
        '%d-%m-%Y'
    ),

    StudentsCount = NULLIF(@StudentsCount, ''),
    ClassPattern = NULLIF(@ClassPattern, ''),

    BatchStartTime = STR_TO_DATE(
        NULLIF(@BatchStartTime, ''),
        '%H:%i'
    ),

    Mode = NULLIF(@Mode, ''),
    Status = NULLIF(@Status, ''),
    AssignedStudentsCount = NULLIF(@AssignedStudentsCount, ''),
    CapacityGap = NULLIF(@CapacityGap, '');

-- =============================================================
-- SECTION 2: DATA QUALITY CHECKS
-- =============================================================

-- 1. All records
SELECT * FROM students;
SELECT * FROM faculty;
SELECT * FROM batch;

-- 2. Checking Duplicate student IDs
SELECT StudentID, COUNT(*) AS Duplicate_Count
FROM students
GROUP BY StudentID
HAVING COUNT(*) > 1;

-- 3.  Checking Duplicate emails
SELECT Email, COUNT(*) AS Duplicate_Count
FROM students
GROUP BY Email
HAVING COUNT(*) > 1;

-- 4. Missing values
SELECT
    SUM(StudentID IS NULL) AS Missing_StudentID,
    SUM(Name IS NULL) AS Missing_Name,
    SUM(CourseID IS NULL) AS Missing_CourseID,
    SUM(BatchID IS NULL) AS Missing_BatchID,
    SUM(FacultyID IS NULL) AS Missing_FacultyID
FROM students;

-- 5. Invalid fee records
SELECT *
FROM students
WHERE Paid > Fees OR Paid < 0 OR Fees < 0;

-- =============================================================
-- SECTION 3: BASIC SQL
-- =============================================================

-- Q1. Display all students
SELECT * FROM students;

-- Q2. Display selected columns
SELECT StudentID, Name, Course, City, Status
FROM students;

-- Q3. Students from Delhi
SELECT *
FROM students
WHERE City = 'Delhi';

-- Q4. Students with score above 80
SELECT StudentID, Name, Score
FROM students
WHERE Score > 80
ORDER BY Score DESC;

-- Q5. Students with attendance below 75%
SELECT StudentID, Name, AttendancePercent
FROM students
WHERE AttendancePercent < 75
ORDER BY AttendancePercent;

-- Q6. Students who are active
SELECT *
FROM students
WHERE Status = 'Active';

-- Q7. Unique courses
SELECT DISTINCT Course
FROM students
ORDER BY Course;

-- Q8. Students from selected cities
SELECT StudentID, Name, City, Course
FROM students
WHERE City IN ('Delhi','Faridabad','Noida');

-- Q9. Students whose fees are between 10000 and 20000
SELECT StudentID, Name, Fees
FROM students
WHERE Fees BETWEEN 10000 AND 20000;

-- Q10. Names starting with A
SELECT StudentID, Name
FROM students
WHERE Name LIKE 'A%';

-- =============================================================
-- SECTION 4: AGGREGATION
-- =============================================================

-- Q11. Total students
SELECT COUNT(*) AS Total_Students
FROM students;

-- Q12. Total fees
SELECT SUM(Fees) AS Total_Fees
FROM students;

-- Q13. Total collected fees
SELECT SUM(Paid) AS Total_Collected
FROM students;

-- Q14. Outstanding fees
SELECT SUM(OutstandingFees) AS Outstanding_Fees
FROM students;

-- Q15. Average score
SELECT ROUND(AVG(Score),2) AS Average_Score
FROM students;

-- Q16. Course-wise student count
SELECT Course, COUNT(*) AS Student_Count
FROM students
GROUP BY Course
ORDER BY Student_Count DESC;

-- Q17. Course-wise average score
SELECT Course, ROUND(AVG(Score),2) AS Avg_Score
FROM student
GROUP BY Course
ORDER BY Avg_Score DESC;

-- Q18. Course-wise revenue
SELECT Course, SUM(Paid) AS Revenue
FROM students
GROUP BY Course
ORDER BY Revenue DESC;

-- Q19. Admission-source-wise students
SELECT AdmissionSource, COUNT(*) AS Students
FROM students
GROUP BY AdmissionSource
ORDER BY Students DESC;

-- Q20. Status-wise students
SELECT Status, COUNT(*) AS Students
FROM students
GROUP BY Status;

-- =============================================================
-- SECTION 5: CASE WHEN
-- =============================================================

-- Q21. Create performance category
SELECT
    StudentID,
    Name,
    Score,
    CASE
        WHEN Score >= 90 THEN 'Excellent'
        WHEN Score >= 75 THEN 'Good'
        WHEN Score >= 60 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS Performance_Category
FROM students;

-- Q22. Attendance category
SELECT
    StudentID,
    Name,
    AttendancePercent,
    CASE
        WHEN AttendancePercent >= 90 THEN 'Excellent'
        WHEN AttendancePercent >= 75 THEN 'Good'
        WHEN AttendancePercent >= 60 THEN 'Average'
        ELSE 'Low'
    END AS Attendance_Category
FROM students;

-- Q23. Fee category
SELECT
    StudentID,
    Name,
    Fees,
    Paid,
    CASE
        WHEN Paid = 0 THEN 'No Payment'
        WHEN Paid < Fees THEN 'Partial'
        WHEN Paid >= Fees THEN 'Fully Paid'
    END AS Payment_Category
FROM students;

-- =============================================================
-- SECTION 6: JOINS
-- =============================================================

-- Q24. Student + Faculty
SELECT
    s.StudentID,
    s.Name AS StudentName,
    s.Course,
    f.FacultyID,
    f.Name AS FacultyName,
    f.ExperienceYears
FROM students s
LEFT JOIN faculty f
    ON s.FacultyID = f.FacultyID;

-- Q25. Student + Batch
SELECT
    s.StudentID,
    s.Name,
    s.Course,
    b.BatchID,
    b.StartDate,
    b.EndDate,
    b.Mode
FROM students s
LEFT JOIN batch b
    ON s.BatchID = b.BatchID;

-- Q26. Student + Batch + Faculty
SELECT
    s.StudentID,
    s.Name AS StudentName,
    s.Course,
    b.BatchID,
    f.Name AS FacultyName,
    s.Score,
    s.AttendancePercent
FROM students s
LEFT JOIN batch b
    ON s.BatchID = b.BatchID
LEFT JOIN faculty f
    ON s.FacultyID = f.FacultyID;

-- Q27. Faculty-wise students
SELECT
    f.FacultyID,
    f.Name AS FacultyName,
    COUNT(s.StudentID) AS Students
FROM faculty f
LEFT JOIN students s
    ON f.FacultyID = s.FacultyID
GROUP BY f.FacultyID, f.Name
ORDER BY Students DESC;

-- Q28. Batch-wise students
SELECT
    b.BatchID,
    b.Course,
    COUNT(s.StudentID) AS Actual_Students,
    b.StudentsCount AS Planned_Students
FROM batch b
LEFT JOIN students s
    ON b.BatchID = s.BatchID
GROUP BY b.BatchID, b.Course, b.StudentsCount;

-- =============================================================
-- SECTION 7: HAVING / BUSINESS ANALYSIS
-- =============================================================

-- Q29. Courses having more than 40 students
SELECT Course, COUNT(*) AS Students
FROM students
GROUP BY Course
HAVING COUNT(*) > 40;

-- Q30. Courses with average score above 70
SELECT Course, ROUND(AVG(Score),2) AS Avg_Score
FROM students
GROUP BY Course
HAVING AVG(Score) > 70;

-- Q31. Faculties handling more than 50 students
SELECT FacultyID, COUNT(*) AS Students
FROM students
GROUP BY FacultyID
HAVING COUNT(*) > 50;

-- =============================================================
-- SECTION 8: SUBQUERIES
-- =============================================================

-- Q32. Students scoring above overall average
SELECT StudentID, Name, Score
FROM students
WHERE Score > (
    SELECT AVG(Score) FROM student_master
)
ORDER BY Score DESC;

-- Q33. Students paying above average fees
SELECT StudentID, Name, Fees
FROM students
WHERE Fees > (
    SELECT AVG(Fees) FROM student_master
);

-- Q34. Students with highest score
SELECT *
FROM students
WHERE Score = (
    SELECT MAX(Score) FROM student_master
);

-- Q35. Students in the course having the highest average score
SELECT *
FROM students
WHERE Course = (
    SELECT Course
    FROM students
    GROUP BY Course
    ORDER BY AVG(Score) DESC
    LIMIT 1
);

-- =============================================================
-- SECTION 9: DATE ANALYSIS
-- =============================================================

-- Q36. Students joined in 2024
SELECT *
FROM students
WHERE YEAR(JoinDate) = 2024;

-- Q37. Month-wise enrollment
SELECT
    YEAR(JoinDate) AS Join_Year,
    MONTH(JoinDate) AS Join_Month,
    COUNT(*) AS Students
FROM students
GROUP BY YEAR(JoinDate), MONTH(JoinDate)
ORDER BY Join_Year, Join_Month;

-- Q38. Year-wise enrollment
SELECT YEAR(JoinDate) AS Join_Year, COUNT(*) AS Students
FROM students
GROUP BY YEAR(JoinDate)
ORDER BY Join_Year;

-- Q39. Average course duration from batches
SELECT
    Course,
    ROUND(AVG(DATEDIFF(EndDate, StartDate)),0) AS Avg_Duration_Days
FROM batch
GROUP BY Course
ORDER BY Avg_Duration_Days DESC;

-- =============================================================
-- SECTION 10: CONDITIONAL AGGREGATION
-- =============================================================

-- Q40. Status summary
SELECT
    COUNT(*) AS Total,
    SUM(Status = 'Active') AS Active_Students,
    SUM(Status = 'Completed') AS Completed_Students,
    SUM(Status = 'Dropout') AS Dropout_Students
FROM students;

-- Q41. Placement summary
SELECT
    COUNT(*) AS Total_Students,
    SUM(PlacementStatus = 'Placed') AS Placed,
    SUM(PlacementStatus = 'In Process') AS In_Process,
    SUM(PlacementStatus = 'Not Eligible') AS Not_Eligible
FROM students;

-- Q42. Course-level placement rate
SELECT
    Course,
    COUNT(*) AS Total_Students,
    SUM(PlacementStatus = 'Placed') AS Placed,
    ROUND(
        100 * SUM(PlacementStatus = 'Placed') / COUNT(*), 2
    ) AS Placement_Rate
FROM students
GROUP BY Course
ORDER BY Placement_Rate DESC;

-- =============================================================
-- SECTION 11: CTEs
-- =============================================================

-- Q43. Course performance summary using CTE
WITH course_summary AS (
    SELECT
        Course,
        COUNT(*) AS Students,
        ROUND(AVG(Score),2) AS Avg_Score,
        ROUND(AVG(AttendancePercent),2) AS Avg_Attendance,
        SUM(Paid) AS Revenue
    FROM students
    GROUP BY Course
)
SELECT *
FROM course_summary
ORDER BY Avg_Score DESC;

-- Q44. Students above their course average
WITH course_avg AS (
    SELECT Course, AVG(Score) AS Avg_Score
    FROM students
    GROUP BY Course
)
SELECT
    s.StudentID,
    s.Name,
    s.Course,
    s.Score,
    ROUND(c.Avg_Score,2) AS Course_Average
FROM students s
JOIN course_avg c
    ON s.Course = c.Course
WHERE s.Score > c.Avg_Score
ORDER BY s.Course, s.Score DESC;

-- Q45. Course revenue ranking
WITH revenue AS (
    SELECT Course, SUM(Paid) AS Revenue
    FROM students
    GROUP BY Course
)
SELECT
    Course,
    Revenue,
    RANK() OVER (ORDER BY Revenue DESC) AS Revenue_Rank
FROM revenue;

-- =============================================================
-- SECTION 12: WINDOW FUNCTIONS
-- =============================================================

-- Q46. Rank students overall
SELECT
    StudentID,
    Name,
    Course,
    Score,
    RANK() OVER (ORDER BY Score DESC) AS Overall_Rank
FROM students;

-- Q47. Rank students within each course
SELECT
    StudentID,
    Name,
    Course,
    Score,
    RANK() OVER (
        PARTITION BY Course
        ORDER BY Score DESC
    ) AS Course_Rank
FROM students;

-- Q48. Top 3 students per course
WITH ranked_students AS (
    SELECT
        StudentID,
        Name,
        Course,
        Score,
        ROW_NUMBER() OVER (
            PARTITION BY Course
            ORDER BY Score DESC
        ) AS rn
    FROM students
)
SELECT *
FROM ranked_students
WHERE rn <= 3;

-- Q49. Running fee collection
SELECT
    JoinDate,
    StudentID,
    Paid,
    SUM(Paid) OVER (
        ORDER BY JoinDate, StudentID
    ) AS Running_Collection
FROM students;

-- Q50. Course average alongside every student
SELECT
    StudentID,
    Name,
    Course,
    Score,
    ROUND(
        AVG(Score) OVER (PARTITION BY Course), 2
    ) AS Course_Avg
FROM students;

-- Q51. Difference from course average
SELECT
    StudentID,
    Name,
    Course,
    Score,
    ROUND(
        Score - AVG(Score) OVER (PARTITION BY Course), 2
    ) AS Difference_From_Course_Avg
FROM students;

-- Q52. LAG example: compare students by join date
SELECT
    StudentID,
    Name,
    JoinDate,
    Paid,
    LAG(Paid) OVER (
        ORDER BY JoinDate, StudentID
    ) AS Previous_Paid
FROM students;

-- =============================================================
-- SECTION 13: ADVANCED BATCH ANALYTICS
-- =============================================================

-- Q53. Batch capacity utilization
SELECT
    BatchID,
    Course,
    StudentsCount AS Capacity,
    AssignedStudentsCount,
    ROUND(
        100 * AssignedStudentsCount / NULLIF(StudentsCount,0), 2
    ) AS Utilization_Percent
FROM batch
ORDER BY Utilization_Percent DESC;

-- Q54. Under-utilized batches
SELECT
    BatchID,
    Course,
    StudentsCount,
    AssignedStudentsCount,
    CapacityGap
FROM batch
WHERE CapacityGap > 10
ORDER BY CapacityGap DESC;

-- Q55. Faculty performance summary
SELECT
    f.FacultyID,
    f.Name,
    COUNT(s.StudentID) AS Students,
    ROUND(AVG(s.Score),2) AS Avg_Student_Score,
    ROUND(AVG(s.AttendancePercent),2) AS Avg_Attendance,
    f.Feedback,
    f.ClassesTaken
FROM faculty f
LEFT JOIN students s
    ON f.FacultyID = s.FacultyID
GROUP BY
    f.FacultyID, f.Name, f.Feedback, f.ClassesTaken
ORDER BY Avg_Student_Score DESC;

-- =============================================================
-- SECTION 14: VIEWS
-- =============================================================

CREATE OR REPLACE VIEW vw_student_performance AS
SELECT
    s.StudentID,
    s.Name,
    s.Course,
    s.BatchID,
    f.Name AS FacultyName,
    s.AttendancePercent,
    s.Score,
    s.Status,
    s.PlacementStatus
FROM students s
LEFT JOIN faculty f
    ON s.FacultyID = f.FacultyID;

CREATE OR REPLACE VIEW vw_fee_analysis AS
SELECT
    StudentID,
    Name,
    Course,
    Fees,
    Paid,
    OutstandingFees,
    FeePaidPercent,
    FeeStatusDerived
FROM students;

CREATE OR REPLACE VIEW vw_batch_utilization AS
SELECT
    BatchID,
    Course,
    FacultyName,
    StudentsCount,
    AssignedStudentsCount,
    CapacityGap,
    ROUND(
        100 * AssignedStudentsCount / NULLIF(StudentsCount,0),2
    ) AS UtilizationPercent,
    Status
FROM batch;

-- Test views
SELECT * FROM vw_student_performance LIMIT 20;
SELECT * FROM vw_fee_analysis LIMIT 20;
SELECT * FROM vw_batch_utilization;

-- =============================================================
-- SECTION 15: STORED PROCEDURE
-- =============================================================

DELIMITER $$

CREATE PROCEDURE GetCoursePerformance(IN p_course VARCHAR(100))
BEGIN
    SELECT
        Course,
        COUNT(*) AS Students,
        ROUND(AVG(Score),2) AS Avg_Score,
        ROUND(AVG(AttendancePercent),2) AS Avg_Attendance,
        SUM(Fees) AS Total_Fees,
        SUM(Paid) AS Collected,
        SUM(OutstandingFees) AS Outstanding
    FROM students
    WHERE Course = p_course
    GROUP BY Course;
END $$

DELIMITER ;

-- Example:
-- CALL GetCoursePerformance('Power BI');

-- =============================================================
-- SECTION 16: TRANSACTION PRACTICE
-- =============================================================

START TRANSACTION;

-- Example update for practice only:
-- UPDATE students
-- SET Paid = Paid + 500
-- WHERE StudentID = 'S0001';

-- ROLLBACK;
-- Use COMMIT only after validating the update.

-- =============================================================
-- SECTION 17: QUERY OPTIMIZATION
-- =============================================================

-- Check query execution plan:
EXPLAIN
SELECT *
FROM students
WHERE CourseID = 'C01'
  AND Status = 'Active';

-- Existing indexes:
-- idx_student_course
-- idx_student_batch
-- idx_student_faculty
-- idx_student_join_date
-- idx_student_status

-- =============================================================
-- SECTION 18: DATA INSIGHTS
-- =============================================================


-- 1. Find the top 5 courses by revenue.
SELECT
    Course,
    SUM(Paid) AS TotalRevenue
FROM students
GROUP BY Course
ORDER BY TotalRevenue DESC
LIMIT 5;

-- 2. Find the top 3 students in every course.
SELECT CourseWise.*
FROM (
    SELECT
        s.Course,
        s.StudentID,
        s.Name,
        s.Score,
        RANK() OVER (PARTITION BY s.Course ORDER BY s.Score DESC) AS ScoreRank
    FROM students s
) AS CourseWise
WHERE ScoreRank <= 3
ORDER BY Course, ScoreRank;

-- 3. Calculate dropout percentage by course.
SELECT
    Course,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN Status = 'Dropped' THEN 1 ELSE 0 END) AS DroppedStudents,
    ROUND(
        SUM(CASE WHEN Status = 'Dropped' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS DropoutPercent
FROM students
GROUP BY Course
ORDER BY DropoutPercent DESC;

-- 4. Calculate placement rate by course.
SELECT
    Course,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN PlacementStatus = 'Placed' THEN 1 ELSE 0 END) AS PlacedStudents,
    ROUND(
        SUM(CASE WHEN PlacementStatus = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS PlacementRatePercent
FROM students
GROUP BY Course
ORDER BY PlacementRatePercent DESC;

-- 5. Find students whose attendance is below course average.
SELECT
    s.StudentID,
    s.Name,
    s.Course,
    s.AttendancePercent,
    ca.AvgAttendance
FROM students s
JOIN (
    SELECT Course, AVG(AttendancePercent) AS AvgAttendance
    FROM students
    GROUP BY Course
) ca ON s.Course = ca.Course
WHERE s.AttendancePercent < ca.AvgAttendance
ORDER BY s.Course, s.AttendancePercent;

-- 6. Find students whose score is above course average but attendance is below average.
SELECT
    s.StudentID,
    s.Name,
    s.Course,
    s.Score,
    ca.AvgScore,
    s.AttendancePercent,
    ca.AvgAttendance
FROM students s
JOIN (
    SELECT
        Course,
        AVG(Score) AS AvgScore,
        AVG(AttendancePercent) AS AvgAttendance
    FROM students
    GROUP BY Course
) ca ON s.Course = ca.Course
WHERE s.Score > ca.AvgScore
  AND s.AttendancePercent < ca.AvgAttendance
ORDER BY s.Course;

-- 7. Find the highest-fee student in every course.
SELECT CourseWise.*
FROM (
    SELECT
        s.Course,
        s.StudentID,
        s.Name,
        s.Fees,
        RANK() OVER (PARTITION BY s.Course ORDER BY s.Fees DESC) AS FeeRank
    FROM students s
) AS CourseWise
WHERE FeeRank = 1
ORDER BY Course;

-- 8. Find the second-highest scorer in each course.
SELECT CourseWise.*
FROM (
    SELECT
        s.Course,
        s.StudentID,
        s.Name,
        s.Score,
        DENSE_RANK() OVER (PARTITION BY s.Course ORDER BY s.Score DESC) AS ScoreRank
    FROM students s
) AS CourseWise
WHERE ScoreRank = 2
ORDER BY Course;

-- 9. Find the faculty with the highest average student score.
SELECT
    s.FacultyID,
    s.FacultyName,
    AVG(s.Score) AS AvgStudentScore
FROM students s
GROUP BY s.FacultyID, s.FacultyName
ORDER BY AvgStudentScore DESC
LIMIT 1;

-- 10. Find the faculty handling the largest number of students.
SELECT
    s.FacultyID,
    s.FacultyName,
    COUNT(*) AS TotalStudents
FROM students s
GROUP BY s.FacultyID, s.FacultyName
ORDER BY TotalStudents DESC
LIMIT 1;

-- 11. Find batches with utilization below 50%.
SELECT
    BatchID,
    Course,
    StudentsCount AS PlannedCapacity,
    AssignedStudentsCount,
    ROUND(AssignedStudentsCount * 100.0 / NULLIF(StudentsCount, 0), 2) AS UtilizationPercent
FROM batch
WHERE (AssignedStudentsCount * 100.0 / NULLIF(StudentsCount, 0)) < 50
ORDER BY UtilizationPercent;

-- 12. Find batches where assigned students exceed planned capacity.
SELECT
    BatchID,
    Course,
    StudentsCount AS PlannedCapacity,
    AssignedStudentsCount,
    (AssignedStudentsCount - StudentsCount) AS Overflow
FROM batch
WHERE AssignedStudentsCount > StudentsCount
ORDER BY Overflow DESC;

-- 13. Calculate month-wise fee collection.
SELECT
    DATE_FORMAT(STR_TO_DATE(JoinDate, '%Y-%m-%d'), '%Y-%m') AS JoinMonth,
    SUM(Paid) AS TotalFeeCollected
FROM students
GROUP BY JoinMonth
ORDER BY JoinMonth;

-- 14. Calculate running fee collection.
SELECT
    JoinMonth,
    TotalFeeCollected,
    SUM(TotalFeeCollected) OVER (ORDER BY JoinMonth) AS RunningTotal
FROM (
    SELECT
        DATE_FORMAT(STR_TO_DATE(JoinDate, '%Y-%m-%d'), '%Y-%m') AS JoinMonth,
        SUM(Paid) AS TotalFeeCollected
    FROM students
    GROUP BY JoinMonth
) monthly
ORDER BY JoinMonth;

-- 15. Find the month with the highest enrollment.
SELECT
    DATE_FORMAT(STR_TO_DATE(JoinDate, '%Y-%m-%d'), '%Y-%m') AS JoinMonth,
    COUNT(*) AS Enrollments
FROM students
GROUP BY JoinMonth
ORDER BY Enrollments DESC
LIMIT 1;

-- 16. Find the most effective admission source by enrollment.
SELECT
    AdmissionSource,
    COUNT(*) AS TotalEnrollments
FROM students
GROUP BY AdmissionSource
ORDER BY TotalEnrollments DESC
LIMIT 1;

-- 17. Compare placement rate across admission sources.
SELECT
    AdmissionSource,
    COUNT(*) AS TotalStudents,
    SUM(CASE WHEN PlacementStatus = 'Placed' THEN 1 ELSE 0 END) AS PlacedStudents,
    ROUND(
        SUM(CASE WHEN PlacementStatus = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS PlacementRatePercent
FROM students
GROUP BY AdmissionSource
ORDER BY PlacementRatePercent DESC;

-- 18. Find students with outstanding fees greater than 50% of total fees.
SELECT
    StudentID,
    Name,
    Course,
    Fees,
    Paid,
    OutstandingFees,
    ROUND(OutstandingFees * 100.0 / NULLIF(Fees, 0), 2) AS OutstandingPercent
FROM students
WHERE OutstandingFees > (Fees * 0.5)
ORDER BY OutstandingPercent DESC;

-- 19. Find courses with above-average revenue.
SELECT
    Course,
    TotalRevenue
FROM (
    SELECT
        Course,
        SUM(Paid) AS TotalRevenue
    FROM students
    GROUP BY Course
) course_rev
WHERE TotalRevenue > (
    SELECT AVG(CourseRevenue)
    FROM (
        SELECT SUM(Paid) AS CourseRevenue
        FROM students
        GROUP BY Course
    ) avg_rev
)
ORDER BY TotalRevenue DESC;

-- 20. Find students who scored higher than every student in a selected course.
SELECT
    StudentID,
    Name,
    Course,
    Score
FROM students
WHERE Score > (
    SELECT MAX(Score)
    FROM students
    WHERE Course = 'Data Science'   -- <-- change to the course you're comparing against
)
ORDER BY Score DESC;

-- 21. Find courses whose average score is above the overall average.
SELECT
    Course,
    AVG(Score) AS CourseAvgScore
FROM students
GROUP BY Course
HAVING AVG(Score) > (SELECT AVG(Score) FROM students)
ORDER BY CourseAvgScore DESC;

-- 22. Find faculty-wise average attendance and score.
SELECT 
	FacultyID,
	FacultyName,
    ROUND(AVG(AttendancePercent),2) AS AvgStudentAttendence,
    ROUND(AVG(Score), 2) AS AvgStudentScore
FROM students
GROUP BY FacultyID, FacultyName
ORDER BY AvgStudentScore DESC;

-- 23. Find the difference between faculty average score and overall score.
SELECT 
	FacultyID,
	FacultyName,
	ROUND(AVG(Score), 2) AS FacultyAvgScore,
    ROUND((SELECT AVG(Score) FROM students), 2) AS OverallAvgScore,
    ROUND(AVG(Score) - (SELECT AVG(Score) FROM students), 2) AS ScoreDifference
FROM students
GROUP BY FacultyID, FacultyName
ORDER BY ScoreDifference DESC;
    
-- 24. Find each student's rank within their course.
SELECT
	StudentID,
	Name,
    Course,
    Score,
    RANK() OVER (PARTITION BY Course ORDER BY Score DESC) AS CourseRank
    FROM students
	ORDER BY Course, CourseRank;
    
-- 25. Find the percentage contribution of each course to total revenue.
SELECT 
	Course,
    SUM(Paid) AS TotalRevenue,
    ROUND(SUM(Paid) * 100.0 / (SELECT SUM(Paid) FROM students), 2) AS RevenueContribution
FROM students
GROUP BY Course WITH ROLLUP
ORDER BY RevenueContribution DESC;

-- 26. Find the top revenue-generating city.
SELECT 
	City,
    SUM(Paid) AS TotalRevenue
FROM students 
GROUP BY City
ORDER BY TotalRevenue DESC
LIMIT 1;
    
-- 27. Find cities with more than 20 students.
SELECT
    City,
    COUNT(*) AS TotalStudents
FROM students
GROUP BY City
HAVING COUNT(*) > 20
ORDER BY TotalStudents DESC;
    
-- 28. Find students who joined in the highest enrollment month.
SELECT
    StudentID,
    Name,
    Course,
    JoinDate
FROM students
WHERE DATE_FORMAT(STR_TO_DATE(JoinDate, '%Y-%m-%d'), '%Y-%m') = ( SELECT JoinMonth
    FROM (
        SELECT
            DATE_FORMAT(STR_TO_DATE(JoinDate, '%Y-%m-%d'), '%Y-%m') AS JoinMonth,
            COUNT(*) AS Enrollments
        FROM students
        GROUP BY JoinMonth
        ORDER BY Enrollments DESC
        LIMIT 1
    ) top_month
)
ORDER BY JoinDate;

-- 29. Find the longest-duration batch for every course.
SELECT CourseWise.*
FROM (
    SELECT
        b.Course,
        b.BatchID,
        b.StartDate,
        b.EndDate,
        DATEDIFF(STR_TO_DATE(b.EndDate, '%Y-%m-%d'), STR_TO_DATE(b.StartDate, '%Y-%m-%d')) AS DurationDays,
        RANK() OVER (
            PARTITION BY b.Course
            ORDER BY DATEDIFF(STR_TO_DATE(b.EndDate, '%Y-%m-%d'), STR_TO_DATE(b.StartDate, '%Y-%m-%d')) DESC
        ) AS DurationRank
    FROM batch b
) AS CourseWise
WHERE DurationRank = 1
ORDER BY Course;
    
-- 30. Find courses with more than one active/running batch.
SELECT
    Course,
    COUNT(*) AS RunningBatches
FROM batch
WHERE Status = 'Running'      
GROUP BY Course
HAVING COUNT(*) > 1
ORDER BY RunningBatches DESC;

-- 31. Find faculty members who have students in more than 3 courses.
SELECT
    FacultyID,
    FacultyName,
    COUNT(DISTINCT Course) AS CoursesTaught
FROM students
GROUP BY FacultyID, FacultyName
HAVING COUNT(DISTINCT Course) > 3
ORDER BY CoursesTaught DESC;

-- 32. Find students with 100% fee payment but low attendance.
SELECT
    StudentID,
    Name,
    Course,
    FeePaidPercent,
    AttendancePercent
FROM students
WHERE FeePaidPercent = 100
  AND AttendancePercent < 75
ORDER BY AttendancePercent;

-- 33. Find high-scoring students who are not placed.
SELECT
    StudentID,
    Name,
    Course,
    Score,
    PlacementStatus
FROM students
WHERE Score > (SELECT AVG(Score) FROM students)
  AND PlacementStatus != 'Placed'
ORDER BY Score DESC;

-- 34. Find students with high attendance but low score.
SELECT
    StudentID,
    Name,
    Course,
    AttendancePercent,
    Score
FROM students
WHERE AttendancePercent >= 85
  AND Score < (SELECT AVG(Score) FROM students)
ORDER BY AttendancePercent DESC;

-- 35. Build a risk category using attendance, score, fee and status.
SELECT
    StudentID,
    Name,
    Course,
    AttendancePercent,
    Score,
    FeeStatus,
    Status,
    CASE
        WHEN Status = 'Dropped' THEN 'High Risk - Dropped'
        WHEN AttendancePercent < 60 AND Score < 50 THEN 'High Risk'
        WHEN AttendancePercent < 75 OR Score < 60 OR OutstandingFees > (Fees * 0.5) THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS RiskCategory
FROM students
ORDER BY
    CASE
        WHEN Status = 'Dropped' THEN 1
        WHEN AttendancePercent < 60 AND Score < 50 THEN 2
        WHEN AttendancePercent < 75 OR Score < 60 OR OutstandingFees > (Fees * 0.5) THEN 3
        ELSE 4
    END;
    
-- 36. Build a student performance leaderboard.
SELECT
    StudentID,
    Name,
    Course,
    Score,
    AttendancePercent,
    RANK() OVER (ORDER BY Score DESC, AttendancePercent DESC) AS OverallRank
FROM students
ORDER BY OverallRank;

-- 37. Build a fee collection leaderboard.
SELECT
    Course,
    SUM(Paid) AS TotalCollected,
    RANK() OVER (ORDER BY SUM(Paid) DESC) AS CollectionRank
FROM students
GROUP BY Course
ORDER BY CollectionRank;

-- 38. Build a batch utilization leaderboard.
SELECT
    BatchID,
    Course,
    StudentsCount AS PlannedCapacity,
    AssignedStudentsCount,
    ROUND(AssignedStudentsCount * 100.0 / NULLIF(StudentsCount, 0), 2) AS UtilizationPercent,
    RANK() OVER (ORDER BY (AssignedStudentsCount * 100.0 / NULLIF(StudentsCount, 0)) DESC) AS UtilizationRank
FROM batch
ORDER BY UtilizationRank;

-- 39. Create a management summary using multiple CTEs.
SELECT
    BatchID,
    Course,
    StudentsCount AS PlannedCapacity,
    AssignedStudentsCount,
    ROUND(AssignedStudentsCount * 100.0 / NULLIF(StudentsCount, 0), 2) AS UtilizationPercent,
    RANK() OVER (ORDER BY (AssignedStudentsCount * 100.0 / NULLIF(StudentsCount, 0)) DESC) AS UtilizationRank
FROM batch
ORDER BY UtilizationRank;
 
 
-- =====================================================================
-- 39. Management summary using multiple CTEs
-- =====================================================================
WITH course_revenue AS (
    SELECT Course, SUM(Paid) AS TotalRevenue
    FROM students
    GROUP BY Course
),
course_dropout AS (
    SELECT
        Course,
        ROUND(SUM(CASE WHEN Status = 'Dropped' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS DropoutPercent
    FROM students
    GROUP BY Course
),
course_placement AS (
    SELECT
        Course,
        ROUND(SUM(CASE WHEN PlacementStatus = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS PlacementPercent
    FROM students
    GROUP BY Course
),
course_avg_score AS (
    SELECT Course, ROUND(AVG(Score), 2) AS AvgScore
    FROM students
    GROUP BY Course
),
course_avg_attendance AS (
    SELECT Course, ROUND(AVG(AttendancePercent), 2) AS AvgAttendance
    FROM students
    GROUP BY Course
)
SELECT
    r.Course,
    r.TotalRevenue,
    d.DropoutPercent,
    p.PlacementPercent,
    sc.AvgScore,
    att.AvgAttendance
FROM course_revenue r
JOIN course_dropout d ON r.Course = d.Course
JOIN course_placement p ON r.Course = p.Course
JOIN course_avg_score sc ON r.Course = sc.Course
JOIN course_avg_attendance att ON r.Course = att.Course
ORDER BY r.TotalRevenue DESC;

-- 40. Create a final executive SQL report combining students, batches and faculty.
WITH student_summary AS (
    SELECT
        Course,
        COUNT(*) AS TotalStudents,
        SUM(Paid) AS TotalRevenue,
        SUM(OutstandingFees) AS TotalOutstanding,
        ROUND(AVG(Score), 2) AS AvgScore,
        ROUND(AVG(AttendancePercent), 2) AS AvgAttendance,
        ROUND(SUM(CASE WHEN Status = 'Dropped' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS DropoutPercent,
        ROUND(SUM(CASE WHEN PlacementStatus = 'Placed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS PlacementPercent
    FROM students
    GROUP BY Course
),
batch_summary AS (
    SELECT
        Course,
        COUNT(*) AS TotalBatches,
        SUM(AssignedStudentsCount) AS TotalAssigned,
        SUM(StudentsCount) AS TotalCapacity,
        ROUND(SUM(AssignedStudentsCount) * 100.0 / NULLIF(SUM(StudentsCount), 0), 2) AS AvgUtilizationPercent
    FROM batch
    GROUP BY Course
),
faculty_summary AS (
    SELECT
        s.Course,
        COUNT(DISTINCT s.FacultyID) AS TotalFaculty,
        ROUND(AVG(f.Salary), 2) AS AvgFacultySalary
    FROM students s
    LEFT JOIN faculty f ON s.FacultyID = f.FacultyID
    GROUP BY s.Course
)
SELECT
    ss.Course,
    ss.TotalStudents,
    ss.TotalRevenue,
    ss.TotalOutstanding,
    ss.AvgScore,
    ss.AvgAttendance,
    ss.DropoutPercent,
    ss.PlacementPercent,
    bs.TotalBatches,
    bs.AvgUtilizationPercent,
    fs.TotalFaculty,
    fs.AvgFacultySalary
FROM student_summary ss
LEFT JOIN batch_summary bs ON ss.Course = bs.Course
LEFT JOIN faculty_summary fs ON ss.Course = fs.Course
ORDER BY ss.TotalRevenue DESC;
 


