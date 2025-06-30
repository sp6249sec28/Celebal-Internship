CREATE TABLE Projects (
    Task_ID INT PRIMARY KEY,
    Start_Date DATE,
    End_Date DATE
);
INSERT INTO Projects VALUES (1, DATE '2015-10-01', DATE '2015-10-02');
INSERT INTO Projects VALUES (2, DATE '2015-10-02', DATE '2015-10-03');
INSERT INTO Projects VALUES (3, DATE '2015-10-03', DATE '2015-10-04');
INSERT INTO Projects VALUES (4, DATE '2015-10-13', DATE '2015-10-14');
INSERT INTO Projects VALUES (5, DATE '2015-10-14', DATE '2015-10-15');
INSERT INTO Projects VALUES (6, DATE '2015-10-28', DATE '2015-10-29');
INSERT INTO Projects VALUES (7, DATE '2015-10-30', DATE '2015-10-31');
SELECT Start_Date, End_Date
FROM Projects
GROUP BY Start_Date, End_Date
HAVING COUNT(*) = (
    SELECT MAX(project_count)
    FROM (
        SELECT COUNT(*) AS project_count
        FROM Projects
        GROUP BY Start_Date, End_Date
    )
)
ORDER BY End_Date - Start_Date, Start_Date;

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Friends';
  EXECUTE IMMEDIATE 'DROP TABLE Packages';
  EXECUTE IMMEDIATE 'DROP TABLE Students';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE Students (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(255)
);

CREATE TABLE Friends (
    ID NUMBER,
    Friend_ID NUMBER,
    PRIMARY KEY (ID, Friend_ID)
);

CREATE TABLE Packages (
    ID NUMBER PRIMARY KEY,
    Salary NUMBER(10, 2)
);


INSERT INTO Students VALUES (1, 'Ashley');
INSERT INTO Students VALUES (2, 'Samantha');
INSERT INTO Students VALUES (3, 'Julia');
INSERT INTO Students VALUES (4, 'Scarlet');

INSERT INTO Friends VALUES (1, 2);
INSERT INTO Friends VALUES (2, 3);
INSERT INTO Friends VALUES (3, 4);
INSERT INTO Friends VALUES (4, 1);

INSERT INTO Packages VALUES (1, 15.20);
INSERT INTO Packages VALUES (2, 10.06);
INSERT INTO Packages VALUES (3, 11.55);
INSERT INTO Packages VALUES (4, 12.12);

SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages p1 ON s.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Functions';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE Functions (
    X NUMBER,
    Y NUMBER
);

INSERT INTO Functions VALUES (20, 20);
INSERT INTO Functions VALUES (20, 21);
INSERT INTO Functions VALUES (20, 20);
INSERT INTO Functions VALUES (20, 22);
INSERT INTO Functions VALUES (23, 22);
INSERT INTO Functions VALUES (22, 23);
INSERT INTO Functions VALUES (21, 20);

SELECT DISTINCT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y
ORDER BY f1.X, f1.Y;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Submission_Stats';
  EXECUTE IMMEDIATE 'DROP TABLE View_Stats';
  EXECUTE IMMEDIATE 'DROP TABLE Challenges';
  EXECUTE IMMEDIATE 'DROP TABLE Colleges';
  EXECUTE IMMEDIATE 'DROP TABLE Contests';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE Contests (
    contest_id NUMBER PRIMARY KEY,
    hacker_id NUMBER,
    name VARCHAR2(255)
);

CREATE TABLE Colleges (
    college_id NUMBER PRIMARY KEY,
    contest_id NUMBER
);

CREATE TABLE Challenges (
    challenge_id NUMBER PRIMARY KEY,
    college_id NUMBER
);

CREATE TABLE View_Stats (
    challenge_id NUMBER PRIMARY KEY,
    total_views NUMBER,
    total_unique_views NUMBER
);

