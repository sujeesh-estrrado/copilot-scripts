IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_New_Admission_byCandidate_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_New_Admission_byCandidate_Id] (@Candidate_Id BIGINT)
        AS
        BEGIN
            SELECT Tbl_Candidate_Personal_Det.Candidate_Id,   
                   l.Course_Level_Id, 
                   l.Course_Level_Name,
                   c.Course_Category_Id,
                   c.Course_Category_Name,
                   d.Department_Id,
                   d.Department_Name,
                   cbd.Batch_Id,
                   cbd.Batch_Code AS Batch,        
                   Status = CASE WHEN Admission_Status = 1 THEN ''Active'' ELSE ''Inactive'' END
            FROM dbo.tbl_New_Admission n 
            LEFT JOIN Tbl_Candidate_Personal_Det ON Tbl_Candidate_Personal_Det.New_Admission_Id = n.New_Admission_Id 
            LEFT JOIN dbo.Tbl_Course_Level l ON l.Course_Level_Id = n.Course_Level_Id
            LEFT JOIN dbo.Tbl_Course_Category c ON c.Course_Category_Id = n.Course_Category_Id
            LEFT JOIN dbo.Tbl_Department d ON d.Department_Id = n.Department_Id
            LEFT JOIN dbo.Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = n.Batch_Id
            WHERE Tbl_Candidate_Personal_Det.Candidate_Id = @Candidate_Id
        END
    ')
END
