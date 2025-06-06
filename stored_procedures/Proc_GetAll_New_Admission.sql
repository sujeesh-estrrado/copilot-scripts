IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_New_Admission]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_New_Admission]
        AS
        BEGIN
            SELECT 
                n.*, 
                CONVERT(varchar(11), n.FromDate, 101) AS FromDate1, 
                CONVERT(varchar(11), n.ToDate, 101) AS ToDate1, 
                CONVERT(varchar(11), n.EndDate, 101) AS EndDate1, 
                l.Course_Level_Name, 
                c.Course_Category_Name, 
                d.Department_Name, 
                cbd.Batch_Code AS Batch, 
                Status = CASE WHEN Admission_Status = 1 THEN ''Active'' ELSE ''Inactive'' END
            FROM dbo.tbl_New_Admission n
            LEFT JOIN dbo.Tbl_Course_Level l ON l.Course_Level_Id = n.Course_Level_Id
            LEFT JOIN dbo.Tbl_Course_Category c ON c.Course_Category_Id = n.Course_Category_Id
            LEFT JOIN dbo.Tbl_Department d ON d.Department_Id = n.Department_Id
            LEFT JOIN dbo.Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = n.Batch_Id
        END
    ')
END
