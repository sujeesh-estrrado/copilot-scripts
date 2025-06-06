IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetAll_News_By_Emp_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetAll_News_By_Emp_Id]  
            @Emp_Id BIGINT  
        AS  
        BEGIN  
            SET NOCOUNT ON;
            
            SELECT DISTINCT  
                n.News_id,    
                n.News_Title,    
                n.News_Desc,    
                n.News_Date,
                n.Emp_Id,
                ToName = STUFF(
                    (SELECT DISTINCT '','' + C.Class_Name    
                     FROM LMS_Tbl_Class C      
                     INNER JOIN LMS_Tbl_News_Send NS ON C.Class_Id = NS.Class_Id      
                     WHERE C.Class_Id = NS.Class_Id 
                     AND NS.News_id = n.News_id    
                     FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, ''''
                ),  
                CASE WHEN n.Emp_Id = @Emp_Id THEN ''Me''     
                     ELSE E.Employee_FName 
                END AS FromName     
            FROM LMS_Tbl_News n     
            INNER JOIN LMS_Tbl_News_Send NS ON NS.News_id = n.News_id    
            INNER JOIN LMS_Tbl_Emp_Class EC ON EC.Class_Id = NS.Class_Id    
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = n.Emp_Id    
            INNER JOIN LMS_Tbl_Class C ON C.Class_Id = NS.Class_Id     
            WHERE n.Emp_Id = @Emp_Id OR EC.Class_Id = NS.Class_Id    
            ORDER BY News_id DESC;  
        END
    ')
END
