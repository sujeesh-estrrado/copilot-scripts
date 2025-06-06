IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Faculity_Wise_StudentList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Faculity_Wise_StudentList] 
            @EmployeeId BIGINT = 0,
            @CourseLevel BIGINT = 0
        AS
        BEGIN
            

            SELECT 
                CONCAT(BB.Candidate_Fname, '' '', BB.Candidate_Lname) AS Name,
                BB.AdharNumber,
                CC.Candidate_Email,
                CASE 
                    WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
                    ELSE (
                        SELECT D.Department_Name
                        FROM Tbl_Department D
                        WHERE D.Department_Id = NA.Department_Id
                    ) 
                END AS Department_Name,
                DEP.Employee_Id,
                CL.Course_Level_Name AS LevelName
            FROM Tbl_Candidate_Personal_Det AS BB
            LEFT JOIN dbo.Tbl_Candidate_ContactDetails AS CC 
                ON BB.Candidate_Id = CC.Candidate_Id 
            LEFT JOIN dbo.tbl_New_Admission AS NA 
                ON NA.New_Admission_Id = BB.New_Admission_Id 
            LEFT JOIN dbo.Tbl_Course_Level AS CL 
                ON CL.Course_Level_Id = NA.Course_Level_Id 
            LEFT JOIN Tbl_Emp_CourseDepartment_Allocation AS DEP 
                ON DEP.Allocated_CourseDepartment_Id = NA.Course_Level_Id  
            WHERE 
                DEP.Employee_Id = @EmployeeId 
                AND NA.Course_Level_Id = @CourseLevel 
                AND BB.ApplicationStatus = ''Completed'' 
                AND BB.Candidate_DelStatus = 0;
        END
    ')
END
ELSE
BEGIN
EXEC('

ALTER procedure [dbo].[Faculity_Wise_StudentList] 
@EmployeeId bigint=0,
@CourseLevel bigint=0
AS
BEGIN
	SELECT CONCAT(Candidate_Fname,'' '',Candidate_Lname) AS name ,AdharNumber,CC.Candidate_Email, CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE
                             (SELECT        D .Department_Name
                               FROM            Tbl_Department D
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department_Name,DEP.Employee_Id,CL.Course_Level_Name AS LevelName FROM Tbl_Candidate_Personal_Det as BB left join
  dbo.Tbl_Candidate_ContactDetails as CC ON BB.Candidate_Id = CC.Candidate_Id LEFT JOIN
  dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = BB.New_Admission_Id LEFT JOIN
  dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id left join
  Tbl_Emp_CourseDepartment_Allocation AS DEP on DEP.Allocated_CourseDepartment_Id=NA.Course_Level_Id  where DEP.Employee_Id=24 And NA.Course_level_Id=@CourseLevel and  BB.ApplicationStatus=''Completed'' and BB.Candidate_DelStatus=0

  
END



')
END
