IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetGroupCoursebyId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetGroupCoursebyId]-- 6
    
(@groupcoursecodeid BIGINT)    
    
AS BEGIN    
    
SELECT gc.GroupCourseCodeId,gc.GroupCourseCode,gc.GroupCourseName,gc.GroupCourseDescription,gc.MajorCode,    
gc.Awards,gc.ProgramCodeId,gc.ProviderCodeId,gc.GraduationTypeId,gc.ReqCreditHours,gc.Qualification,D.Department_Name,    
--cc.Course_Category_Name,pm.ProviderName,
dgc.Department_Id   
FROM dbo.Tbl_Group_Course gc inner join dbo.Tbl_Dep_GroupCourse dgc on gc.GroupCourseCodeId=dgc.GroupCourseCodeId    
inner join dbo.Tbl_Department D on D.Department_Id=dgc.Department_Id 
--inner join Tbl_Course_Category cc on cc.Course_Category_Id=gc.ProgramCodeId    
--inner join Tbl_ProviderMaster pm on pm.ProviderId=gc.ProviderCodeId    
    
    
    
 WHERE gc.GroupCourseCodeId=@groupcoursecodeid    
   
  
END
');
END;