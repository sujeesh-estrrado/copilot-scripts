IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[NewEnquiryandEnrolmentComparisonCurrentMonth]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[NewEnquiryandEnrolmentComparisonCurrentMonth]        
AS        
BEGIN        
declare @LoopCounts int        
declare @CourseCode Varchar(100)        
declare @TotalCounts int        
declare @Entry_Types varchar(100)         
Declare @CouponCount int        
declare @CallIns int        
declare @Walkins int        
declare @Ours int        
declare @FallowCount int        
Declare @CurrentFallowCount int        
declare @EnRollCount int      
create table #Output(Course_Code Varchar(50),Coupon int,CallIn int,Walkin int,Our int,FollowUpCount int,EnrollNo int)        
Create table #CourseTable (Id int IDENTITY(1,1) PRIMARY KEY ,Candidate_ID int,Course_Code Varchar(50),Department_Id int,Enquiry_Type varchar(100))        
create table #FollowUpCountDetails(CountOfFollowups int,CandidateId int,CourseCode varchar(50))        
Create table #EntrollDatas(Id int IDENTITY(1,1) PRIMARY KEY,Candidate_Id int,EnrollDate Datetime,EnrollBy varchar(50),CourseCode varchar(50),Adharno varchar(50),CandidateName varchar(50),Amount int)      
set @LoopCounts=1       
--------------------------PREVIOUS ENROLL DATA      
      
insert into #EntrollDatas(Candidate_Id,EnrollDate,EnrollBy,CourseCode,Adharno,CandidateName,Amount)      
select CPD.Candidate_Id,CONVERT(datetime,CPD.RegDate,103) AS ENROLLDATE,CPD.EnrollBy,D.Course_Code,--,CBD.Batch_Code,CBD.Study_Mode,      
CPD.AdharNumber,CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname AS CANDIDATENAME,      
(SELECT ISNULL(SUM(FE.Paid),0) FROM dbo.Tbl_Fee_Entry_Main FE WHERE FE.Candidate_Id=CPD.Candidate_Id)      
AS  PAIDAMOUNT      
FROM dbo.Tbl_Candidate_Personal_Det CPD      
INNER JOIN dbo.Tbl_Student_Registration SR  ON SR.Candidate_Id=CPD.Candidate_Id      
INNER JOIN dbo.Tbl_Department D ON D.Department_Id=SR.Department_Id      
INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Candidate_Id=CPD.Candidate_Id      
inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id      
inner join dbo.Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id      
inner join dbo.Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id      
WHERE DATEPART(m, RegDate) = DATEPART(m, getdate())            
AND DATEPART(yyyy, RegDate) = DATEPART(yyyy, getdate())        
      
---========================== END       
       
insert into #CourseTable(Candidate_ID,Course_Code,Department_Id,Enquiry_Type)        
select Distinct(FS.Candidate_Id),CD.Course_Code,NA.Department_Id,FS.Enquiry_Type        
  from [Tbl_FollowUp_Status] FS              
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]             
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id             
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id         
  INNER JOIN dbo.Tbl_Department CD ON CD.Department_Id=NA.Department_Id        
  WHERE DATEPART(m, Followup_Date) = DATEPART(m, getdate())            
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, getdate())             
   GROUP BY NA.Department_Id,FS.[Candidate_Id],CD.Course_code,FS.Enquiry_Type        
        
--INSERTION TO FOLLOW TABLE        
insert into #FollowUpCountDetails(CountOfFollowups,CandidateId,CourseCode)        
  select  COUNT (FS.Follow_Up_Detail_Id) as NO_OF_FOLLOWUP,FS.[Candidate_Id],CD.Course_code        
  from dbo.Tbl_FollowUp_Detail  FS            
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]             
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id          
  INNER JOIN dbo.Tbl_Department CD ON CD.Department_Id=NA.Department_Id       
  WHERE DATEPART(m, Followup_Date) = DATEPART(m, getdate())           
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, getdate())          
   GROUP BY NA.Department_Id,FS.[Candidate_Id],CD.Course_code        
