CREATE PROCEDURE ProcessSubjectRequests
AS
BEGIN
    SET NOCOUNT ON;

    -- Cursor to iterate over all subject change requests
    DECLARE @StudentID VARCHAR(50);
    DECLARE @RequestedSubjectID VARCHAR(50);
    DECLARE @CurrentSubjectID VARCHAR(50);

    DECLARE subject_cursor CURSOR FOR
    SELECT StudentID, SubjectID FROM SubjectRequest;

    OPEN subject_cursor;
    FETCH NEXT FROM subject_cursor INTO @StudentID, @RequestedSubjectID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get the current valid subject for the student (if any)
        SELECT @CurrentSubjectID = SubjectID
        FROM SubjectAllotments
        WHERE StudentID = @StudentID AND Is_Valid = 1;

        IF @CurrentSubjectID IS NULL
        BEGIN
            -- Student is not present in SubjectAllotments, insert directly as valid
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);
        END
        ELSE IF @CurrentSubjectID <> @RequestedSubjectID
        BEGIN
            -- Invalidate the currently valid subject
            UPDATE SubjectAllotments
            SET Is_Valid = 0
            WHERE StudentID = @StudentID AND Is_Valid = 1;

            -- Insert the new requested subject as valid
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);
        END
        -- If same as current, do nothing

        FETCH NEXT FROM subject_cursor INTO @StudentID, @RequestedSubjectID;
    END

    CLOSE subject_cursor;
    DEALLOCATE subject_cursor;

    -- Optional: Clear requests after processing
    DELETE FROM SubjectRequest;
END;