CREATE TABLE Submission_Stats (
    challenge_id NUMBER PRIMARY KEY,
    total_submissions NUMBER,
    total_accepted_submissions NUMBER
);


INSERT INTO Contests VALUES (66406, 17973, 'Rose');
INSERT INTO Contests VALUES (66556, 78153, 'Angela');
INSERT INTO Contests VALUES (94828, 80275, 'Frank');

INSERT INTO Colleges VALUES (10765, 11219); -- NOTE: 11219 is not in Contests
INSERT INTO Colleges VALUES (11219, 66406);
INSERT INTO Colleges VALUES (32473, 66556);
INSERT INTO Colleges VALUES (56685, 94828);

INSERT INTO Challenges VALUES (471127, 11219);
INSERT INTO Challenges VALUES (47127, 11219);
INSERT INTO Challenges VALUES (60292, 32473);
INSERT INTO Challenges VALUES (72974, 56685);

INSERT INTO View_Stats VALUES (471127, 28, 19);
INSERT INTO View_Stats VALUES (47127, 15, 14);
INSERT INTO View_Stats VALUES (10765, 72, 13);
INSERT INTO View_Stats VALUES (75516, 35, 17);
INSERT INTO View_Stats VALUES (60292, 11, 10);
INSERT INTO View_Stats VALUES (72974, 41, 15);



INSERT INTO Submission_Stats VALUES (75516, 34, 12);
INSERT INTO Submission_Stats VALUES (47127, 56, 18);


