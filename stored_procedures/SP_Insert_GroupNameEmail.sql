IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_GroupNameEmail]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[SP_Insert_GroupNameEmail]                                      
(                                      
  @GroupName  varchar (max),                                      
  @Type   varchar (50)='''',                                      
  @Status  bigint=0,                                      
  @Department_Id   bigint=0 ,                                      
  @Intake_Id   bigint=0 ,            
  @Candidate_Nationality bigint=0,            
  @Candidate_Gender varchar (50)='''',            
  @Candidate_Dob bigint=0            
)                                      
As                                      
                                      
Begin                                 
 Insert into Tbl_GroupEmail(GroupName,                                      
   Type, Status,  Department_Id, Intake_Id,Created_date,            
   Candidate_Nationality,Candidate_Gender,Candidate_Dob ,Delete_status           
   )                                      
 values( @GroupName,@Type,@Status,@Department_Id,@Intake_Id,getdate(),            
 @Candidate_Nationality,@Candidate_Gender,@Candidate_Dob,0)                                      
                                       
                   
 Select SCOPE_IDENTITY()                          
                   
End 
   ')
END;
