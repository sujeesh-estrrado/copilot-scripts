-- Check if the stored procedure [dbo].[Proc_Hstl_GetAll_Students_by_Hostel_Id] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Hstl_GetAll_Students_by_Hostel_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Hstl_GetAll_Students_by_Hostel_Id] 
        @Hostel_Id BIGINT  
        AS  
        BEGIN  
            SELECT  
                Tbl_Hstl_Student_Admission.Student_Admission_Id,  
                Tbl_Hstl_Student_Admission.Student_Id,  
                Tbl_Hstl_Student_Admission.Hostel_Id,  
                AH.Hostel_Name,  
                AH.Hostel_Location,  
                Tbl_Hstl_Student_Admission.Student_Admission_Id,  
                Tbl_Hstl_Student_Admission.Leaving_Date,  
                Tbl_Hstl_Student_Admission.Room_Id,  
                HR.Room_Name,  
                HR.Room_Code,  
                CASE 
                    WHEN Tbl_Hstl_Student_Admission.Status = ''true'' 
                    THEN ''Employee''  
                    ELSE ''Student'' 
                END AS Type,  
                CASE 
                    WHEN Tbl_Hstl_Student_Admission.Status = ''true'' 
                    THEN  
                        (
                            SELECT Tbl_Employee.Employee_FName + '' '' + Employee_LName AS Employeename  
                            FROM Tbl_Employee  
                            WHERE Tbl_Employee.Employee_Id = Tbl_Hstl_Student_Admission.Student_Id
                        )  
                    ELSE  
                        (
                            SELECT Tbl_Candidate_Personal_Det.Candidate_Fname + '' '' + Tbl_Candidate_Personal_Det.Candidate_Mname + '' '' + Tbl_Candidate_Personal_Det.Candidate_Lname AS CandidateName  
                            FROM Tbl_Candidate_Personal_Det  
                            WHERE Tbl_Candidate_Personal_Det.Candidate_Id = Tbl_Hstl_Student_Admission.Student_Id
                        )  
                END AS StudentEmpName  
            FROM dbo.Tbl_Hstl_Student_Admission  
            INNER JOIN dbo.Tbl_Hstl_Room HR ON HR.Room_Id = Tbl_Hstl_Student_Admission.Room_Id  
            INNER JOIN dbo.Tbl_HostelRegistration AH ON AH.Hostel_Id = Tbl_Hstl_Student_Admission.Hostel_Id  
            WHERE Tbl_Hstl_Student_Admission.Hostel_Id = @Hostel_Id  
        END
    ')
END
