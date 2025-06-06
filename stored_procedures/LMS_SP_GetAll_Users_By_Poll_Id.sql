IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Users_By_Poll_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Users_By_Poll_Id]                
        @Poll_Id BIGINT              
        AS              
        BEGIN              
            SET NOCOUNT ON;

            SELECT DISTINCT      
                P.Poll_id,   
                2 AS Stud_Emp_Class_Status, 
                CL.Class_Id AS Stud_Emp_Class_Id,
                CL.Class_Name AS [User]  
            FROM dbo.LMS_Tbl_Poll P     
            INNER JOIN LMS_Tbl_Poll_Send PS 
                ON P.Poll_id = PS.Poll_Id    
            INNER JOIN Tbl_Employee E 
                ON E.Employee_Id = P.Emp_Id   
            INNER JOIN LMS_Tbl_Class CL 
                ON CL.Class_Id = PS.Class_Id
            WHERE PS.Poll_Id = @Poll_Id;            
        END
    ')
END
