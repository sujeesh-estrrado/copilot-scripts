IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Agent_CommissionGroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Agent_CommissionGroup]          
          
(          
@Flag bigint=0,          
@Commission_GroupId bigint=0,          
@GroupName varchar(MAX)='''',          
@FacultyId bigint=0,          
@programid bigint=0,          
@IntakeId bigint=0,          
@Created_By bigint=0,          
@Updated_By bigint=0,          
@International_Amount decimal(18,2)=0,          
@Local_Amount decimal(18,2)=0,     
@GroupType bigint=0,  
@id int =0 output       
)                        
AS                        
                            
                        
BEGIN            
if(@Flag=0)          
begin          
 if exists(select * from Tbl_CommissionGroup where GroupName=@GroupName and IntakeId=@IntakeId and Delete_Status=0 and ActiveStatus=0 and GroupType=@GroupType)             
 begin          
          
 Update dbo.Tbl_CommissionGroup set          
  GroupName=@GroupName,          
  FacultyId=@FacultyId,          
  ProgrammeId=@programid,          
  IntakeId=@IntakeId,          
  International_Amount=@International_Amount,          
  Local_Amount=@Local_Amount,          
  Updated_By=@Updated_By,          
  Updated_Date=getdate(),  
  GroupType=@GroupType  
  where Delete_Status=0 and GroupName=@GroupName            
               
  end            
  else          
  begin          
  Insert into Tbl_CommissionGroup(GroupName,FacultyId,ProgrammeId,IntakeId,International_Amount,          
    Local_Amount,GroupType,Created_Date,Delete_Status,Created_By,ActiveStatus)          
  values(@GroupName,@FacultyId,@programid,@IntakeId,@International_Amount,@Local_Amount,@GroupType,getdate(),0,@Created_By,0)          
  end          
end          
          
if(@Flag=1)          
begin          
          
          
 Update dbo.Tbl_CommissionGroup           
 set          
  GroupName=@GroupName,          
  FacultyId=@FacultyId,          
  ProgrammeId=@programid,          
  IntakeId=@IntakeId,          
  International_Amount=@International_Amount,          
  Local_Amount=@Local_Amount,          
  Updated_Date=getdate(),          
  Updated_By=@Updated_By ,  
  GroupType=@GroupType  
 where Commission_GroupId=@Commission_GroupId            
               
end            
           
if(@Flag=2)          
begin          
 select GroupName,FacultyId,ProgrammeId,IntakeId,International_Amount,Local_Amount ,GroupType         
 from Tbl_CommissionGroup where Commission_GroupId=@Commission_GroupId          
end          
 if(@Flag=3)          
begin          
 select Commission_GroupId,GroupName,FacultyId,ProgrammeId,IntakeId,International_Amount,Local_Amount ,GroupType         
 from Tbl_CommissionGroup           
 where FacultyId=@FacultyId and ProgrammeId=@programid and IntakeId=@IntakeId and GroupType=@GroupType  
end       
 if (@Flag=4)--Insert into [fee_group]          
 begin          
          
Insert into Tbl_CommissionGroup(GroupName,FacultyId,ProgrammeId,IntakeId,International_Amount,GroupType ,         
    Local_Amount,Created_Date,Delete_Status,Created_By,ActiveStatus)          
  values(@GroupName,@FacultyId,@programid,@IntakeId,@International_Amount,@GroupType,@Local_Amount,getdate(),0,@Created_By,0)             
    SET @id=SCOPE_IDENTITY()          
    select  @id as FeeGroup           
 end       
  if (@Flag=5)--Get CommissionGroups and Intake by IntakeMasterID and Programme       
 begin          
          
  select Batch_Id,Batch_Code,Commission_GroupId,groupname,IntakeMasterID,intake_no,GroupType,         
    CBD.Duration_Id,D.Department_Name, D.Course_Code,CL.Course_Level_Name,CL.Course_Level_Id as FacultyId,           
                         FG.International_Amount, FG.Local_Amount        
        
  from Tbl_CommissionGroup as FG join Tbl_Course_Batch_Duration as CBD on FG.IntakeId = CBD.Batch_Id        
  join Tbl_Department as D on D.Department_Id = CBD.Duration_Id      
  left join Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId    
  where   FG.Delete_Status=0 and  (IntakeId is not null or IntakeId =0 ) and  ActiveStatus=0      
     and Department_Id=@programid and  IntakeMasterID = @IntakeId        
  order by CBD.IntakeMasterID,Department_Name           
 end    
 if (@Flag=6)    
 begin          
  select Batch_Id,Batch_Code, CBD.Duration_Id,D.Department_Name, D.Course_Code ,CL.Course_Level_Name,CL.Course_Level_Id as FacultyId    
  from Tbl_Course_Batch_Duration as CBD     
  join Tbl_Department as D on D.Department_Id = CBD.Duration_Id      
  left join Tbl_Course_Level CL on CL.Course_Level_Id=D.GraduationTypeId    
  where D.Active_Status =''Active'' and D.Delete_Status =0 and         
   CBD.Batch_Id not in(select IntakeId from Tbl_CommissionGroup where Delete_Status=0  and ActiveStatus =0 )         
    and IntakeMasterID = @IntakeId         
  order by Department_Name           
 end    
     
end 
    ')
END
