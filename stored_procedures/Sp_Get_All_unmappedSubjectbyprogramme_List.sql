IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_unmappedSubjectbyprogramme_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_Get_All_unmappedSubjectbyprogramme_List]   
(@facultyid bigint=0,  
@Programmeid bigint=0,  
@Durationid bigint=0  
)                   
                    
AS                                  
                                  
BEGIN                                  
     if(@facultyid=0)  
  begin                             
with Level1 as(SELECT DISTINCT   
C.Course_Id,C.Course_code,C.Course_Name,DS.Course_Department_Id,CL.Course_Level_Name,CL.Course_Level_Id                             
 FROM Tbl_New_Course C  inner join   Tbl_Course_Level CL on Cl.Course_Level_Id=C.Faculty_Id       
 inner join Tbl_Department EA on CL.Course_Level_Id=EA.GraduationTypeId    
 inner join Tbl_Department_Subjects DS on DS.Course_Department_Id=EA.Department_Id  
 where C.Delete_Status=0  and EA.GraduationTypeId=@facultyid and C.Course_Id not  in (select Department_Subjects_Id from Tbl_Semester_Subjects where Duration_Mapping_Id!=@Durationid))  
  
 SELECT distinct Course_Id,Course_code,Course_Name,Course_Department_Id,Course_Level_Name,Course_Level_Id   
from Level1 where Course_Department_Id=@Programmeid and   
Course_Id in(select Subject_Id from Tbl_Department_Subjects where Course_Department_Id=@Programmeid)          
end  
else  
begin  
  
with Level1 as(SELECT DISTINCT   
C.Course_Id,C.Course_code,C.Course_Name,DS.Course_Department_Id,CL.Course_Level_Name,CL.Course_Level_Id                             
 FROM Tbl_New_Course C  inner join   Tbl_Course_Level CL on Cl.Course_Level_Id=C.Faculty_Id       
 inner join Tbl_Department EA on CL.Course_Level_Id=EA.GraduationTypeId    
 inner join Tbl_Department_Subjects DS on DS.Course_Department_Id=EA.Department_Id  
 where C.Delete_Status=0  and EA.GraduationTypeId=@facultyid and C.Course_Id not   in (select Department_Subjects_Id from Tbl_Semester_Subjects where Duration_Mapping_Id!=@Durationid))  
  
 SELECT distinct Course_Id,Course_code,Course_Name,Course_Department_Id,Course_Level_Name,Course_Level_Id   
from Level1 where Course_Department_Id=@Programmeid and   
Course_Id   
in(select Subject_Id from Tbl_Department_Subjects where Course_Department_Id=@Programmeid)  
--not in(select Department_Subjects_Id from Tbl_Semester_Subjects where Duration_Mapping_Id=28)  
  
end  
end  
    ');
END
