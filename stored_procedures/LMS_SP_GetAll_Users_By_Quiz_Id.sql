IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Users_By_Quiz_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Users_By_Quiz_Id]              
        @Quiz_Id BIGINT            
        AS            
        BEGIN            
            SET NOCOUNT ON;

            SELECT          
                QS.Student_Class_Status AS Stud_Emp_Class_Status,          
                QS.Student_Class_Id AS Stud_Emp_Class_Id,           
                CASE 
                    WHEN QS.Student_Class_Status = 0 THEN C.Candidate_Fname + '' '' + C.Candidate_Mname + '' '' + C.Candidate_Lname           
                    WHEN QS.Student_Class_Status = 1 THEN CL.Class_Name          
                END AS [User]          
            FROM LMS_Tbl_Quiz_Send QS           
            LEFT JOIN Tbl_Candidate_Personal_Det C 
                ON C.Candidate_Id = QS.Student_Class_Id            
            LEFT JOIN LMS_Tbl_Class CL 
                ON CL.Class_Id = QS.Student_Class_Id          
            WHERE QS.Quiz_Id = @Quiz_Id;          
        END
    ')
END
