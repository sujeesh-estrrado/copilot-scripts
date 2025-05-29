IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Subjects_By_Department_andParentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Subjects_By_Department_andParentId]
        (
            @Course_Department BIGINT,
            @Parent_Subject_Id BIGINT
        )  
        AS  
        BEGIN  
            
            SELECT        
                DS.Department_Subject_Id AS DepSubID, 
                C.Course_Name,
                C.Course_Id
            FROM            
                dbo.Tbl_Department_Subjects AS DS 
                INNER JOIN dbo.Tbl_New_Course AS C 
                ON DS.Subject_Id = C.Course_Id
            WHERE        
                (C.Active_Status = ''Active'') 
                AND (C.Delete_Status = 0) 
                AND (DS.Course_Department_Id = @Course_Department) 
                AND (DS.Department_Subject_Status = 0)

        END
    ')
END
