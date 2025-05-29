IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Request_subject_by_student]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Request_subject_by_student](@id  bigint=0,@subject bigint=0,@flag bigint=0,@mapid bigint=0)    
as    
begin    
--status =1 pending    
--status =2 approved    
--status =3 rejected    
if(@flag=1) -- for student request   
begin    
 insert into Tbl_Student_Subject_Mapping(Student_id,Subject_id,Subject_status,delete_status,Create_date)    
 values(@id,@subject,1,0,GETDATE())    
 end    
 if(@flag=2)    
 begin    
 update Tbl_Student_Subject_Mapping set Subject_status=@id where Student_id=@id and Subject_id=@subject and delete_status=0    
    
 end    
 if(@flag=3)    
 begin    
    
 update Tbl_Student_Subject_Mapping set delete_status=1 where Student_id=@id and Subject_id=@subject    
 end    
 if(@flag=4)    
 begin    
    
 select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subject and delete_status=0    
 end    
  
  if(@flag=5)    
 begin    
  if not exists(  
 select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subject and delete_status=0 )  
 begin  
  insert into Tbl_Student_Subject_Mapping(Student_id,Subject_id,Subject_status,delete_status,Create_date)    
 values(@id,@subject,2,0,GETDATE())    
 end    
 else  
 begin  
   update Tbl_Student_Subject_Mapping set Subject_status=2 where Student_id=@id and Subject_id=@subject and delete_status=0    
  
 end   
   
 end  
 if(@flag=6)    
 begin    
    
 select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subject and delete_status=0   and Subject_status=1  
 end  
  if(@flag=7)    
 begin    
    
 select * from Tbl_Student_Subject_Mapping where Student_id=@id and Subject_id=@subject and delete_status=0   and Subject_status=2 
 end  
 end
    ')
END;
