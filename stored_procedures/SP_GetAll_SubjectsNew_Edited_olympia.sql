IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_SubjectsNew_Edited_olympia]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_SubjectsNew_Edited_olympia]   
        (
            @PageIndex INT,  
            @RecordsPerPage INT
        )  
        AS          
        BEGIN          
            -- Drop temp table if it already exists
            IF OBJECT_ID(''tempdb..#TempTable'') IS NOT NULL  
                DROP TABLE #TempTable  

            -- Create temp table
            CREATE TABLE #TempTable  
            (
                ID INT IDENTITY(1,1) NOT NULL,  
                Subject_Id INT,  
                Subject_Name VARCHAR(300),  
                Parent_Subject VARCHAR(300),  
                Subject_Code VARCHAR(50)  
            )  

            DECLARE @TotalRecords INT  
            DECLARE @strSql NVARCHAR(MAX)  

            -- Set total number of records to be retrieved
            SET @TotalRecords = (@PageIndex * @RecordsPerPage)  

            -- Construct dynamic SQL for inserting data into temp table
            SET @strSql = ''
                INSERT INTO #TempTable (Subject_Id, Subject_Name, Parent_Subject, Subject_Code)  
                SELECT TOP '' + CONVERT(VARCHAR(4), @TotalRecords) + '' Subject_Id, Subject_Name, Parent_Subject, Subject_Code  
                FROM View_All_Subjects  
                ORDER BY Subject_Id ASC
            ''

            -- Execute the dynamic SQL
            EXEC (@strSql)  

            -- Retrieve paginated data from temp table
            SELECT * 
            FROM #TempTable 
            WHERE ID > (@TotalRecords - @RecordsPerPage)        
        END
    ')
END
