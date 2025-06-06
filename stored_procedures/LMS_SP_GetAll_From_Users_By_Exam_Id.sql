IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_From_Users_By_Exam_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_From_Users_By_Exam_Id]  
            @Exams_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;
            
            SELECT DISTINCT 
                E.Exams_Id,  
                EMP.Employee_Fname + '' '' + EMP.Employee_Lname AS [User]
            FROM LMS_Tbl_Exams E  
            INNER JOIN LMS_Tbl_Exam_Send SE ON E.Exams_Id = SE.Exams_Id    
            INNER JOIN Tbl_Employee EMP ON EMP.Employee_Id = E.Emp_Id      
            WHERE E.Exams_Id = @Exams_Id;
        END
    ')
END
