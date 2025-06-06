IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_Lead_NewPersonalDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_Lead_NewPersonalDetails]
(
    @candidate_id bigint,
    @Candidate_Fname  varchar (max),        
    @Candidate_Lname   varchar (max),        
    @Candidate_Nationality   varchar (max),        
    @AdharNumber   varchar (max) ,        
    @candidate_country   varchar (100),          
    @SourceofInformation varchar (max),
    @dob varchar(50),
    @Typeofstudent varchar(50),
    @agentid bigint,
    @CounselorEmployee_id bigint,
    @leadstatusid bigint
)
 as
 begin
   update Tbl_Lead_Personal_Det
   set Candidate_Fname=@Candidate_Fname,Candidate_Lname=@Candidate_Lname,Candidate_Dob=@dob,
       Candidate_Nationality=@Candidate_Nationality,AdharNumber=@AdharNumber,Residing_Country=@candidate_country,SourceofInformation=@SourceofInformation,
       Agent_ID=@agentid,TypeOfStudent=@Typeofstudent,CounselorEmployee_id=@CounselorEmployee_id,LeadStatus_Id=@leadstatusid
   where Candidate_Id=@candidate_id

end

   ')
END;