SELECT
    c.contest_id,
    c.hacker_id,
    c.name,
    SUM(NVL(ss.total_submissions, 0)) AS total_submissions,
    SUM(NVL(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(NVL(vs.total_views, 0)) AS total_views,
    SUM(NVL(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests c
LEFT JOIN Colleges col ON c.contest_id = col.contest_id
LEFT JOIN Challenges ch ON col.college_id = ch.college_id
LEFT JOIN View_Stats vs ON ch.challenge_id = vs.challenge_id
LEFT JOIN Submission_Stats ss ON ch.challenge_id = ss.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING
    SUM(NVL(ss.total_submissions, 0)) +
    SUM(NVL(ss.total_accepted_submissions, 0)) +
    SUM(NVL(vs.total_views, 0)) +
    SUM(NVL(vs.total_unique_views, 0)) > 0
ORDER BY c.contest_id;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Submissions';
  EXECUTE IMMEDIATE 'DROP TABLE Hackers';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;


CREATE TABLE Hackers (
    hacker_id NUMBER PRIMARY KEY,
    name VARCHAR2(255)
);

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id NUMBER PRIMARY KEY,
    hacker_id NUMBER,
    score NUMBER
);


INSERT INTO Hackers VALUES (15758, 'Rose');
INSERT INTO Hackers VALUES (20703, 'Angela');
INSERT INTO Hackers VALUES (36596, 'Frank');
INSERT INTO Hackers VALUES (38289, 'Patrick');
INSERT INTO Hackers VALUES (44065, 'Lisa');
INSERT INTO Hackers VALUES (53473, 'Kimberly');
INSERT INTO Hackers VALUES (62529, 'Bonnie');
INSERT INTO Hackers VALUES (79722, 'Michael');

INSERT INTO Submissions VALUES (DATE '2016-03-01', 8484, 20703, 0);
INSERT INTO Submissions VALUES (DATE '2016-03-01', 22403, 53473, 15);
INSERT INTO Submissions VALUES (DATE '2016-03-01', 23965, 79722, 60);
INSERT INTO Submissions VALUES (DATE '2016-03-01', 30173, 36596, 70);

INSERT INTO Submissions VALUES (DATE '2016-03-02', 34928, 20703, 0);
INSERT INTO Submissions VALUES (DATE '2016-03-02', 38740, 15758, 60);
INSERT INTO Submissions VALUES (DATE '2016-03-02', 48769, 79722, 25);
INSERT INTO Submissions VALUES (DATE '2016-03-02', 44364, 79722, 60);

INSERT INTO Submissions VALUES (DATE '2016-03-03', 45410, 20703, 0);
INSERT INTO Submissions VALUES (DATE '2016-03-03', 46050, 36596, 70);
INSERT INTO Submissions VALUES (DATE '2016-03-03', 50273, 79722, 5);

INSERT INTO Submissions VALUES (DATE '2016-03-04', 50344, 20703, 0);
INSERT INTO Submissions VALUES (DATE '2016-03-04', 51360, 44065, 90);
INSERT INTO Submissions VALUES (DATE '2016-03-04', 54404, 53473, 65);
INSERT INTO Submissions VALUES (DATE '2016-03-04', 61533, 79722, 45);

INSERT INTO Submissions VALUES (DATE '2016-03-05', 72852, 20703, 0);
INSERT INTO Submissions VALUES (DATE '2016-03-05', 74546, 38289, 0);
INSERT INTO Submissions VALUES (DATE '2016-03-05', 76487, 62529, 0);

INSERT INTO Submissions VALUES (DATE '2016-03-06', 82439, 36596, 10);
INSERT INTO Submissions VALUES (DATE '2016-03-06', 90006, 36596, 40);
INSERT INTO Submissions VALUES (DATE '2016-03-06', 90404, 20703, 0);




WITH DailySubmissionCounts AS (
    SELECT
        submission_date,
        hacker_id,
        COUNT(submission_id) AS daily_submissions
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
MaxDailySubmissions AS (
    SELECT
        submission_date,
        MAX(daily_submissions) AS max_submissions
    FROM DailySubmissionCounts
    GROUP BY submission_date
),
RankedHackers AS (
    SELECT
        dsc.submission_date,
        dsc.hacker_id,
        h.name,
        dsc.daily_submissions,
        ROW_NUMBER() OVER (
            PARTITION BY dsc.submission_date ORDER BY dsc.hacker_id
        ) AS rn
    FROM DailySubmissionCounts dsc
    JOIN Hackers h ON dsc.hacker_id = h.hacker_id
    JOIN MaxDailySubmissions mds
        ON dsc.submission_date = mds.submission_date
       AND dsc.daily_submissions = mds.max_submissions
)
SELECT submission_date, hacker_id, name
FROM RankedHackers
WHERE rn = 1
ORDER BY submission_date;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE STATION';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE STATION (
    ID NUMBER PRIMARY KEY,
    CITY VARCHAR2(21),
    STATE VARCHAR2(2),
    LAT_N NUMBER(10, 4),
    LONG_W NUMBER(10, 4)
);
INSERT INTO STATION VALUES (1, 'New York', 'NY', 40.7128, 74.0060);
INSERT INTO STATION VALUES (2, 'Los Angeles', 'CA', 34.0522, 118.2437);
INSERT INTO STATION VALUES (3, 'Chicago', 'IL', 41.8781, 87.6298);
INSERT INTO STATION VALUES (4, 'Houston', 'TX', 29.7604, 95.3698);
SELECT ROUND(
    ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W)),
    4
) AS manhattan_distance
FROM STATION;


WITH Numbers AS (
    SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 1000
)
SELECT LISTAGG(n, '&') WITHIN GROUP (ORDER BY n) AS prime_numbers
FROM (
    SELECT n FROM Numbers p
    WHERE n >= 2 AND NOT EXISTS (
        SELECT 1 FROM Numbers d
        WHERE d.n BETWEEN 2 AND FLOOR(SQRT(p.n))
          AND MOD(p.n, d.n) = 0
    )
);



BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE OCCUPATIONS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE OCCUPATIONS (
    Name VARCHAR2(255),
    Occupation VARCHAR2(255)
);
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Samantha', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Julia', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Maria', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Meera', 'Singer');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ashely', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ketty', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Christeen', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jane', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jenny', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Priya', 'Singer');

SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM (
    SELECT Name, Occupation,
           ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
)
GROUP BY rn
ORDER BY rn;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE BST';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE BST (
    N NUMBER PRIMARY KEY,
    P NUMBER
);
INSERT INTO BST (N, P) VALUES (1, 2);
INSERT INTO BST (N, P) VALUES (3, 2);
INSERT INTO BST (N, P) VALUES (6, 8);
INSERT INTO BST (N, P) VALUES (9, 8);
INSERT INTO BST (N, P) VALUES (2, 5);
INSERT INTO BST (N, P) VALUES (8, 5);
INSERT INTO BST (N, P) VALUES (5, NULL);

SELECT
    N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N IN (SELECT P FROM BST WHERE P IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS Node_Type
FROM BST
ORDER BY N;


BEGIN EXECUTE IMMEDIATE 'DROP TABLE Employee'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Manager'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Senior_Manager'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Lead_Manager'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Company'; EXCEPTION WHEN OTHERS THEN NULL; END;
/


CREATE TABLE Company (
    company_code VARCHAR2(10) PRIMARY KEY,
    founder VARCHAR2(255)
);

CREATE TABLE Lead_Manager (
    lead_manager_code VARCHAR2(10) PRIMARY KEY,
    company_code VARCHAR2(10),
    FOREIGN KEY (company_code) REFERENCES Company(company_code)
);

CREATE TABLE Senior_Manager (
    senior_manager_code VARCHAR2(10) PRIMARY KEY,
    lead_manager_code VARCHAR2(10),
    company_code VARCHAR2(10),
    FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
    FOREIGN KEY (company_code) REFERENCES Company(company_code)
);

CREATE TABLE Manager (
    manager_code VARCHAR2(10) PRIMARY KEY,
    senior_manager_code VARCHAR2(10),
    lead_manager_code VARCHAR2(10),
    company_code VARCHAR2(10),
    FOREIGN KEY (senior_manager_code) REFERENCES Senior_Manager(senior_manager_code),
    FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
    FOREIGN KEY (company_code) REFERENCES Company(company_code)
);

CREATE TABLE Employee (
    employee_code VARCHAR2(10) PRIMARY KEY,
    manager_code VARCHAR2(10),
    senior_manager_code VARCHAR2(10),
    lead_manager_code VARCHAR2(10),
    company_code VARCHAR2(10),
    FOREIGN KEY (manager_code) REFERENCES Manager(manager_code),
    FOREIGN KEY (senior_manager_code) REFERENCES Senior_Manager(senior_manager_code),
    FOREIGN KEY (lead_manager_code) REFERENCES Lead_Manager(lead_manager_code),
    FOREIGN KEY (company_code) REFERENCES Company(company_code)
);


INSERT INTO Company (company_code, founder) VALUES ('C1', 'Monika');
INSERT INTO Company (company_code, founder) VALUES ('C2', 'Samantha');

INSERT INTO Lead_Manager (lead_manager_code, company_code) VALUES ('LM1', 'C1');
INSERT INTO Lead_Manager (lead_manager_code, company_code) VALUES ('LM2', 'C2');



INSERT INTO Senior_Manager (senior_manager_code, lead_manager_code, company_code) VALUES 
('SM1', 'LM1', 'C1');

INSERT INTO Senior_Manager (senior_manager_code, lead_manager_code, company_code) VALUES 
('SM2', 'LM1', 'C1');

INSERT INTO Senior_Manager (senior_manager_code, lead_manager_code, company_code) VALUES 
('SM3', 'LM2', 'C2');

INSERT INTO Manager (manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('M1', 'SM1', 'LM1', 'C1');

INSERT INTO Manager (manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('M2', 'SM3', 'LM2', 'C2');

INSERT INTO Manager (manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('M3', 'SM3', 'LM2', 'C2');

INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('E1', 'M1', 'SM1', 'LM1', 'C1');

INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('E2', 'M1', 'SM1', 'LM1', 'C1');

INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('E3', 'M2', 'SM3', 'LM2', 'C2');

INSERT INTO Employee (employee_code, manager_code, senior_manager_code, lead_manager_code, company_code) VALUES 
('E4', 'M3', 'SM3', 'LM2', 'C2');


SELECT
    c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code) AS total_lead_managers,
    COUNT(DISTINCT sm.senior_manager_code) AS total_senior_managers,
    COUNT(DISTINCT m.manager_code) AS total_managers,
    COUNT(DISTINCT e.employee_code) AS total_employees
FROM Company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code
LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Manager m ON c.company_code = m.company_code
LEFT JOIN Employee e ON c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;

IF OBJECT_ID('BU_Financials', 'U') IS NOT NULL
    DROP TABLE BU_Financials;

CREATE TABLE BU_Financials (
    BU_ID INT,
    Financial_Month DATE,
    Cost DECIMAL(18, 2),
    Revenue DECIMAL(18, 2)
);
INSERT INTO BU_Financials (BU_ID, Financial_Month, Cost, Revenue) VALUES(101, '2024-01-01', 1000.00, 1500.00);
INSERT INTO BU_Financials (BU_ID, Financial_Month, Cost, Revenue) VALUES(101, '2024-02-01', 1200.00, 2000.00);
INSERT INTO BU_Financials (BU_ID, Financial_Month, Cost, Revenue) VALUES(102, '2024-02-01', 600.00, 0.00);
INSERT INTO BU_Financials (BU_ID, Financial_Month, Cost, Revenue) VALUES(102, '2024-02-01', 600.00, 0.00);
SELECT
    BU_ID,
    Financial_Month,
    CASE WHEN Revenue > 0 THEN ROUND(Cost / Revenue, 2)
         ELSE NULL
    END AS Cost_to_Revenue_Ratio
FROM BU_Financials
ORDER BY BU_ID, Financial_Month;


CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Sub_Band VARCHAR(50)
);


INSERT INTO Employees (Employee_ID, Sub_Band) VALUES(1, 'Junior'), (2, 'Senior'), (3, 'Junior'), (4, 'Lead');
INSERT INTO Employees (Employee_ID, Sub_Band) VALUES(5, 'Junior'), (6, 'Senior'), (7, 'Lead'), (8, 'Associate');


SELECT
    Sub_Band,
    COUNT(*) AS Headcount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees), 2) AS Percentage_Headcount
