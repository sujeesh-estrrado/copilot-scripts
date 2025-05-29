IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Program_CourseBatchDuration]')
    AND type = N'P'
)
BEGIN
    EXEC(
    'CREATE PROCEDURE [dbo].[sp_Get_Program_CourseBatchDuration]
    (
        @intakeMasterID BIGINT = 0,
        @ord_id INT = 0
    )
    AS                  
    BEGIN 
        SELECT 
            CBD.Batch_Id,
            CBD.IntakeMasterID,
            CBD.Duration_Id AS DurationID,      
            CBD.Batch_Id AS ID,
            O.Organization_Name,                          
            CBD.Batch_Code AS BatchCode,   
            Tbl_Department.Course_Code,
            CONVERT(VARCHAR(50), CBD.Batch_From, 103) AS Batch_From,             
            CONVERT(VARCHAR(50), CBD.Batch_To, 103) AS Batch_To,
            CBD.Study_Mode,                 
            PD.Program_Duration_Type,                  
            PD.Program_Duration_Year,           
            PD.Program_Duration_Month,  
            CONVERT(VARCHAR(50), CBD.Intro_Date, 103) AS Intro_Date,                
            CBD.SyllubusCode,      
            CD.Course_Category_Id,  
            Tbl_Department.Department_Name, 
            Tbl_Department.Department_Id AS programid,   
            CC.Course_Category_Name AS CategoryName,
            CBD.SyllubusCode,  
            CONVERT(VARCHAR(50), CBD.Close_Date, 103) AS Close_Date,        
            Tbl_Department.Department_Id,
            Tbl_Department.Department_Id,
            Tbl_Department.Department_Name,
            ISNULL(CBD.Intro_Date, ''1900-01-01 00:00:00.000'') AS Intro_Datel,
            ISNULL(CBD.Close_Date, ''1900-01-01 00:00:00.000'') AS Close_Date,
            CBD.Org_Id,
            Tbl_Department.Course_Code AS ProgramCode
        FROM dbo.Tbl_Course_Batch_Duration CBD              
        INNER JOIN Tbl_Organzations O ON O.Organization_Id = CBD.Org_Id             
        INNER JOIN Tbl_Program_Duration PD ON CBD.Duration_Id = PD.Program_Category_Id                             
        INNER JOIN dbo.Tbl_Department ON Tbl_Department.Department_Id = PD.Program_Category_Id               
        INNER JOIN dbo.Tbl_Course_Department CD ON CD.Department_Id = Tbl_Department.Department_Id            
        INNER JOIN dbo.Tbl_Course_Category CC ON CC.Course_Category_Id = CD.Course_Category_Id            
        WHERE Batch_DelStatus = 0   
        AND Tbl_Department.Department_Status = 0
        AND (IntakeMasterID = @intakeMasterID OR @intakeMasterID = 0)                 
        AND CBD.Org_id = @ord_id  
        ORDER BY CBD.Batch_Id DESC   
    END'
    )
END
GO
