IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Placement_Details_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Placement_Details_ByID]     
        @Placement_Details_Id BIGINT    
        AS    
        BEGIN     
            SELECT 
                PD.Placement_Details_Id,    -- Explicit columns from PD
                PD.Company_Id,              
                PD.Placement_Date,          
                PD.Placement_Location,      
                PD.Job_Description,         
                PD.Salary,                  
                PD.Placement_Status,        
                PD.Placement_Coordinator,   
                PD.Delete_Status,           
                PD.Created_Date,            
                PD.Modified_Date,           
                CR.Company_Name,            
                ISNULL(E.Employee_FName, '''') + '' '' + ISNULL(E.Employee_LName, '''') AS [Placement Co-ordinator]   
            FROM 
                dbo.Tbl_Placement_Details PD    
                INNER JOIN dbo.Tbl_Company_Registration CR 
                    ON CR.Company_Id = PD.Company_Id  
                LEFT JOIN dbo.Tbl_Employee E 
                    ON E.Employee_Id = PD.[Placement_Co-ordinator]  
            WHERE 
                PD.Placement_Details_Id = @Placement_Details_Id 
                AND PD.Delete_Status = 0    
        END
    ')
END