FROM Employees
GROUP BY Sub_Band
ORDER BY Sub_Band;

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Employees_Salary';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE Employees_Salary (
    Employee_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(255),
    Salary NUMBER(10, 2)
);

INSERT INTO Employees_Salary VALUES (1, 'Alice', 70000.00);
INSERT INTO Employees_Salary VALUES (2, 'Bob', 90000.00);
INSERT INTO Employees_Salary VALUES (3, 'Charlie', 60000.00);
INSERT INTO Employees_Salary VALUES (4, 'David', 100000.00);
INSERT INTO Employees_Salary VALUES (5, 'Eve', 80000.00);
INSERT INTO Employees_Salary VALUES (6, 'Frank', 110000.00);
INSERT INTO Employees_Salary VALUES (7, 'Grace', 75000.00);

SELECT * FROM (
    SELECT Employee_ID, Name, Salary
    FROM Employees_Salary
    ORDER BY Salary DESC
) WHERE ROWNUM <= 5;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE MyTable';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE MyTable (
    ID NUMBER PRIMARY KEY,
    ColA NUMBER,
    ColB NUMBER
);

INSERT INTO MyTable VALUES (1, 10, 20);
INSERT INTO MyTable VALUES (2, 5, 15);

UPDATE MyTable
SET
    ColA = ColA + ColB,
    ColB = ColA - ColB,
    ColA = ColA - ColB;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE Employee_Costs';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE Employee_Costs (
    Employee_ID NUMBER,
    BU_ID NUMBER,
    Cost_Month DATE,
    Cost NUMBER(10, 2),
    PRIMARY KEY (Employee_ID, BU_ID, Cost_Month)
);

