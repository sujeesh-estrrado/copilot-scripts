IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_From_Users_By_Assignment_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_From_Users_By_Assignment_Id]  
            @Assignment_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;
            
            SELECT DISTINCT 
                A.Assignment_Id,  
                E.Employee_Fname + '' '' + E.Employee_Lname AS [User]
            FROM LMS_Tbl_Assignment A    
            INNER JOIN LMS_Tbl_Send_Assignment SA ON A.Assignment_Id = SA.Assignment_Id   
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = A.Emp_Id    
            WHERE SA.Assignment_Id = @Assignment_Id;
        END
    ')
END
