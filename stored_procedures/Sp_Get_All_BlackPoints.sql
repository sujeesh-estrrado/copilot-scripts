IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_BlackPoints]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_All_BlackPoints]  
        AS  
        BEGIN  
            SELECT 
                bp.*, 
                e.Employee_FName + '' '' + e.Employee_LName AS Teachr_Name
            FROM dbo.LMS_Tbl_BlackPoint bp  
            INNER JOIN dbo.Tbl_Employee e ON e.Employee_Id = bp.Employee_Id  
        END
    ')
END
