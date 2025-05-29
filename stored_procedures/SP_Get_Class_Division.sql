IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Class_Division]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Class_Division]
AS
BEGIN
SELECT CC.Course_Category_Name,CC.Course_Category_Name+''-''+D.Department_Name as SubDept,CD.*,D.*,CL.*    
FROM         Tbl_Course_Department CD INNER JOIN
                      Tbl_Department D ON CD.Department_Id = D.Department_Id INNER JOIN
                      Tbl_Course_Category CC ON CD.Course_Category_Id = CC.Course_Category_Id INNER JOIN
                      Tbl_Course_Level CL ON CC.Course_level_Id = CL.Course_Level_Id
WHERE CD.Course_Department_Status=0 AND D.Department_Status=0 AND CL.Course_Level_Status=0 AND CC.Course_Category_Status=0
ORDER By CC.Course_Category_Id
END
    ');
END;
