IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Users_By_Note_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Users_By_Note_Id]     
        @Note_Id BIGINT    
        AS    
        BEGIN    
            SET NOCOUNT ON;

            SELECT  
                SN.Stud_Emp_Class_Status,  
                SN.Stud_Emp_Class_Id,   
                SN.Approval_Status,
                CASE 
                    WHEN SN.Stud_Emp_Class_Status = 0 THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname   
                    WHEN SN.Stud_Emp_Class_Status = 2 THEN CL.Class_Name  
                    ELSE E.Employee_Fname + '' '' + E.Employee_Lname 
                END AS [User]  
            FROM LMS_Tbl_Send_Notes SN   
            LEFT JOIN Tbl_Candidate_Personal_Det C 
                ON C.Candidate_Id = SN.Stud_Emp_Class_Id    
            LEFT JOIN LMS_Tbl_Class CL 
                ON CL.Class_Id = SN.Stud_Emp_Class_Id  
            LEFT JOIN Tbl_Employee E 
                ON E.Employee_Id = SN.Stud_Emp_Class_Id  
            WHERE SN.Note_Id = @Note_Id  
              AND SN.Approval_Status = 0;
        END
    ')
END
