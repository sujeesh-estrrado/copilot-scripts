IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[SP_GetAll_Course ]                                
@Course_Department_Id BIGINT    ,
@Course_Batch_Id      BIGINT
AS                                
  
BEGIN                                  
--     SELECT  
--	 CL.Course_Level_Id   AS Course_Id ,
--	 CL.Course_Level_Name AS Courses

	 
--	 FROM       Tbl_Course_Level CL
--	 INNER JOIN Tbl_Department D ON CL.Course_Level_Id=D.GraduationTypeId
--	 WHERE D.Department_Id=@Course_Department_Id
--order by CL.Course_Level_Name 

      
	   SELECT       CL.Course_Id   AS Course_Id ,
	 CL.Course_Name AS Courses      
FROM                     
                         dbo.Tbl_New_Course AS CL 
						 INNER JOIN Tbl_Department_Subjects DS ON CL.Course_Id=DS.Subject_Id
 where DS.Course_Department_Id=@Course_Department_Id 

  

END 
');
END;