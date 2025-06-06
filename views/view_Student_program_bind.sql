IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[view_Student_program_bind]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[view_Student_program_bind] AS
        SELECT 
            dbo.Tbl_Student_NewApplication.Candidate_Id, 
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
            cbd.Org_Id, 
            cbd.Batch_From
        FROM dbo.Tbl_Student_NewApplication 
        LEFT OUTER JOIN dbo.tbl_New_Admission AS n 
            ON dbo.Tbl_Student_NewApplication.New_Admission_Id = n.New_Admission_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS l 
            ON l.Course_Level_Id = n.Course_Level_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Category AS c 
            ON c.Course_Category_Id = n.Course_Category_Id 
        LEFT OUTER JOIN dbo.Tbl_Department AS d 
            ON d.Department_Id = n.Department_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd 
            ON cbd.Batch_Id = n.Batch_Id 
        WHERE dbo.Tbl_Student_NewApplication.Candidate_DelStatus = 0
    ')
END