--- To set the Count         
 set @TotalCounts = (select count(T.Id) from #CourseTable as T )        
while(@LoopCounts<=@TotalCounts)        
begin        
set @CourseCode=''''        
set @Entry_Types=''''        
set @CouponCount=0        
set @CourseCode=(select T.Course_Code from #CourseTable as T where T.Id=@LoopCounts)         
set @Entry_Types=(select T.Enquiry_Type from #CourseTable as T where T.Id=@LoopCounts)        
 if(@Entry_Types=''COUPON'')        
 begin        
  set @CallIns=''''        
  set @Walkins=''''        
  set @Ours=''''        
  set @FallowCount=''''       
  set @EnRollCount=(select Count(E.Candidate_Id) from #EntrollDatas as E where E.CourseCode=@CourseCode)         
  set @CouponCount=(select Count(T.Candidate_ID) from #CourseTable as T where T.Course_Code=@CourseCode and T.Enquiry_Type=@Entry_Types)        
  set @FallowCount=(select CountOfFollowups from #FollowUpCountDetails as F where F.CourseCode=@CourseCode)        
   if(@FallowCount>0)        
   begin        
    set @CurrentFallowCount=@FallowCount        
   end        
   else        
   begin        
    set @CurrentFallowCount=''''        
   end        
  insert into #Output (Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo) select @CourseCode,@CouponCount,@CallIns,@Walkins,@Ours,@CurrentFallowCount,@EnRollCount       
  Delete from #CourseTable where Course_Code=@CourseCode and Enquiry_Type=@Entry_Types        
 end        
 else if(@Entry_Types=''CALL IN'')        
 begin        
  set @CouponCount=''''        
  set @Ours=''''        
  set @Walkins=''''        
  set @FallowCount=''''      
  set @EnRollCount=(select Count(E.Candidate_Id) from #EntrollDatas as E where E.CourseCode=@CourseCode)          
  set @CallIns=(select Count(T.Candidate_ID) from #CourseTable as T where T.Course_Code=@CourseCode and T.Enquiry_Type=@Entry_Types)        
  set @FallowCount=(select CountOfFollowups from #FollowUpCountDetails as F where F.CourseCode=@CourseCode)        
   if(@FallowCount>0)        
   begin        
    set @CurrentFallowCount=@FallowCount        
   end        
   else        
   begin        
    set @CurrentFallowCount=''''        
   end        
  insert into #Output (Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo) select @CourseCode,@CouponCount,@CallIns,@Walkins,@Ours,@CurrentFallowCount,@EnRollCount       
  Delete from #CourseTable where Course_Code=@CourseCode and Enquiry_Type=@Entry_Types        
 end        
 else if(@Entry_Types=''WALK IN'')        
 begin        
  set @CouponCount=''''        
  set @Ours=''''        
  set @CallIns=''''        
  set @FallowCount=''''       
  set @EnRollCount=(select Count(E.Candidate_Id) from #EntrollDatas as E where E.CourseCode=@CourseCode)           
  set @Walkins=(select Count(T.Candidate_ID) from #CourseTable as T where T.Course_Code=@CourseCode and T.Enquiry_Type=@Entry_Types)        
  set @FallowCount=(select CountOfFollowups from #FollowUpCountDetails as F where F.CourseCode=@CourseCode)        
   if(@FallowCount>0)        
   begin        
    set @CurrentFallowCount=@FallowCount        
   end        
   else        
   begin        
    set @CurrentFallowCount=''''        
   end        
  insert into #Output (Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo) select @CourseCode,@CouponCount,@CallIns,@Walkins,@Ours,@CurrentFallowCount,@EnRollCount      
  Delete from #CourseTable where Course_Code=@CourseCode and Enquiry_Type=@Entry_Types        
 end        
else if(@Entry_Types=''OUR'')        
 begin        
  set @CouponCount=''''        
  set @Walkins=''''        
  set @CallIns=''''        
  set @FallowCount=''''       
  set @EnRollCount=(select Count(E.Candidate_Id) from #EntrollDatas as E where E.CourseCode=@CourseCode)       
  set @Ours=(select Count(T.Candidate_ID) from #CourseTable as T where T.Course_Code=@CourseCode and T.Enquiry_Type=@Entry_Types)        
  set @FallowCount=(select CountOfFollowups from #FollowUpCountDetails as F where F.CourseCode=@CourseCode)        
   if(@FallowCount>0)        
   begin        
    set @CurrentFallowCount=@FallowCount        
   end        
   else        
   begin        
    set @CurrentFallowCount=''''        
   end        
  insert into #Output (Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo) select @CourseCode,@CouponCount,@CallIns,@Walkins,@Ours,@CurrentFallowCount,@EnRollCount        
  Delete from #CourseTable where Course_Code=@CourseCode and Enquiry_Type=@Entry_Types        
 end        
set @LoopCounts=@LoopCounts+1        
End        
select * from #Output        
--select * from #CourseTable        
--select * from #FollowUpCountDetails        
        
        
END        
        
        
        
-- select Distinct(FS.Candidate_Id),CD.Course_Code,CD.Department_Id,FS.Enquiry_Type        
--  from [Tbl_FollowUp_Status] FS              
--  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]             
--  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id             
--  --INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id         
--  INNER JOIN dbo.Tbl_Department CD ON CD.Department_Id=NA.Department_Id        
--  where  FS.Candidate_Id=CPD.Candidate_Id
    ')
END;
