IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Subjects_By_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Subjects_By_Department]
        (
            @Course_Department BIGINT
        )
        AS
        BEGIN

            SELECT        
                DS.Department_Subject_Id AS DepSubID, 
                dbo.Tbl_New_Course.Course_Name,
                dbo.Tbl_New_Course.Course_code
            FROM            
                dbo.Tbl_Department_Subjects AS DS 
                INNER JOIN dbo.Tbl_New_Course 
                ON DS.Subject_Id = dbo.Tbl_New_Course.Course_Id
            WHERE        
                (DS.Course_Department_Id = @Course_Department) 
                AND (DS.Department_Subject_Status = 0) 
                AND (dbo.Tbl_New_Course.Course_Prequisite = 0) 
                AND (dbo.Tbl_New_Course.Delete_Status = 0) 
                AND (dbo.Tbl_New_Course.Active_Status = ''Active'')
        END
    ')
END
