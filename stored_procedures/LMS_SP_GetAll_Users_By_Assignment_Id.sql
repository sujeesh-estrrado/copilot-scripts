IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Users_By_Assignment_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Users_By_Assignment_Id]            
        @Assignment_Id BIGINT          
        AS          
        BEGIN          
            SET NOCOUNT ON;
            
            SELECT        
                CASE 
                    WHEN SA.Stud_Class_Status = 0 THEN 0 
                    ELSE 2 
                END AS Stud_Emp_Class_Status,        
                SA.Stud_Class_Id AS Stud_Emp_Class_Id,         
                CASE 
                    WHEN SA.Stud_Class_Status = 0 
                    THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname         
                    WHEN SA.Stud_Class_Status = 1 
                    THEN CL.Class_Name        
                END AS [User]        
            FROM LMS_Tbl_Send_Assignment SA         
            LEFT JOIN Tbl_Candidate_Personal_Det C 
                ON C.Candidate_Id = SA.Stud_Class_Id          
            LEFT JOIN LMS_Tbl_Class CL 
                ON CL.Class_Id = SA.Stud_Class_Id        
            WHERE SA.Assignment_Id = @Assignment_Id;        
        END
    ')
END
