IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_TrainingAttendees_Select_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Tbl_TrainingAttendees_Select_By_ID]
        @Training_Id BIGINT
    AS
    BEGIN
        SELECT 
            T.Training_Id,  
            Training_Attendees_Id,  
            StudentOrEmployee_Id,  
            StudentOrEmployee,  
            CASE 
                WHEN StudentOrEmployee = 0 THEN 
                    (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname)
                ELSE 
                    (Employee_FName + '' '' + Employee_LName) 
            END AS [Name],  
            CASE 
                WHEN StudentOrEmployee = 0 THEN 
                    (cc.Course_Category_Name + ''-'' + d.Department_Name)  
                ELSE 
                    (Dept_Name + ''-'' + Desg_Name) 
            END AS [CourseDepartment]
        FROM Tbl_TrainingAttendees T
        LEFT JOIN Tbl_Candidate_Personal_Det C 
            ON T.StudentOrEmployee_Id = C.Candidate_Id AND StudentOrEmployee = 0
        LEFT JOIN Tbl_Course_Category cc 
            ON cc.Course_Category_Id = c.Course_Category_Id
        LEFT JOIN Tbl_Department d 
            ON d.Department_Id = c.Department_Id
        LEFT JOIN Tbl_Employee E 
            ON E.Employee_Id = T.StudentOrEmployee_Id AND StudentOrEmployee = 1
        WHERE T.Training_Id = @Training_Id
    END
    ')
END
