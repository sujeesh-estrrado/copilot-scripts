IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewCandidateOption]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[ViewCandidateOption] AS
        SELECT 
            Opt1.New_Admission_Id, 
            Opt1.Department_Id, 
            Dept.Department_Name, 
            Opt1.Admission_Status, 
            Dept.Course_Code, 
            Opt1.Course_Category_Id
        FROM dbo.tbl_New_Admission AS Opt1 
        INNER JOIN dbo.Tbl_Department AS Dept 
            ON Opt1.Department_Id = Dept.Department_Id
    ')
END
