IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_student_request_byIcno_and_course_code]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_student_request_byIcno_and_course_code](@icno varchar(100),@subject varchar(200),@flag bigint,@subjectname varchar(max))  
as begin  
declare @id bigint =(Select Candidate_Id from Tbl_Candidate_Personal_Det where AdharNumber=@icno and (active=2 or active=3))  
declare @subjectid bigint=(select Course_Id from Tbl_New_Course where Course_code=@subject and Delete_Status=0 and Active_Status=''Active''   
and Course_Name=@subjectname);  
if(@flag=1)  
begin  
  if(@id!=0 and @subjectid!=0)  
  begin  
    if not exists (select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subjectid and delete_status=0 )  
     begin  
      insert into Tbl_Student_Subject_Mapping(Student_id,Subject_id,Subject_status,delete_status,Create_date)      
      values(@id,@subjectid,2,0,GETDATE())      
     end  
  else  
  begin  
  update Tbl_Student_Subject_Mapping set Subject_status=2 where Student_id=@id and Subject_id=@subjectid and delete_status=0  
  
  end  
  end  
end  
if(@flag=2)  
begin  
if(@id!=0 and @subjectid!=0)  
 begin  
  if  exists (select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subjectid and delete_status=0  and Subject_status!=2)  
   begin  
    update Tbl_Student_Subject_Mapping set delete_status=1 where Student_id=@id and Subject_id=@subjectid and Subject_status!=2  
   end  
 end  
end  
  if(@flag=3)  
begin  
  if(@id!=0 and @subjectid!=0)  
  begin  
    if not exists (select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subjectid and delete_status=0 and Subject_status!=2)  
     begin  
      insert into Tbl_Student_Subject_Mapping(Student_id,Subject_id,Subject_status,delete_status,Create_date)      
      values(@id,@subjectid,1,0,GETDATE())      
     end  
   
  end
  end
end

   ')
END;
