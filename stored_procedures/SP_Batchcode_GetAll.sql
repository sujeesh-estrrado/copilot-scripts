IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Batchcode_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Batchcode_GetAll]
        AS
        BEGIN
            SELECT 
                BD.Batch_Id,
                BD.Duration_Id AS DurationID,
                intake_no,
                BD.Batch_Id AS ID,
                BD.Batch_Code AS BatchCode,
                BD.Batch_From,
                BD.Batch_To,
                BD.Study_Mode,
                PD.Program_Duration_Type,
                PD.Program_Duration_Year,
                PD.Program_Duration_Month,
                BD.Intro_Date,
                BD.SyllubusCode,
                CD.Course_Category_Id,
                CC.Course_Category_Name AS CategoryName,
                D.Department_Id,
                CONCAT(FORMAT(BD.Batch_From, ''MMMM''), '' '', FORMAT(BD.Batch_From, ''yyyy'')) AS Batchname
            FROM dbo.Tbl_Course_Batch_Duration BD
            INNER JOIN Tbl_Program_Duration PD ON BD.Duration_Id = PD.Duration_Id
            INNER JOIN dbo.Tbl_Department D ON D.Department_Id = PD.Program_Category_Id
            INNER JOIN dbo.Tbl_Course_Department CD ON CD.Department_Id = D.Department_Id
            INNER JOIN dbo.Tbl_Course_Category CC ON CC.Course_Category_Id = CD.Course_Category_Id
            WHERE Batch_DelStatus = 0 
              AND D.Department_Status = 0
            ORDER BY BatchCode DESC
        END
    ')
END
