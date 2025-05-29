IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_getupcomingintakes]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[sp_getupcomingintakes]    
(    
@batch_id bigint=0,    
@flag bigint=0,    
@intake bigint=0)      
as      
begin      
 if(@flag=0)      
 begin      
  select * from tbl_course_batch_duration where batch_from>getdate() and batch_delstatus=0      
 end      
 if(@flag=1)      
 begin      
  select * from tbl_course_batch_duration     
  where batch_from>getdate() and batch_delstatus=0 and Duration_Id in (select Duration_Id from tbl_course_batch_duration where batch_id=@batch_id)      
 end      
 if(@flag=2)      
 begin      
    if exists(select * from Tbl_Configuration_Settings where Config_Type=''AdmissionFeeMapping'' and Config_Status=''true'')      
begin  
  select * from tbl_course_batch_duration C     
  left join fee_group f on f.programintakeID=C.Batch_Id and F.active=1 and f.Promotional=0     
  where C.Batch_DelStatus=0     
   and C.batch_to>getdate()     
   and C.duration_id=@batch_id    
   end  
   else  
   begin  
     select * from tbl_course_batch_duration C     
  left join fee_group f on f.programintakeID=C.Batch_Id and F.active=1 and f.Promotional=0     
  where C.Batch_DelStatus=0     
   and C.batch_to>getdate()     
   and C.duration_id=@batch_id    
   end  
   end  
     
 if(@flag=3)      
 begin      
      
  select * from tbl_course_batch_duration C     
  left join fee_group f on f.programintakeID=C.Batch_Id and F.active=1 and f.Promotional=0     
  where  C.Batch_DelStatus=0     
   and(     
    (C.batch_to>getdate()     
    and C.duration_id=@batch_id and f.Promotional=0   )    
    or Batch_Id =@intake    
    )    
    
    
 end    
end
    ')
END;
