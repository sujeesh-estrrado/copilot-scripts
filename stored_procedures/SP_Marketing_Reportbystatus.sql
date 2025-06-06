IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_Reportbystatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[SP_Marketing_Reportbystatus] --1,0,0,0
(
@flag bigint =0,
@MarketingStaff bigint=0,
@programmeType bigint=0,
@program bigint=0,
@reportflag bigint=0

)
AS      
BEGIN 
truncate table temp;
declare @NEW bigint
declare @FOLLOWUP bigint 
 declare @APPLIED bigint 
declare @NOTQUALIFIED bigint  
declare @OFFERLETTERSENT bigint  
declare @NOTINTERESTED  bigint  
declare @WAITINGFORFINALRESULT  bigint  
declare @NOTDECIDEDINANYCOURSE  bigint  
declare @NEVERANSWEREMAIL bigint  
declare  @NEVERANSWERCALL  bigint  
declare @LEAVEVOICEMESSAGE  bigint  
declare  @WAITINGFORCERTIFICATESDOCUMENTS  bigint  
declare  @WAITINGFORNOCLETTERFORELIGIBILITY  bigint  
declare  @OFFERLETTERBRINGPROCESSBYADMISSION  bigint 
declare @Totalrecords Bigint

set @NEW=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''pending'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))

set @FOLLOWUP=(select  Count(distinct F.Candidate_Id) from Tbl_FollowUp_Detail F
left join  Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))

 set @APPLIED=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
 left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
and (ApplicationStatus=''pending''or ApplicationStatus=''Submited'' or ApplicationStatus=''Approved'' or 
 ApplicationStatus=''Verified'' or ApplicationStatus=''Preactivated'' or 
ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Preactivated''))

set @NOTQUALIFIED=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
 left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
and (ApplicationStatus=''rejected''))

set @OFFERLETTERSENT=(select Count(distinct D.Candidate_Id) from Tbl_Offerlettre O
left join  Tbl_Candidate_Personal_Det D on O.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))

set @NOTINTERESTED =(select Count(distinct F.Candidate_Id) from  Tbl_FollowUp_Detail F
left join tbl_approval_log L on F.Candidate_Id=L.Candidate_Id 
left join  Tbl_Candidate_Personal_Det D on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
and Offerletter_status=0 or Respond_Type=''NOT INTERESTED'')

set @WAITINGFORFINALRESULT =(select Count(distinct P.Candidate_Id) from Tbl_Candidate_Personal_Det P 
left join Tbl_FollowUp_Detail D on D.Candidate_Id=P.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=P.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=P.CounselorEmployee_id 
where (ApplicationStatus=''Conditional_Admission'' or Action_to_Be_Taken=''WAITING FOR STUDENT RESULT'') 
and(@MarketingStaff=P.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))

set @NOTDECIDEDINANYCOURSE =(select Count(distinct F.Candidate_Id) from  Tbl_FollowUp_Detail F
left join tbl_Candidate_Personal_Det D on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
 where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
and Respond_Type=''NOT DECIDED YET'' or D.New_Admission_Id=0 or D.New_Admission_Id is null )


set @NEVERANSWEREMAIL=(select Count(distinct F.Candidate_Id) from  Tbl_FollowUp_Detail F
left join tbl_Candidate_Personal_Det D on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
 where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)and Action_to_Be_Taken=''Email'')

 set  @NEVERANSWERCALL =(select Count(distinct F.Candidate_Id) from  Tbl_FollowUp_Detail F
left join tbl_Candidate_Personal_Det D on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
 where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)and Respond_Type=''RETURN CALL'' or Action_to_Be_Taken=''Phone Call'')

 set @LEAVEVOICEMESSAGE =(select Count(distinct F.Candidate_Id) from  Tbl_FollowUp_Detail F
 left join tbl_Candidate_Personal_Det D on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
 where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)and Respond_Type=''VOICE MAIL'')

 set  @WAITINGFORCERTIFICATESDOCUMENTS =(select Count(distinct P.Candidate_Id) from Tbl_Candidate_Personal_Det P 
 left join [Tbl_Candidate_Document] D on P.Candidate_Id=D.Candidate_Id  
 left join tbl_New_Admission N on N.New_Admission_Id=P.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=P.CounselorEmployee_id 
 where NOT EXISTS (SELECT * FROM Tbl_Candidate_Document D WHERE P.Candidate_Id=D.Candidate_Id) and
  (@MarketingStaff=P.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList) )

