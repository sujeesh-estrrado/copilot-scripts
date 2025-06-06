IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Semester_SELECT_ALL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Course_Semester_SELECT_ALL] 
            @flag BIGINT = 0,
            @Batch_Id BIGINT = 0,
            @Semester_Id BIGINT = 0,
            @Department_Id BIGINT = 0
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT 
                    [Semester_Id],
                    [Semester_Code],
                    [Semester_Name],
                    [Semester_DelStatus]
                FROM [Tbl_Course_Semester]
                WHERE Semester_DelStatus = 0
                ORDER BY [Semester_Id];
            END

            IF (@flag = 1)
            BEGIN
                SELECT 
                    [Semester_Id],
                    [Semester_Code],
                    [Semester_Name],
                    [Semester_DelStatus]
                FROM [Tbl_Course_Semester]
                WHERE Semester_DelStatus = 0
                    AND Semester_Id NOT IN (
                        SELECT Semester_Id 
                        FROM Tbl_Course_Duration_PeriodDetails 
                        WHERE Batch_Id = @Batch_Id 
                        AND Duration_Period_Status = 0
                    )
                ORDER BY [Semester_Id];
            END

            IF (@flag = 2)
            BEGIN
                SELECT 
                    [Semester_Id],
                    [Semester_Code],
                    [Semester_Name],
                    [Semester_DelStatus]
                FROM [Tbl_Course_Semester]
                WHERE Semester_DelStatus = 0 
                    AND [Semester_Id] = @Semester_Id;
            END

            IF (@flag = 3)
            BEGIN
                SELECT DISTINCT 
                    CS.Semester_Id,
                    CS.Semester_Code,
                    CS.Semester_Name,
                    CS.Semester_DelStatus
                FROM Tbl_Department D
                LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Duration_Id = D.Department_Id
                LEFT JOIN Tbl_Course_Duration_PeriodDetails CD ON CD.Batch_Id = BD.Batch_Id
                LEFT JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CD.Semester_Id
                WHERE BD.Batch_DelStatus = 0 
                    AND CD.Delete_Status = 0 
                    AND CS.Semester_DelStatus = 0 
                    AND CD.Batch_Id = @Batch_Id
                    AND D.Department_Id = @Department_Id;
            END
        END
    ')
END
