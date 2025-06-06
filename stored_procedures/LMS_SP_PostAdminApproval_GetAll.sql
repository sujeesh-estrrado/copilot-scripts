IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_PostAdminApproval_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_PostAdminApproval_GetAll]
        AS
        BEGIN
            SET NOCOUNT ON;

            SELECT   
                SN.Note_Id,  
                N.Note_Description,  

                -- Determine "To_" field based on Stud_Emp_Class_Status
                CASE 
                    WHEN SN.Stud_Emp_Class_Status = 0 THEN ''Student''  
                    WHEN SN.Stud_Emp_Class_Status = 1 THEN ''Faculty''  
                    ELSE ''Class''  
                END AS To_,  

                -- Determine "From_" field based on Stud_Emp_Status
                CASE 
                    WHEN N.Stud_Emp_Status = 0 THEN ''Student''   
                    WHEN N.Stud_Emp_Status = 1 THEN ''Faculty''  
                END AS From_,  

                -- Determine "FromName" field based on Stud_Emp_Status
                CASE 
                    WHEN N.Stud_Emp_Status = 0 THEN cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname  
                    WHEN N.Stud_Emp_Status = 1 THEN e.Employee_FName + '' '' + e.Employee_LName    
                END AS FromName,  

                SN.Stud_Emp_Class_Id,  
                N.Stud_Emp_Id,  
                N.Note_Date,    

                -- Determine Active_Status based on Approval_Status
                CASE 
                    WHEN SN.Approval_Status IS NULL THEN ''Pending''  
                    WHEN SN.Approval_Status = 1 THEN ''Rejected''     
                    WHEN SN.Approval_Status = 0 THEN ''Approved''  
                END AS Active_Status  

            FROM LMS_Tbl_Send_Notes SN  
            INNER JOIN LMS_Tbl_Notes N 
                ON N.Note_Id = SN.Note_Id  
            LEFT JOIN Tbl_Candidate_Personal_Det cpd 
                ON cpd.Candidate_Id = N.Stud_Emp_Id   
            LEFT JOIN Tbl_Employee e  
                ON e.Employee_Id = N.Stud_Emp_Id  
            LEFT JOIN LMS_Tbl_Class C 
                ON C.Class_Id = N.Stud_Emp_Id;
        END
    ')
END;
