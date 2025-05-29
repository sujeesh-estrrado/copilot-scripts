IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Department_Faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAll_Course_Department_Faculty]                                
    @Faculty_Id BIGINT                       
AS                                 
BEGIN                         
    SELECT 
        0 AS Course_Department_Id, 
        ''--Select--'' AS Department_Name,
       ISNULL(NULL, '''') AS Course_Category_Name, 
        NULL AS Course_Category_Id,
        NULL AS Course_Department_Description, 
        NULL AS Course_Department_Date
    UNION ALL
    SELECT       
        dbo.Tbl_Course_Department.Department_Id AS Course_Department_Id,                                
        dbo.Tbl_Department.Department_Name, 
        dbo.Tbl_Course_Category.Course_Category_Name, 
        dbo.Tbl_Course_Department.Course_Category_Id,
        dbo.Tbl_Course_Department.Course_Department_Description,                                
        dbo.Tbl_Course_Department.Course_Department_Date                                
    FROM                     
        dbo.Tbl_Department 
    INNER JOIN                                
        dbo.Tbl_Course_Department 
        ON dbo.Tbl_Department.Department_Id = dbo.Tbl_Course_Department.Department_Id 
    INNER JOIN                                
        dbo.Tbl_Course_Category 
        ON dbo.Tbl_Course_Department.Course_Category_Id = dbo.Tbl_Course_Category.Course_Category_Id  
    INNER JOIN 
        [Tbl_Course_Level] 
        ON Tbl_Department.GraduationTypeId = Tbl_Course_Level.Course_Level_Id                             
    WHERE 
        Tbl_Course_Department.Course_Department_Status = 0 AND                                
        Tbl_Course_Category.Course_Category_Status = 0 AND                                
        Tbl_Department.Department_Status = 0 AND                                
        [Tbl_Course_Level].Course_Level_Id = @Faculty_Id
    ORDER BY 
        Department_Name                              
END
');
END;