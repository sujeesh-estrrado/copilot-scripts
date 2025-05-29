IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Intake_By_serach_Term]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_Intake_By_serach_Term]   
    (
        @SearchTerm VARCHAR(100)            
    )          
    AS            
    BEGIN     
        SELECT * 
        FROM 
        (
            SELECT             
                ROW_NUMBER() OVER (PARTITION BY Tbl_Course_Batch_Duration.Batch_Id ORDER BY Tbl_Course_Batch_Duration.Batch_Id) AS num, 
                Tbl_Course_Batch_Duration.Duration_Id AS DurationID,
                Tbl_Course_Batch_Duration.Batch_Id AS ID,                  
                Tbl_Course_Batch_Duration.Batch_Code AS BatchCode,                  
                Tbl_Course_Batch_Duration.Batch_From,
                Tbl_Course_Batch_Duration.Batch_To,                  
                Tbl_Department.Department_Name AS CategoryName,            
                Tbl_Course_Batch_Duration.Study_Mode,             
                Tbl_Course_Duration.Course_Category_Id,        
                Tbl_Course_Duration.Course_Duration_Type,        
                Tbl_Course_Duration.Course_Duration_Year,      
                Tbl_Course_Batch_Duration.Intro_Date,      
                Tbl_Course_Batch_Duration.SyllubusCode,
                Tbl_Course_Batch_Duration.Batch_DelStatus,
                Tbl_Department.Department_Status        
            FROM 
                dbo.Tbl_Course_Batch_Duration                  
            INNER JOIN 
                Tbl_Course_Duration ON Tbl_Course_Batch_Duration.Duration_Id = Tbl_Course_Duration.Duration_Id                 
            INNER JOIN 
                Tbl_Department ON Tbl_Department.Department_Id = Tbl_Course_Duration.Course_Category_Id     
            INNER JOIN 
                Tbl_Course_Department ON Tbl_Course_Department.Department_Id = Tbl_Department.Department_Id  
            INNER JOIN 
                Tbl_Course_Category ON Tbl_Course_Category.Course_Category_Id = Tbl_Course_Department.Course_Category_Id
        ) AS Base
        WHERE  
        (
            CategoryName LIKE ''%'' + @SearchTerm + ''%'' OR       
            BatchCode LIKE ''%'' + @SearchTerm + ''%'' OR       
            Study_Mode LIKE ''%'' + @SearchTerm + ''%'' OR       
            Batch_From LIKE ''%'' + @SearchTerm + ''%'' OR       
            Batch_To LIKE ''%'' + @SearchTerm + ''%'' OR   
            Course_Duration_Type LIKE ''%'' + @SearchTerm + ''%'' OR   
            Course_Duration_Year LIKE ''%'' + @SearchTerm + ''%'' OR  
            Intro_Date LIKE ''%'' + @SearchTerm + ''%''
        )  
        AND Batch_DelStatus = 0  
        AND Department_Status = 0  
    END
    ')
END