INSERT INTO Employee_Costs VALUES (1, 101, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 5000.00);
INSERT INTO Employee_Costs VALUES (2, 101, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 6000.00);
INSERT INTO Employee_Costs VALUES (3, 101, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 5500.00);
INSERT INTO Employee_Costs VALUES (4, 102, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 7000.00);
INSERT INTO Employee_Costs VALUES (5, 102, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 8000.00);
INSERT INTO Employee_Costs VALUES (6, 102, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 7500.00);
INSERT INTO Employee_Costs VALUES (7, 103, TO_DATE('2024-01-01', 'YYYY-MM-DD'), 4000.00);

SELECT
    BU_ID,
    Cost_Month,
    SUM(Cost) AS Total_Cost,
    COUNT(DISTINCT Employee_ID) AS Total_Employees,
    ROUND(SUM(Cost) / COUNT(DISTINCT Employee_ID), 2) AS Weighted_Average_Cost
FROM Employee_Costs
GROUP BY BU_ID, Cost_Month
ORDER BY BU_ID, Cost_Month;

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEES_SALARY_CALC';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE EMPLOYEES_SALARY_CALC (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(255),
    salary NUMBER(10, 2),
    hire_date DATE
);

INSERT INTO EMPLOYEES_SALARY_CALC VALUES (1, 'John Doe', 5000.00, TO_DATE('2023-01-15','YYYY-MM-DD'));
INSERT INTO EMPLOYEES_SALARY_CALC VALUES (2, 'Jane Smith', 7500.00, TO_DATE('2023-02-20','YYYY-MM-DD'));
INSERT INTO EMPLOYEES_SALARY_CALC VALUES (3, 'Peter Jones', 0.00, TO_DATE('2023-03-10','YYYY-MM-DD'));
INSERT INTO EMPLOYEES_SALARY_CALC VALUES (4, 'Mary Brown', 6000.00, TO_DATE('2023-04-05','YYYY-MM-DD'));
INSERT INTO EMPLOYEES_SALARY_CALC VALUES (5, 'David Lee', 0.00, TO_DATE('2023-05-01','YYYY-MM-DD'));

SELECT
    CEIL(
        ABS(
            (SELECT AVG(salary) FROM EMPLOYEES_SALARY_CALC WHERE salary > 0) -
            (SELECT AVG(salary) FROM EMPLOYEES_SALARY_CALC)
        )
    ) AS Error_Rounded_Up
FROM dual;


BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE DestinationTable';
  EXECUTE IMMEDIATE 'DROP TABLE SourceTable';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE SourceTable (
    col1 NUMBER,
    col2 VARCHAR2(255)
);

CREATE TABLE DestinationTable (
    col1 NUMBER,
    col2 VARCHAR2(255),
    indicator VARCHAR2(10)
);


INSERT INTO SourceTable (col1, col2) VALUES (1, 'Alpha');
INSERT INTO SourceTable (col1, col2) VALUES (2, 'Beta');
INSERT INTO SourceTable (col1, col2) VALUES (3, 'Gamma');

INSERT INTO DestinationTable (col1, col2, indicator)
SELECT col1, col2, 'OLD'
FROM SourceTable;


INSERT INTO SourceTable (col1, col2) VALUES (4, 'Delta');
INSERT INTO SourceTable (col1, col2) VALUES (5, 'Epsilon');

INSERT INTO DestinationTable (col1, col2, indicator)
SELECT s.col1, s.col2, 'NEW'
FROM SourceTable s
WHERE NOT EXISTS (
    SELECT 1 FROM DestinationTable d WHERE d.col1 = s.col1
);







