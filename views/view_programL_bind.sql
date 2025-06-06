IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[view_programL_bind]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[view_programL_bind] AS
        SELECT 
            dbo.Tbl_Candidate_Personal_Det.Candidate_Id, 
            l.Course_Level_Id, 
            l.Course_Level_Name, 
            c.Course_Category_Id, 
            c.Course_Category_Name, 
            d.Department_Id, 
            d.Department_Name, 
            cbd.Batch_Id, 
            cbd.Batch_Code AS Batch, 
            CASE 
                WHEN Admission_Status = 1 THEN ''Active'' 
                ELSE ''Inactive'' 
            END AS Status, 
            cbd.Batch_From, 
            dbo.Tbl_Candidate_Personal_Det.Campus AS Org_Id2, 
            cbd.Org_Id
        FROM dbo.tbl_New_Admission AS n 
        LEFT OUTER JOIN dbo.Tbl_Candidate_Personal_Det 
            ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = n.New_Admission_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS l 
            ON l.Course_Level_Id = n.Course_Level_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Category AS c 
            ON c.Course_Category_Id = n.Course_Category_Id 
        LEFT OUTER JOIN dbo.Tbl_Department AS d 
            ON d.Department_Id = n.Department_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd 
            ON cbd.Batch_Id = n.Batch_Id
    ')
END
