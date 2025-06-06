IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_Reportbystatus_NEW]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Marketing_Reportbystatus_NEW]
@flag bigint =0,
@MarketingStaff bigint=0,
@programmeType bigint=0,
@program bigint=0,
@reportflag bigint=0
AS
BEGIN
truncate table temp1;
declare @ApplicationPending bigint =0
declare @ApplicationSubmitted bigint =0
declare @MarketingApproved bigint =0
declare @AdmissionVerified bigint =0
declare @PreActivated bigint  =0
declare @OfferLetterSent  bigint  =0
declare @OfferLetterAccepted  bigint  =0
declare @Activated  bigint =0
declare @Totalrecords Bigint = 0

set @ApplicationPending=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''pending'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @ApplicationSubmitted=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''submited'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @MarketingApproved=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''approved'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @AdmissionVerified=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''Verified'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @PreActivated=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''Preactivated'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @OfferLetterSent=(select Count(distinct D.Candidate_Id) from Tbl_Offerlettre O
left join  Tbl_Candidate_Personal_Det D on O.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
where (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @OfferLetterAccepted=(select Count(distinct D.Candidate_Id) from tbl_approval_log O
left join  Tbl_Candidate_Personal_Det D on O.Candidate_Id=D.Candidate_Id
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id 
where O.Offerletter_status=1 and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

set @Activated=(select Count(distinct D.Candidate_Id) from Tbl_Candidate_Personal_Det D
left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id  
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
where ApplicationStatus=''Completed'' and (@MarketingStaff=D.CounselorEmployee_id or @MarketingStaff=0)and 
(@programmeType=Course_Category_Id or @programmeType=0) and (@program=Department_Id or @program=0)
--and  N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
)

  
declare @ApplicationPending1  Decimal(18,2)=0.00
declare @ApplicationSubmitted1 Decimal(18,2)=0.00
declare @MarketingApproved1 Decimal(18,2) =0.00
declare @AdmissionVerified1 Decimal(18,2) =0.00 
declare @PreActivated1 Decimal(18,2)  =0.00
declare @OfferLetterSent1  Decimal(18,2)  =0.00
declare @OfferLetterAccepted1  Decimal(18,2)  =0.00
declare @Activated1  Decimal(18,2) =0.00

if(@flag=1)
begin


Insert into temp1(ApplicationPending,ApplicationSubmitted,MarketingApproved,AdmissionVerified,PreActivated,OfferLetterSent,OfferLetterAccepted, Activated,Totalrecords, 
 per_ApplicationPending,per_ApplicationSubmitted, per_MarketingApproved, per_AdmissionVerified,
 per_PreActivated,per_OfferLetterSent,per_OfferLetterAccepted,per_Activated)
 values(
@ApplicationPending,@ApplicationSubmitted,@MarketingApproved ,@AdmissionVerified,@PreActivated,@OfferLetterSent,@OfferLetterAccepted, @Activated,@Totalrecords ,
 @ApplicationPending1,@ApplicationSubmitted1, @MarketingApproved1, @AdmissionVerified1,
 @PreActivated1,@OfferLetterSent1, @OfferLetterAccepted1,@Activated1)
 
 set @Totalrecords=(select sum(ApplicationPending+ApplicationSubmitted+MarketingApproved+AdmissionVerified+PreActivated+OfferLetterSent+OfferLetterAccepted+Activated) from temp1)
 
 if @Totalrecords is NULL or @Totalrecords = 0
    begin
        set @Totalrecords = 1;  -- Set to 0 to avoid inserting NULL into the table
    end

 Update temp1 set Totalrecords=@Totalrecords
 set @ApplicationPending1 = CAST(@ApplicationPending as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;
set @ApplicationSubmitted1 = CAST(@ApplicationSubmitted as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;
set @MarketingApproved1  = CAST(@MarketingApproved as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100; 
set @AdmissionVerified1  = CAST(@AdmissionVerified as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;
set @PreActivated1  = CAST(@PreActivated as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @OfferLetterSent1   = CAST(@OfferLetterSent as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @OfferLetterAccepted1  = CAST(@OfferLetterAccepted as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;  
set @Activated1  = CAST(@Activated as decimal(18,2))/CAST(@Totalrecords as decimal(18,2))*100;


Update temp1 set per_ApplicationPending=@ApplicationPending1,per_ApplicationSubmitted=@ApplicationSubmitted1,per_MarketingApproved=@MarketingApproved1,
per_AdmissionVerified=@AdmissionVerified1,per_PreActivated=@PreActivated1,
per_OfferLetterSent=@OfferLetterSent1,per_OfferLetterAccepted=@OfferLetterAccepted1,per_Activated=@Activated1


 select ApplicationPending,ApplicationSubmitted,MarketingApproved,AdmissionVerified,PreActivated,OfferLetterSent,OfferLetterAccepted, Activated, 
 per_ApplicationPending +'' %'' as per_ApplicationPending,per_ApplicationSubmitted+'' %'' as per_ApplicationSubmitted,per_MarketingApproved+'' %'' as per_MarketingApproved,
 per_AdmissionVerified+'' %'' as per_AdmissionVerified,per_PreActivated+'' %'' as per_PreActivated,
 per_OfferLetterSent +'' %'' as per_OfferLetterSent,per_OfferLetterAccepted +'' %'' as per_OfferLetterAccepted,
 per_Activated +'' %'' as per_Activated,Totalrecords
  from temp1

  end
END
    ')
END
