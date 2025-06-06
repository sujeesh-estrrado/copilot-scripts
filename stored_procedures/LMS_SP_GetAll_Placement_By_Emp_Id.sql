IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_Placement_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_Placement_By_Emp_Id]       
        @Emp_Id bigint        
        AS          
        BEGIN     
            SET NOCOUNT ON;
            
            SELECT DISTINCT    
                P.Placement_Details_id,      
                P.Placement_Details_title,      
                P.Placement_Details_Descripition,      
                P.Placement_Details_Date,      
                P.Placement_Criteria,      
                P.Venue,  
                P.Emp_Id,     
                ToName = SUBSTRING(
                    (SELECT DISTINCT '','' + C.Class_Name 
                     FROM LMS_Tbl_Class C        
                     INNER JOIN LMS_Tbl_Placement_Send PS ON C.Class_Id = PS.Class_Id        
                     WHERE C.Class_Id = PS.Class_Id 
                     AND PS.Placement_Details_id  = P.Placement_Details_id      
                     FOR XML PATH('''')), 2, 1000),    
                P.Company_Name,      
                CASE 
                    WHEN P.Emp_Id = @Emp_Id THEN ''Me''       
                    ELSE E.Employee_FName 
                END AS FromName       
            FROM LMS_Tbl_Placement_Details P       
            INNER JOIN LMS_Tbl_Placement_Send PS ON PS.Placement_Details_id = P.Placement_Details_id      
            INNER JOIN LMS_Tbl_Emp_Class EC ON EC.Class_Id = PS.Class_Id      
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = P.Emp_Id      
            INNER JOIN LMS_Tbl_Class C ON C.Class_Id = PS.Class_Id       
            WHERE P.Emp_Id = @Emp_Id  OR EC.Class_Id = PS.Class_Id    
            ORDER BY Placement_Details_id DESC;  
        END
    ')
END
