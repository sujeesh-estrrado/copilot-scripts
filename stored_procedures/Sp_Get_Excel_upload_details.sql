IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Excel_upload_details]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_Excel_upload_details] --'',10,1,2  
    (@name VARCHAR(MAX), @pagesize BIGINT, @currpage BIGINT, @flag BIGINT)  
    AS  
    BEGIN  
    IF (@flag = 1)  
    BEGIN  
        SELECT COUNT(log_id) 
        FROM Tbl_Excel_upload_log 
        WHERE delete_status = 0 
        AND (Excel_name = @name OR @name = '''')  
    END  
    ELSE  
    BEGIN  
        SELECT 
            eul.Log_id,
            Excel_name,
            eul.Source,
            eul.source_name,
            eul.total_count AS count,
            CASE 
                WHEN ISNULL(e.Employee_FName, '''') + '' '' + ISNULL(e.Employee_LName, '''') = '' '' 
                THEN ''Admin'' 
                ELSE ISNULL(e.Employee_FName, '''') + '' '' + ISNULL(e.Employee_LName, '''') 
            END AS Username,
            Upload_date 
        FROM 
            Tbl_Excel_upload_log eul 
            LEFT JOIN Tbl_Employee_User eu ON eu.User_Id = eul.Uploaded_by   
            LEFT JOIN Tbl_Employee e ON e.Employee_Id = eu.Employee_Id  
        WHERE 
            eul.delete_status = 0
        ORDER BY 
            log_id DESC
        OFFSET @pagesize * (@currpage - 1) ROWS  
        FETCH NEXT @pagesize ROWS ONLY  
    END  
    END
    ')
END