set  @WAITINGFORNOCLETTERFORELIGIBILITY =(select  Count(distinct D.Candidate_Id) from  Tbl_Candidate_Personal_Det D
left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
 where (ApplicationStatus=''rejected'' or ApplicationStatus=''approved'' or Respond_Type=''SEND LETTER'' ) 
 and (D.Candidate_Id=D.Candidate_Id) and
  (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))

set  @OFFERLETTERBRINGPROCESSBYADMISSION =(select  Count( distinct O.Candidate_Id) from  Tbl_Offerlettre  O
left join  Tbl_Candidate_Personal_Det D on O.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))

declare @NEW1  Decimal(18,2)
declare @FOLLOWUP1 Decimal(18,2)
 declare @APPLIED1 Decimal(18,2) 
declare @NOTQUALIFIED1 Decimal(18,2)  
declare @OFFERLETTERSENT1 Decimal(18,2)  
declare @NOTINTERESTED1  Decimal(18,2)  
declare @WAITINGFORFINALRESULT1  Decimal(18,2)  
declare @NOTDECIDEDINANYCOURSE1  Decimal(18,2)  
declare @NEVERANSWEREMAIL1 Decimal(18,2)  
declare  @NEVERANSWERCALL1  Decimal(18,2)  
declare @LEAVEVOICEMESSAGE1 Decimal(18,2)  
declare  @WAITINGFORCERTIFICATESDOCUMENTS1  Decimal(18,2)  
declare  @WAITINGFORNOCLETTERFORELIGIBILITY1  Decimal(18,2)  
declare  @OFFERLETTERBRINGPROCESSBYADMISSION1  Decimal(18,2) 

if(@flag=1)
begin

