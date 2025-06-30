CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(20) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);

CREATE TABLE StudentDetails (
    StudentId VARCHAR(20) PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA DECIMAL(3,1),
    Branch VARCHAR(20),
    Section VARCHAR(5)
);

CREATE TABLE StudentPreference (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Preference INT,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

CREATE TABLE Allotments (
    SubjectId VARCHAR(20),
    StudentId VARCHAR(20),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

CREATE TABLE UnallotedStudents (
    StudentId VARCHAR(20),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);


-- SubjectDetails
INSERT INTO SubjectDetails VALUES
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);

-- StudentDetails
INSERT INTO StudentDetails VALUES
('159103036', 'Mohit Agarwal', 8.9, 'CCE', 'A'),
('159103037', 'Rohit Agarwal', 5.2, 'CCE', 'A'),
('159103038', 'Shohit Garg', 7.1, 'CCE', 'B'),
('159103039', 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
('159103040', 'Mehreet Singh', 5.6, 'CCE', 'A'),
('159103041', 'Arjun Tehlan', 9.2, 'CCE', 'B');

-- StudentPreference
INSERT INTO StudentPreference VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 2),
('159103036', 'PO1493', 3),
('159103036', 'PO1494', 4),
('159103036', 'PO1495', 5),

('159103037', 'PO1492', 1),
('159103037', 'PO1493', 2),
('159103037', 'PO1494', 3),
('159103037', 'PO1495', 4),
('159103037', 'PO1491', 5),

('159103038', 'PO1493', 1),
('159103038', 'PO1491', 2),
('159103038', 'PO1494', 3),
('159103038', 'PO1492', 4),
('159103038', 'PO1495', 5),

('159103039', 'PO1491', 1),
('159103039', 'PO1492', 2),
('159103039', 'PO1495', 3),
('159103039', 'PO1494', 4),
('159103039', 'PO1493', 5),

('159103040', 'PO1495', 1),
('159103040', 'PO1493', 2),
('159103040', 'PO1494', 3),
('159103040', 'PO1492', 4),
('159103040', 'PO1491', 5),

('159103041', 'PO1491', 1),
('159103041', 'PO1492', 2),
('159103041', 'PO1493', 3),
('159103041', 'PO1494', 4),
('159103041', 'PO1495', 5);

GO
CREATE PROCEDURE AllotSubjects
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentId VARCHAR(20);
    DECLARE @SubjectId VARCHAR(20);
    DECLARE @Preference INT;
    DECLARE @RemainingSeats INT;
    DECLARE @Allotted BIT;

    IF OBJECT_ID('tempdb..#TempPreferences') IS NOT NULL DROP TABLE #TempPreferences;

    SELECT * INTO #TempPreferences FROM StudentPreference;

    DECLARE student_cursor CURSOR FOR
        SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    OPEN student_cursor;

    FETCH NEXT FROM student_cursor INTO @StudentId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Allotted = 0;
        SET @Preference = 1;

        WHILE @Preference <= 5 AND @Allotted = 0
        BEGIN
            SELECT @SubjectId = SubjectId
            FROM #TempPreferences
            WHERE StudentId = @StudentId AND Preference = @Preference;

            IF @SubjectId IS NOT NULL
            BEGIN
                SELECT @RemainingSeats = RemainingSeats
                FROM SubjectDetails
                WHERE SubjectId = @SubjectId;

                IF @RemainingSeats > 0
                BEGIN
                    INSERT INTO Allotments(SubjectId, StudentId)
                    VALUES (@SubjectId, @StudentId);

                    UPDATE SubjectDetails
                    SET RemainingSeats = RemainingSeats - 1
                    WHERE SubjectId = @SubjectId;

                    SET @Allotted = 1;
                END
            END

            SET @Preference = @Preference + 1;
        END

        IF @Allotted = 0
        BEGIN
            INSERT INTO UnallotedStudents(StudentId)
            VALUES (@StudentId);
        END

        FETCH NEXT FROM student_cursor INTO @StudentId;
    END

    CLOSE student_cursor;
    DEALLOCATE student_cursor;

    DROP TABLE #TempPreferences;
END
GO


EXEC AllotSubjects;


SELECT * FROM Allotments;
SELECT * FROM UnallotedStudents;
