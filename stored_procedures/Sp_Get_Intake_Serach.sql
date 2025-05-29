IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Intake_Search]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_Intake_Search]        
    (                        
        @CurrentPage INT = 1,                   
        @PageSize INT = 10,                
        @SearchTerm NVARCHAR(100) = NULL,
        @TotalCount INT OUTPUT                      
    )                         
    AS            
    BEGIN                        
                              
                        
        -- Validate input parameters
        IF @CurrentPage < 1 SET @CurrentPage = 1
        IF @PageSize < 1 SET @PageSize = 10
        
        -- Calculate pagination bounds
        DECLARE @LowerBound INT = (@CurrentPage - 1) * @PageSize
        
        -- Get total count of records
        SELECT @TotalCount = COUNT(*)
        FROM Tbl_Course_Batch_Duration CBD                          
        INNER JOIN Tbl_Course_Duration CD ON CBD.Duration_Id = CD.Duration_Id                         
        INNER JOIN Tbl_Department D ON D.Department_Id = CD.Course_Category_Id             
        INNER JOIN Tbl_Course_Department CDEP ON CDEP.Department_Id = D.Department_Id          
        INNER JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = CDEP.Course_Category_Id
        WHERE CBD.Batch_DelStatus = 0  
        AND D.Department_Status = 0
        AND (
            @SearchTerm IS NULL 
            OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%'' 
            OR CBD.Batch_Code LIKE ''%'' + @SearchTerm + ''%'' 
            OR CBD.Study_Mode LIKE ''%'' + @SearchTerm + ''%'' 
            OR CONVERT(NVARCHAR, CBD.Batch_From, 120) LIKE ''%'' + @SearchTerm + ''%'' 
            OR CONVERT(NVARCHAR, CBD.Batch_To, 120) LIKE ''%'' + @SearchTerm + ''%'' 
            OR CD.Course_Duration_Type LIKE ''%'' + @SearchTerm + ''%'' 
            OR CD.Course_Duration_Month LIKE ''%'' + @SearchTerm + ''%'' 
            OR CONVERT(NVARCHAR, CBD.Intro_Date, 120) LIKE ''%'' + @SearchTerm + ''%''
        )
        
        -- Main query with pagination
        SELECT           
            CBD.Batch_Id,             
            CBD.Batch_Code AS BatchCode,                                     
            CBD.Study_Mode,                                   
            CBD.Batch_From,               
            CBD.Batch_To,        
            D.Department_Name AS CategoryName,           
            CD.Course_Duration_Type,          
            CD.Course_Duration_Month,          
            CBD.Intro_Date,        
            CBD.SyllubusCode,
            @TotalCount AS TotalRecords                                    
        FROM Tbl_Course_Batch_Duration CBD                          
        INNER JOIN Tbl_Course_Duration CD ON CBD.Duration_Id = CD.Duration_Id                         
        INNER JOIN Tbl_Department D ON D.Department_Id = CD.Course_Category_Id             
        INNER JOIN Tbl_Course_Department CDEP ON CDEP.Department_Id = D.Department_Id          
        INNER JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = CDEP.Course_Category_Id
        WHERE CBD.Batch_DelStatus = 0  
        AND D.Department_Status = 0
        AND (
            @SearchTerm IS NULL 
            OR D.Department_Name LIKE ''%'' + @SearchTerm + ''%'' 
            OR CBD.Batch_Code LIKE ''%'' + @SearchTerm + ''%'' 
            OR CBD.Study_Mode LIKE ''%'' + @SearchTerm + ''%'' 
            OR CONVERT(NVARCHAR, CBD.Batch_From, 120) LIKE ''%'' + @SearchTerm + ''%'' 
            OR CONVERT(NVARCHAR, CBD.Batch_To, 120) LIKE ''%'' + @SearchTerm + ''%'' 
            OR CD.Course_Duration_Type LIKE ''%'' + @SearchTerm + ''%'' 
            OR CD.Course_Duration_Month LIKE ''%'' + @SearchTerm + ''%'' 
            OR CONVERT(NVARCHAR, CBD.Intro_Date, 120) LIKE ''%'' + @SearchTerm + ''%''
        )
        ORDER BY CBD.Batch_Id DESC
        OFFSET @LowerBound ROWS
        FETCH NEXT @PageSize ROWS ONLY
    END
    ')
END
GO