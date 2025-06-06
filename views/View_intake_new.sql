IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[View_intake_new]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[View_intake_new] AS
        SELECT 
            dbo.tbl_New_Admission.New_Admission_Id, 
            dbo.Tbl_Course_Batch_Duration.Batch_Id, 
            dbo.Tbl_Department.Department_Id, 
            dbo.Tbl_Course_Category.Course_Category_Id, 
            dbo.Tbl_Course_Category.Course_Category_Name, 
            dbo.Tbl_Course_Batch_Duration.Batch_Code, 
            dbo.Tbl_Department.Department_Name, 
            dbo.Tbl_Course_Batch_Duration.Batch_To, 
            dbo.Tbl_Course_Batch_Duration.Batch_From, 
            dbo.Tbl_Course_Batch_Duration.Study_Mode, 
            dbo.Tbl_Course_Batch_Duration.Duration_Id
        FROM dbo.tbl_New_Admission
        INNER JOIN dbo.Tbl_Course_Category 
            ON dbo.tbl_New_Admission.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id
        INNER JOIN dbo.Tbl_Course_Batch_Duration 
            ON dbo.tbl_New_Admission.Batch_Id = dbo.Tbl_Course_Batch_Duration.Batch_Id
        INNER JOIN dbo.Tbl_Department 
            ON dbo.Tbl_Course_Batch_Duration.Duration_Id = dbo.Tbl_Department.Department_Id
    ')
END
