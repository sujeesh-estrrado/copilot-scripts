IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Patner_course_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Patner_course_mapping](@flag bigint=0,@puid bigint=0,@course_id bigint=0,@gradeid bigint=0,  
@resitgrade bigint=0,@id bigint=0,@accesscode bigint=0)  
as  
begin  
  
if(@flag =1)  
 begin  
  insert into Parent_university_Course_Mapping (Course_id,Parent_university_Grade,Parent_university_ResitGrade,Parent_university_Id,delete_status,AssessmentCode)  
  values  
  (@course_id,@gradeid,@resitgrade,@puid,0,@accesscode)  
end  
if(@flag =2)  
 begin  
   select * from Parent_university_Course_Mapping where Course_id=@course_id and delete_status=0  
 end  
   
 if(@flag=3)  
  begin  
   select * from Parent_university_Course_Mapping where CoursePM_Id=@id  
  end  
   
 if(@flag=4)  
  begin  
  if not exists( select * from Parent_university_Course_Mapping where Course_id=@course_id and delete_status=0)
  begin
   insert into Parent_university_Course_Mapping (Course_id,Parent_university_Grade,Parent_university_ResitGrade,Parent_university_Id,delete_status,AssessmentCode)  
  values  
  (@course_id,@gradeid,@resitgrade,@puid,0,@accesscode)
  end
  else
  begin
   update Parent_university_Course_Mapping set Parent_university_Grade=@gradeid , Parent_university_ResitGrade=@resitgrade  
   , Parent_university_Id=@puid,AssessmentCode=@accesscode where Course_id=@course_id  
   end
  end  
  
  if(@flag=5)  
   begin  
    delete from Parent_university_Course_Mapping where Course_id=@course_id  
  end  
end
');
END