Insert into temp(NEW,FOLLOWUP,APPLIED ,NOTQUALIFIED,OFFERLETTERSENT,NOTINTERESTED,WAITINGFORFINALRESULT, NOTDECIDEDINANYCOURSE, NEVERANSWEREMAIL,NEVERANSWERCALL,
 LEAVEVOICEMESSAGE,WAITINGFORCERTIFICATESDOCUMENTS, WAITINGFORNOCLETTERFORELIGIBILITY, OFFERLETTERBRINGPROCESSBYADMISSION,
 Per_NEW,Per_FOLLOWUP,Per_APPLIED,Per_NOTQUALIFIED,Per_OFFERLETTERSENT,Per_NOTINTERESTED,Per_WAITINGFORFINALRESULT,Per_NOTDECIDEDINANYCOURSE,
Per_NEVERANSWEREMAIL,Per_NEVERANSWERCALL,Per_LEAVEVOICEMESSAGE,Per_WAITINGFORCERTIFICATESDOCUMENTS,Per_WAITINGFORNOCLETTERFORELIGIBILITY,Per_OFFERLETTERBRINGPROCESSBYADMISSION)
 values(
@NEW,@FOLLOWUP,@APPLIED ,@NOTQUALIFIED,@OFFERLETTERSENT,@NOTINTERESTED,@WAITINGFORFINALRESULT, @NOTDECIDEDINANYCOURSE, @NEVERANSWEREMAIL,@NEVERANSWERCALL,
 @LEAVEVOICEMESSAGE,@WAITINGFORCERTIFICATESDOCUMENTS, @WAITINGFORNOCLETTERFORELIGIBILITY, @OFFERLETTERBRINGPROCESSBYADMISSION,
 @NEW1,@FOLLOWUP1, @APPLIED1,@NOTQUALIFIED1,@OFFERLETTERSENT1,@NOTINTERESTED1,@WAITINGFORFINALRESULT1,@NOTDECIDEDINANYCOURSE1,
@NEVERANSWEREMAIL1,@NEVERANSWERCALL1,@LEAVEVOICEMESSAGE1,@WAITINGFORCERTIFICATESDOCUMENTS1,@WAITINGFORNOCLETTERFORELIGIBILITY1,@OFFERLETTERBRINGPROCESSBYADMISSION1 )
 
 set @Totalrecords=(select sum(NEW+FOLLOWUP+APPLIED+NOTQUALIFIED+OFFERLETTERSENT+NOTINTERESTED+WAITINGFORFINALRESULT+NOTDECIDEDINANYCOURSE+NEVERANSWEREMAIL
  +NEVERANSWERCALL+LEAVEVOICEMESSAGE+WAITINGFORCERTIFICATESDOCUMENTS+WAITINGFORNOCLETTERFORELIGIBILITY+OFFERLETTERBRINGPROCESSBYADMISSION) from temp)
 
 Update temp set Totalrecords=@Totalrecords
 set @NEW1 = CAST(@NEW as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;
set @FOLLOWUP1 = CAST(@FOLLOWUP as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;
set @APPLIED1  = CAST(@APPLIED as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100; 
set @NOTQUALIFIED1  = CAST(@NOTQUALIFIED as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @OFFERLETTERSENT1 = CAST(@OFFERLETTERSENT as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @NOTINTERESTED1  = CAST(@NOTINTERESTED as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @WAITINGFORFINALRESULT1   = CAST(@WAITINGFORFINALRESULT as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @NOTDECIDEDINANYCOURSE1  = CAST(@NOTDECIDEDINANYCOURSE as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @NEVERANSWEREMAIL1  = CAST(@NEVERANSWEREMAIL as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @NEVERANSWERCALL1 = CAST(@NEVERANSWERCALL as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @LEAVEVOICEMESSAGE1 = CAST(@LEAVEVOICEMESSAGE as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @WAITINGFORCERTIFICATESDOCUMENTS1  = CAST(@WAITINGFORCERTIFICATESDOCUMENTS as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @WAITINGFORNOCLETTERFORELIGIBILITY1 = CAST(@WAITINGFORNOCLETTERFORELIGIBILITY as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @OFFERLETTERBRINGPROCESSBYADMISSION1   = CAST(@OFFERLETTERBRINGPROCESSBYADMISSION as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;

Update temp set Per_NEW=@NEW1,Per_FOLLOWUP=@FOLLOWUP1,Per_APPLIED=@APPLIED1,Per_NOTQUALIFIED=@NOTQUALIFIED1,Per_OFFERLETTERSENT=@OFFERLETTERSENT1,
Per_NOTINTERESTED=@NOTINTERESTED1,Per_WAITINGFORFINALRESULT=@WAITINGFORFINALRESULT1,Per_NOTDECIDEDINANYCOURSE=@NOTDECIDEDINANYCOURSE1,
Per_NEVERANSWEREMAIL=@NEVERANSWEREMAIL1,Per_NEVERANSWERCALL=@NEVERANSWERCALL1,Per_LEAVEVOICEMESSAGE=@LEAVEVOICEMESSAGE1,
Per_WAITINGFORCERTIFICATESDOCUMENTS=@WAITINGFORCERTIFICATESDOCUMENTS1,
Per_WAITINGFORNOCLETTERFORELIGIBILITY=@WAITINGFORNOCLETTERFORELIGIBILITY1,Per_OFFERLETTERBRINGPROCESSBYADMISSION=@OFFERLETTERBRINGPROCESSBYADMISSION1

 select NEW,FOLLOWUP,APPLIED ,NOTQUALIFIED,OFFERLETTERSENT,NOTINTERESTED,WAITINGFORFINALRESULT, NOTDECIDEDINANYCOURSE, NEVERANSWEREMAIL,NEVERANSWERCALL,
 LEAVEVOICEMESSAGE,WAITINGFORCERTIFICATESDOCUMENTS, WAITINGFORNOCLETTERFORELIGIBILITY, OFFERLETTERBRINGPROCESSBYADMISSION,
 Per_NEW +'' %'' as Per_NEW,Per_FOLLOWUP+'' %'' as Per_FOLLOWUP,Per_APPLIED+'' %'' as Per_APPLIED,Per_NOTQUALIFIED+'' %'' as Per_NOTQUALIFIED,Per_OFFERLETTERSENT+'' %'' as Per_OFFERLETTERSENT,
 Per_NOTINTERESTED +'' %'' as Per_NOTINTERESTED,Per_WAITINGFORFINALRESULT +'' %'' as Per_WAITINGFORFINALRESULT,
 Per_NOTDECIDEDINANYCOURSE +'' %'' as Per_NOTDECIDEDINANYCOURSE,
Per_NEVERANSWEREMAIL +'' %'' as Per_NEVERANSWEREMAIL,Per_NEVERANSWERCALL +'' %'' as Per_NEVERANSWERCALL,
Per_LEAVEVOICEMESSAGE+'' %'' as Per_LEAVEVOICEMESSAGE,Per_WAITINGFORCERTIFICATESDOCUMENTS+'' %'' as Per_WAITINGFORCERTIFICATESDOCUMENTS,Per_WAITINGFORNOCLETTERFORELIGIBILITY+'' %'' as Per_WAITINGFORNOCLETTERFORELIGIBILITY,
Per_OFFERLETTERBRINGPROCESSBYADMISSION +'' %'' as Per_OFFERLETTERBRINGPROCESSBYADMISSION,Totalrecords
  from temp
end


END
    ')
END
