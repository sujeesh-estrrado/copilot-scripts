IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_StudentCareerTest_Marks]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_StudentCareerTest_Marks]
            @Student_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;

            DECLARE @count BIGINT;
            DECLARE @TempCount BIGINT;
            DECLARE @marks BIGINT;
            DECLARE @category BIGINT;
            DECLARE @TotalMarks BIGINT;

            -- Create temporary table to store unique CareerCategory_Id
            CREATE TABLE #temp_tbl (
                Id BIGINT PRIMARY KEY IDENTITY(1,1), 
                CareerCategory_Id BIGINT
            );

            -- Insert distinct CareerCategory_Id values for the given Student_Id
            INSERT INTO #temp_tbl (CareerCategory_Id)
            SELECT DISTINCT CareerCategory_Id 
            FROM LMS_Tbl_StudentMarks 
            WHERE Student_Id = @Student_Id;

            -- Get total count of distinct CareerCategory_Id
            SET @TempCount = (SELECT COUNT(Id) FROM #temp_tbl);
            SET @count = 1;

            -- Loop through each category and calculate marks
            WHILE @count <= @TempCount
            BEGIN
                SET @category = (SELECT CareerCategory_Id FROM #temp_tbl WHERE Id = @count);
                SET @marks = (SELECT SUM(Mark) FROM LMS_Tbl_StudentMarks WHERE CareerCategory_Id = @category);
                SET @TotalMarks = (SELECT COUNT(CareerCategory_Id) * 5 FROM LMS_Tbl_StudentMarks WHERE CareerCategory_Id = @category);

                -- Insert calculated marks into the CareerTestMarks table
                INSERT INTO LMS_Tbl_CareerTestMarks (CareerCategory_Id, Marks, Student_Id, Total_Marks) 
                VALUES (@category, @marks, @Student_Id, @TotalMarks);

                SET @count = @count + 1;
            END;

            -- Drop temporary table
            DROP TABLE #temp_tbl;
        END
    ')
END;
