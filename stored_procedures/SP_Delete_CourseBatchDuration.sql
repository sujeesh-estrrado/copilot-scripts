IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_CourseBatchDuration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_CourseBatchDuration]           
(@Batch_Id bigint,
@Flag int=0)            
AS            
begin        
declare @intake bigint      
declare @batch bigint      
      
set @intake=(select count(IntakeId) from tbl_fee_entry where IntakeId=@Batch_Id)      
set @batch=(SELECT count(Batch_Id) from dbo.tbl_New_Admission where Batch_Id=@Batch_Id)       
      
if(@intake=0 and @batch=0)      
begin       
     if not exists (select * from  Tbl_Course_Duration_PeriodDetails  where Batch_Id=@Batch_Id)
     begin            
update Tbl_Course_Batch_Duration set Batch_DelStatus=1            
WHERE Batch_Id=@Batch_Id             
update Tbl_Course_Duration_PeriodDetails set Duration_Period_Active_Status=1 where Batch_Id=@Batch_Id       
       
end        
      
 end    
End 
    ')
END
