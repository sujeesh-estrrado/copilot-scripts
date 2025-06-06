IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_From_Users_By_Note_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_From_Users_By_Note_Id]  
            @Note_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;
            
            SELECT DISTINCT 
                N.Note_Id,
                CASE 
                    WHEN N.Stud_Emp_Id = 0 THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname    
                    ELSE E.Employee_Fname + '' '' + E.Employee_Lname  
                END AS [User]
            FROM LMS_Tbl_Notes N
            INNER JOIN LMS_Tbl_Send_Notes SN ON N.Note_Id = SN.Note_Id  
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = N.Stud_Emp_Id  
            LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = SN.Stud_Emp_Class_Id    
            WHERE SN.Note_Id = @Note_Id;
        END
    ')
END
