IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Transport_Registration_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Transport_Registration_By_ID]        
        (@Student_Transport_Id BIGINT)
        AS
        BEGIN
            SELECT  
                TA.*, 
                CASE 
                    WHEN Student_Employee_Status = 0 
                    THEN (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname) 
                    ELSE (Employee_FName + '' '' + Employee_LName) 
                END AS Name,
                SS.Duration_Mapping_Id,
                CC.Course_Category_Name,
                D.Department_Name,
                Batch_Code + ''-'' + Semester_Code AS BatchSemester,
                D.Department_Id,
                CD.Course_Department_Id
            FROM  
                Tbl_Transport_Admission TA
            LEFT JOIN 
                Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = TA.Student_Employee_Id
            LEFT JOIN 
                Tbl_Student_Registration SR ON CPD.Candidate_Id = SR.Candidate_Id
            LEFT JOIN 
                Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
            LEFT JOIN 
                Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id
            INNER JOIN 
                Tbl_Course_Duration_PeriodDetails CDPD ON CDM.Duration_Period_Id = CDPD.Duration_Period_Id
            INNER JOIN 
                Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDPD.Batch_Id
            INNER JOIN 
                Tbl_Course_Semester CS ON CS.Semester_Id = CDPD.Semester_Id
            LEFT JOIN 
                Tbl_Course_Department CD ON CDM.Course_Department_Id = CD.Course_Department_Id
            LEFT JOIN 
                Tbl_Course_Category CC ON CD.Course_Category_Id = CC.Course_Category_Id
            LEFT JOIN 
                Tbl_Department D ON SR.Department_Id = D.Department_Id
            LEFT JOIN 
                Tbl_Employee E ON E.Employee_Id = TA.Student_Employee_Id
            LEFT JOIN 
                Tbl_Employee_Official EO ON EO.Employee_Id = E.Employee_Id
            LEFT JOIN 
                Tbl_Emp_Department ED ON ED.Dept_Id = EO.Department_Id
            WHERE 
                Student_Transport_Id = @Student_Transport_Id
        END
    ')
END
