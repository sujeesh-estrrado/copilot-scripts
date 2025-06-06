IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[view_intake]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[view_intake] AS
        SELECT 
            dbo.Tbl_Course_Batch_Duration.Duration_Id AS DurationID, 
            dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchCode, 
            dbo.Tbl_Course_Batch_Duration.Batch_From, 
            dbo.Tbl_Course_Batch_Duration.Batch_To, 
            dbo.Tbl_Department.Department_Id, 
            dbo.Tbl_Department.Department_Name AS CategoryName, 
            dbo.Tbl_Course_Batch_Duration.Study_Mode, 
            dbo.Tbl_Course_Batch_Duration.Batch_Id, 
            dbo.Tbl_Course_Batch_Duration.Org_Id, 
            dbo.Tbl_Course_Category.Course_Category_Id, 
            dbo.Tbl_Course_Category.Course_Category_Name, 
            dbo.Tbl_Course_Department.Course_Category_Id AS Expr1, 
            dbo.Tbl_Program_Duration.Duration_Id, 
            dbo.tbl_New_Admission.New_Admission_Id
        FROM dbo.Tbl_Course_Batch_Duration
        INNER JOIN dbo.Tbl_Program_Duration 
            ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Program_Duration.Duration_Id
        INNER JOIN dbo.Tbl_Department 
            ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Program_Duration.Program_Category_Id
        INNER JOIN dbo.Tbl_Course_Department 
            ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id
        INNER JOIN dbo.Tbl_Course_Category 
            ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id
        INNER JOIN dbo.tbl_New_Admission 
            ON dbo.Tbl_Department.Department_Id = dbo.tbl_New_Admission.Department_Id 
            AND dbo.Tbl_Course_Batch_Duration.Batch_Id = dbo.tbl_New_Admission.Batch_Id
    ')
END
