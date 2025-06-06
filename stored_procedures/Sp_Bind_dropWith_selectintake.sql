IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Bind_dropWith_selectintake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Bind_dropWith_selectintake]
        (@id BIGINT)
        AS
        BEGIN
            IF EXISTS (SELECT Candidate_Id 
                       FROM Tbl_Student_NewApplication 
                       WHERE Candidate_Id = @id 
                       AND Candidate_DelStatus = 0)
            BEGIN
                SELECT  
                    dbo.Tbl_Student_NewApplication.Candidate_Id, 
                    dbo.Tbl_Department.Department_Name,
                    dbo.Tbl_Department.Department_Id, 
                    Tbl_Department_1.Department_Name AS Department_Name2, 
                    Tbl_Department_2.Department_Name AS Department_Name3, 
                    dbo.Tbl_Department.Course_Code, 
                    dbo.tbl_New_Admission.Department_Id AS Opt1, 
                    tbl_New_Admission_1.Department_Id AS Opt2, 
                    tbl_New_Admission_2.Department_Id AS Opt3
                FROM   
                    dbo.Tbl_Course_Department AS Tbl_Course_Department_1 
                INNER JOIN dbo.tbl_New_Admission AS tbl_New_Admission_1 
                    ON Tbl_Course_Department_1.Department_Id = tbl_New_Admission_1.Department_Id 
                    AND Tbl_Course_Department_1.Course_Category_Id = tbl_New_Admission_1.Course_Category_Id 
                INNER JOIN dbo.Tbl_Department AS Tbl_Department_1 
                    ON Tbl_Course_Department_1.Department_Id = Tbl_Department_1.Department_Id 
                RIGHT OUTER JOIN dbo.Tbl_Department AS Tbl_Department_2 
                INNER JOIN dbo.tbl_New_Admission AS tbl_New_Admission_2 
                INNER JOIN dbo.Tbl_Course_Department AS Tbl_Course_Department_2 
                    ON tbl_New_Admission_2.Department_Id = Tbl_Course_Department_2.Department_Id 
                    AND tbl_New_Admission_2.Course_Category_Id = Tbl_Course_Department_2.Course_Category_Id 
                ON Tbl_Department_2.Department_Id = Tbl_Course_Department_2.Department_Id 
                RIGHT OUTER JOIN dbo.Tbl_Student_NewApplication 
                LEFT OUTER JOIN dbo.Tbl_Department 
                INNER JOIN dbo.Tbl_Course_Department 
                INNER JOIN dbo.tbl_New_Admission 
                    ON dbo.Tbl_Course_Department.Department_Id = dbo.tbl_New_Admission.Department_Id 
                    AND dbo.Tbl_Course_Department.Course_Category_Id = dbo.tbl_New_Admission.Course_Category_Id 
                ON dbo.Tbl_Department.Department_Id = dbo.tbl_New_Admission.Department_Id 
                ON dbo.Tbl_Student_NewApplication.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id 
                ON tbl_New_Admission_2.New_Admission_Id = dbo.Tbl_Student_NewApplication.Option3 
                ON tbl_New_Admission_1.New_Admission_Id = dbo.Tbl_Student_NewApplication.Option2
                WHERE  
                    dbo.Tbl_Student_NewApplication.Candidate_Id = @id 
                    AND dbo.Tbl_Student_NewApplication.Candidate_DelStatus = 0;
            END
            ELSE
            BEGIN
                SELECT  
                    dbo.Tbl_Candidate_Personal_Det.Candidate_Id, 
                    dbo.Tbl_Department.Department_Name,
                    dbo.Tbl_Department.Department_Id, 
                    Tbl_Department_1.Department_Name AS Department_Name2, 
                    Tbl_Department_2.Department_Name AS Department_Name3, 
                    dbo.Tbl_Department.Course_Code, 
                    dbo.tbl_New_Admission.Department_Id AS Opt1, 
                    tbl_New_Admission_1.Department_Id AS Opt2, 
                    tbl_New_Admission_2.Department_Id AS Opt3
                FROM   
                    dbo.Tbl_Course_Department AS Tbl_Course_Department_1 
                INNER JOIN dbo.tbl_New_Admission AS tbl_New_Admission_1 
                    ON Tbl_Course_Department_1.Department_Id = tbl_New_Admission_1.Department_Id 
                    AND Tbl_Course_Department_1.Course_Category_Id = tbl_New_Admission_1.Course_Category_Id 
                INNER JOIN dbo.Tbl_Department AS Tbl_Department_1 
                    ON Tbl_Course_Department_1.Department_Id = Tbl_Department_1.Department_Id 
                RIGHT OUTER JOIN dbo.Tbl_Department AS Tbl_Department_2 
                INNER JOIN dbo.tbl_New_Admission AS tbl_New_Admission_2 
                INNER JOIN dbo.Tbl_Course_Department AS Tbl_Course_Department_2 
                    ON tbl_New_Admission_2.Department_Id = Tbl_Course_Department_2.Department_Id 
                    AND tbl_New_Admission_2.Course_Category_Id = Tbl_Course_Department_2.Course_Category_Id 
                ON Tbl_Department_2.Department_Id = Tbl_Course_Department_2.Department_Id 
                RIGHT OUTER JOIN dbo.Tbl_Candidate_Personal_Det 
                LEFT OUTER JOIN dbo.Tbl_Department 
                INNER JOIN dbo.Tbl_Course_Department 
                INNER JOIN dbo.tbl_New_Admission 
                    ON dbo.Tbl_Course_Department.Department_Id = dbo.tbl_New_Admission.Department_Id 
                    AND dbo.Tbl_Course_Department.Course_Category_Id = dbo.tbl_New_Admission.Course_Category_Id 
                ON dbo.Tbl_Department.Department_Id = dbo.tbl_New_Admission.Department_Id 
                ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id 
                ON tbl_New_Admission_2.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.Option3 
                ON tbl_New_Admission_1.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.Option2
                WHERE  
                    dbo.Tbl_Candidate_Personal_Det.Candidate_Id = @id 
                    AND dbo.Tbl_Candidate_Personal_Det.Candidate_DelStatus = 0;
            END
        END
    ')
END
