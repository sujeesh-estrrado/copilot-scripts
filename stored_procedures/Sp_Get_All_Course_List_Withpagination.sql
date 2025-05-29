IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Course_List_Withpagination]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_All_Course_List_Withpagination] 
    (@facultyid BIGINT = 0, @PageSize BIGINT = 0, @CurrentPage BIGINT = 0, @flag BIGINT = 0)                   
AS                                  
BEGIN  
    IF (@flag = 1)  
    BEGIN                             
        SELECT DISTINCT   
            C.Course_Id,
            C.Course_code,
            C.Course_Name,
            C.Course_GPS AS GPA_Flag,
            C.ContactHours,
            CASE WHEN C.Course_Type = ''0'' THEN ''N/A'' ELSE C.Course_Type END AS versions,
            C.Course_credit,
            C.Active_Status,
            CL.Course_Level_Name,
            CL.Course_Level_Id                              
        FROM 
            Tbl_New_Course C  
        INNER JOIN   
            Tbl_Course_Level CL ON Cl.Course_Level_Id = C.Faculty_Id                                    
        WHERE 
            C.Delete_Status = 0 
        ORDER BY 
            Course_Id DESC  
        OFFSET @PageSize * (@CurrentPage - 1) ROWS      
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
    END   
    ELSE  
    BEGIN  
        SELECT  
            COUNT(C.Course_Id) AS count                          
        FROM 
            Tbl_New_Course C  
        INNER JOIN   
            Tbl_Course_Level CL ON Cl.Course_Level_Id = C.Faculty_Id                                    
        WHERE 
            C.Delete_Status = 0   
    END  
END  
    ')
END
