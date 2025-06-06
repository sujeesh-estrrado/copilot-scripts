IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Select_Books_By_Type]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE [dbo].[Select_Books_By_Type]         
    @Book_Type varchar(100),                      
    @Book_IDs nvarchar(Max),        
    @Candidate_or_Employee int,      
    @Candidate_Employee_Id bigint = NULL,                  
    @FromDate datetime = NULL,                         
    @ToDate datetime = NULL,      
    @DueFromDate datetime = NULL,      
    @DueToDate datetime = NULL,    
    @ReturnStatus bit = NULL              
    AS              
    BEGIN       
        IF (@Book_Type=''ISSUE'')                        
        BEGIN        
            SELECT [Issue_Book_Id],        
                   BI.[Book_Id],        
                   CONVERT(varchar(10), Issue_Date, 101) AS Date,      
                   CONVERT(varchar(10), Due_Date, 103) AS DueDate,      
                   [Is_Returned],        
                   [Return_Date],        
                   [Candidate_Employee_Id],             
                   [Book_Title] AS Book,    
                   CASE WHEN Is_Returned = 0 THEN ''Not Returned'' ELSE ''Returned'' END AS Status,    
                   CASE WHEN Candidate_or_Employee = 0 THEN ''Student'' ELSE ''Employee'' END AS Candidate_or_Employee,        
                   CASE WHEN Candidate_or_Employee = 0 THEN 
                        (Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname)         
                   ELSE (Employee_FName + '' '' + Employee_LName) 
                   END AS Name        
            FROM [Tbl_LMS_Issue_Book] BI        
            INNER JOIN Tbl_AddBooks B ON BI.Book_Id = B.Book_Id          
            LEFT JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = BI.Candidate_Employee_Id        
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = BI.Candidate_Employee_Id       
            WHERE CONVERT(varchar(10), Issue_Date, 101) BETWEEN                  
                  ISNULL(@FromDate, (SELECT MIN(CONVERT(varchar(10), Issue_Date, 101)) FROM Tbl_LMS_Issue_Book WHERE Issue_Book_Status = 0)) 
                  AND                    
                  ISNULL(@ToDate, (SELECT MAX(CONVERT(varchar(10), Issue_Date, 101)) FROM Tbl_LMS_Issue_Book WHERE Issue_Book_Status = 0))
              AND (BI.Candidate_Employee_Id = @Candidate_Employee_Id OR @Candidate_Employee_Id IS NULL)      
              AND BI.Book_Id IN (SELECT [value] FROM dbo.Split(@Book_IDs, '',''))         
              AND (BI.Is_Returned = @ReturnStatus OR @ReturnStatus IS NULL)    
              AND BI.Issue_Book_Status = 0;                    
        END                          
    END';
END;
