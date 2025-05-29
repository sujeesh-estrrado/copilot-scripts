IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Course_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_Get_All_Course_List] 
    (@facultyid BIGINT = 0)                  
AS                                
BEGIN                                
    IF (@facultyid = 0)
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
            Tbl_Course_Level CL ON CL.Course_Level_Id = C.Faculty_Id                                  
        WHERE 
            C.Delete_Status = 0 
        ORDER BY 
            Course_Id DESC    
    END 
    ELSE
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
            Tbl_Course_Level CL ON CL.Course_Level_Id = C.Faculty_Id     
        INNER JOIN 
            Tbl_Department EA ON CL.Course_Level_Id = EA.GraduationTypeId                             
        WHERE 
            C.Delete_Status = 0 
            AND EA.GraduationTypeId = @facultyid 
        ORDER BY 
            Course_Id DESC  
    END
END
    ')
END
