-- Check if the stored procedure exists
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[proc_Insert_CommissionSettings]') 
    AND type = N'P'
)
BEGIN
    -- Create the stored procedure
    EXEC('
    CREATE procedure [dbo].[proc_Insert_CommissionSettings]     
(    
@Course_Id bigint,    
@Fee_Code_Id bigint,    
@Feehead_Id bigint,    
@Commission_Amount decimal,    
@EmpORAgent_Status bigint,    
@Employee_Id bigint,    
@Agent_ID bigint,  
@Remarks varchar(MAX),
@ItemDescription varchar(200),
@IntakeId bigint,
@Minimum_Amount decimal
)    
AS begin    
if(@EmpORAgent_Status=1)    
begin    
  IF EXISTS(Select * from [dbo].[Tbl_Commission_Settings] where Course_Id=@Course_Id and   IntakeId=@IntakeId and Employee_Id=@Employee_Id and Fee_Code_Id=@Fee_Code_Id and-- Feehead_Id=@Feehead_Id and
    Delete_Status=0)  
  BEGIN        
  RAISERROR(''Commission already exists for Same Fee Group.'',16,1);        
  END    
  else  
  begin      
  insert into [dbo].[Tbl_Commission_Settings] ([Course_Id],[Fee_Code_Id],[Feehead_Id],[Commission_Amount],[EmpORAgent_Status],
  [Employee_Id],[Agent_ID],[Delete_Status],[Remarks],[ItemDescription],[IntakeId],[Created_Date],Minimum_Amount)    
  values (@Course_Id,@Fee_Code_Id,@Feehead_Id,@Commission_Amount,1,@Employee_Id,0,0,@Remarks,@ItemDescription,@IntakeId,getdate(),@Minimum_Amount) 
     select scope_identity()
   
  end  
end    
if(@EmpORAgent_Status=2)    
  begin    
  IF EXISTS(Select * from [dbo].[Tbl_Commission_Settings] where Course_Id=@Course_Id and   IntakeId=@IntakeId and  Fee_Code_Id=@Fee_Code_Id and
  --where  Course_Id=@Course_Id and Fee_Code_Id=@Fee_Code_Id and Feehead_Id=@Feehead_Id and  IntakeId=@IntakeId and
   Agent_ID=@Agent_ID and Delete_Status=0) 
  BEGIN        
  RAISERROR(''Commission already exists for Same Fee Group.'',16,1);        
  END   
  else  
  begin  
   insert into [dbo].[Tbl_Commission_Settings] ([Course_Id],[Fee_Code_Id],[Feehead_Id],[Commission_Amount],[EmpORAgent_Status],
   [Employee_Id],[Agent_ID],[Delete_Status],[Remarks],[ItemDescription],[IntakeId],[Created_Date],Minimum_Amount)    
   values (@Course_Id,@Fee_Code_Id,@Feehead_Id,@Commission_Amount,2,0,@Agent_ID,0,@Remarks,@ItemDescription,@IntakeId,getdate(),@Minimum_Amount)   
   select scope_identity()
   end   
end 
   declare @comisionid bigint
   declare @feeentryid bigint
   
   create table #temp (id bigint primary key identity(1,1),Fee_Entry_Id bigint)
   INSERT INTO #temp(Fee_Entry_Id)select distinct Fee_Entry_Id from tbl_Fee_entry_main where 
   IntakeId=@IntakeId and Fee_Code_Id=@Fee_Code_Id and FeeHeadId=@Feehead_Id and ItemDescription=@ItemDescription 
   
declare @count bigint        
declare @totalcount bigint      

set @count=1        
set @totalcount=(select count(id) FROM #temp)        
print @totalcount 
       
while(@count<=@totalcount)        
begin        
set @feeentryid=(select distinct Fee_Entry_Id from #temp where id=@count)

if  exists(select distinct Commission_Setting_Id from dbo.Tbl_Commission_Settings
where Course_Id=@Course_Id and Fee_Code_Id=@Fee_Code_Id  and Feehead_Id=@Feehead_Id
 and ItemDescription=@ItemDescription and IntakeId=@IntakeId and Delete_Status=0)  
begin
set @comisionid= (select distinct isnull(Commission_Setting_Id,0) as Commission_Setting_Id from dbo.Tbl_Commission_Settings
where Course_Id=@Course_Id and Fee_Code_Id=@Fee_Code_Id  and Feehead_Id=@Feehead_Id and ItemDescription=@ItemDescription and
IntakeId=@IntakeId and Delete_Status=0)     
 
print ''1''              
update dbo.Tbl_Fee_Entry_Main set Commision_Settings_Id=@comisionid where Fee_Entry_Id=@feeentryid 
end 
       
else        
begin        
print ''2''             
end        
        
set @count=@count+1        
end
end
    ')
END
