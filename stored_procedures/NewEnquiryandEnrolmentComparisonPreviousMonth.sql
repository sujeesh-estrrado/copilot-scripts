IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[NewEnquiryandEnrolmentComparisonPreviousMonth]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[NewEnquiryandEnrolmentComparisonPreviousMonth]          
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
declare @TempCount int          
declare @EnRollCount int      
declare @Month int      
Declare @year int       
declare @MonthName varchar(50)   
declare @tempisstatus int     
create table #Output(Course_Code Varchar(50),Coupon int,CallIn int,Walkin int,Our int,FollowUpCount int,EnrollNo int)          
Create table #CourseTable (Id int IDENTITY(1,1) PRIMARY KEY ,Candidate_ID int,Course_Code Varchar(50),Department_Id int,Enquiry_Type varchar(100))          
create table #FollowUpCountDetails(CountOfFollowups int,CandidateId int,CourseCode varchar(50))          
Create table #FinalOut(ID int IDENTITY(1,1) PRIMARY KEY,Coupon int,CallIn int,Walkin int,Our int,FollowUpCount int,EnrollNo int,Coupons int,CallIns int,Walkins int,Ours int,FollowUpCounts int,EnrollNos int)          
create table #CurrentMonth(Course_Code Varchar(50),Coupon int,CallIn int,Walkin int,Our int,FollowUpCount int,EnrollNo int)        
create table #FinalCourse(ID int IDENTITY(1,1) PRIMARY KEY,CourseCode varchar(50))          
Create table #EntrollDatas(Id int IDENTITY(1,1) PRIMARY KEY,Candidate_Id int,EnrollDate Datetime,EnrollBy varchar(50),CourseCode varchar(50),Adharno varchar(50),CandidateName varchar(50),Amount int)        
Create Table #MOnthDetails(Id int IDENTITY(1,1) PRIMARY KEY,Months varchar(50),Years varchar(50),Status varchar(50))      
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
WHERE DATEPART(m, RegDate) = DATEPART(m, DATEADD(m, -1, getdate()))              
AND DATEPART(yyyy, RegDate) = DATEPART(yyyy, DATEADD(m, -1, getdate()))           
        
---========================== END         
insert into #CourseTable(Candidate_ID,Course_Code,Department_Id,Enquiry_Type)          
select Distinct(FS.Candidate_Id),CD.Course_Code,NA.Department_Id,FS.Enquiry_Type          
  from [Tbl_FollowUp_Status] FS                
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]               
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id               
  INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id           
  INNER JOIN dbo.Tbl_Department CD ON CD.Department_Id=NA.Department_Id          
  WHERE DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))     
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))               
   GROUP BY NA.Department_Id,FS.[Candidate_Id],CD.Course_code,FS.Enquiry_Type          
          
--INSERTION TO FOLLOW TABLE          
insert into #FollowUpCountDetails(CountOfFollowups,CandidateId,CourseCode)          
  select  COUNT (FS.Follow_Up_Detail_Id) as NO_OF_FOLLOWUP,FS.[Candidate_Id],CD.Course_code          
  from dbo.Tbl_FollowUp_Detail  FS         
  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]               
  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id            
  INNER JOIN dbo.Tbl_Department CD ON CD.Department_Id=NA.Department_Id             
  WHERE DATEPART(m, Followup_Date) = DATEPART(m, DATEADD(m, -1, getdate()))              
  AND DATEPART(yyyy, Followup_Date) = DATEPART(yyyy, DATEADD(m, -1, getdate()))               
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
        
insert into #CurrentMonth(Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo)EXEC NewEnquiryandEnrolmentComparisonCurrentMonth          
insert into #FinalOut (Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo,Coupons,CallIns,Walkins,Ours,FollowUpCounts,EnrollNos)          
select O.Coupon,O.CallIn,O.Walkin,O.Our,O.FollowUpCount,O.EnrollNo,CM.Coupon,CM.CallIn,CM.Walkin,CM.Our,CM.FollowUpCount,CM.EnrollNo          
from #Output O FULL OUTER JOIN #CurrentMonth CM          
ON CM.Course_Code=O.Course_Code          
          
          
insert into #FinalCourse(CourseCode)          
SELECT Course_Code FROM(SELECT Course_Code FROM #Output UNION SELECT Course_Code FROM #CurrentMonth) AS aLLcODES WHERE Course_Code IS NOT NULL          
set @TempCount=0          
Delete from dbo.Tbl_NewEnquiryandEnrolmentComparison         
insert into dbo.Tbl_NewEnquiryandEnrolmentComparison (Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo,Coupons,CallIns,Walkins,Ours,FollowUpCounts,EnrollNos)          
select FC.CourseCode,FO.Coupon,FO.CallIn,FO.Walkin,FO.Our,FO.FollowUpCount,FO.EnrollNo,FO.Coupons,FO.CallIns,FO.Walkins,FO.Ours,FO.FollowUpCounts,FO.EnrollNos         
from #FinalOut FO inner join #FinalCourse FC          
on FO.ID=FC.ID             
      
set @tempisstatus=(select Id from dbo.Tbl_NewEnquiryandEnrolmentComparison)  
if(@tempisstatus is null)   
begin  
insert into dbo.Tbl_NewEnquiryandEnrolmentComparison (Course_Code,Coupon,CallIn,Walkin,Our,FollowUpCount,EnrollNo,Coupons,CallIns,Walkins,Ours,FollowUpCounts,EnrollNos)   
select ''0'',''0'',''0'',''0'',''0'',''0'',''0'',''0'',''0'',''0'',''0'',''0'',''0''  
end  
--Current Month And year ============= Previous Month And year      
      
set @Month = (select DATEPART(mm, DATEADD(mm, -1, getdate())))       
set @year= (select DATEPART(yyyy, DATEADD(yyyy,0, getdate())))       
if(@Month=1)      
begin      
set @MonthName=''January''      
end      
else if(@Month=2)      
begin      
set @MonthName=''February''      
End      
else if(@Month=3)      
begin      
set @MonthName=''March''      
End      
else if(@Month=4)      
begin      
set @MonthName=''April''      
End      
else if(@Month=5)      
begin      
set @MonthName=''May''      
End      
else if(@Month=6)      
begin      
set @MonthName=''June''      
End      
else if(@Month=7)      
begin      
set @MonthName=''July''      
End      
else if(@Month=8)      
begin      
set @MonthName=''August''      
End      
else if(@Month=9)      
begin      
set @MonthName=''September''      
End      
else if(@Month=10)      
begin      
set @MonthName=''October''      
End      
else if(@Month=11)      
begin      
set @MonthName=''November''      
End      
else if(@Month=12)      
begin      
set @MonthName=''December''      
End      
insert into #MOnthDetails(Months,Years,Status) select @MonthName,@year,''Previous Month''      
set @Month=''''      
set @year=''''      
---===================================== END      
      
set @Month = (select DATEPART(mm, DATEADD(mm, 0, getdate())))       
set @year= (select DATEPART(yyyy, DATEADD(yyyy, 0, getdate())))       
if(@Month=1)      
begin      
set @MonthName=''January''      
end    else if(@Month=2)      
begin      
set @MonthName=''February''      
End      
else if(@Month=3)      
begin      
set @MonthName=''March''      
End      
else if(@Month=4)      
begin      
set @MonthName=''April''      
End      
else if(@Month=5)      
begin      
set @MonthName=''May''      
End      
else if(@Month=6)      
begin      
set @MonthName=''June''      
End      
else if(@Month=7)      
begin      
set @MonthName=''July''      
End      
else if(@Month=8)      
begin      
set @MonthName=''August''      
End      
else if(@Month=9)      
begin      
set @MonthName=''September''      
End      
else if(@Month=10)      
begin      
set @MonthName=''October''      
End      
else if(@Month=11)      
begin      
set @MonthName=''November''      
End      
else if(@Month=12)      
begin      
set @MonthName=''December''      
End      
insert into #MOnthDetails(Months,Years,Status) select @MonthName,@year,''Current Month''      
select * from #MOnthDetails      
      
END          
          
          
--(select O.Course_Code,O.Coupon,O.CallIn,O.Walkin,O.Our,O.FollowUpCount,CM.Course_Code,CM.Coupon,CM.CallIn,CM.Walkin,CM.Our,CM.FollowUpCount          
--from #Output O INNER JOIN #CurrentMonth CM          
--ON CM.Course_Code=O.Course_Code)          
--UNION          
--(select O.Course_Code,O.Coupon,O.CallIn,O.Walkin,O.Our,O.FollowUpCount,CM.Course_Code,CM.Coupon,CM.CallIn,CM.Walkin,CM.Our,CM.FollowUpCount          
--from #Output O RIGHT JOIN #CurrentMonth CM          
--ON CM.Course_Code<>O.Course_Code)          
--UNION          
--(select O.Course_Code,O.Coupon,O.CallIn,O.Walkin,O.Our,O.FollowUpCount,CM.Course_Code,CM.Coupon,CM.CallIn,CM.Walkin,CM.Our,CM.FollowUpCount          
--from #Output O LEFT JOIN #CurrentMonth CM          
--ON CM.Course_Code<>O.Course_Code)          
          
          
          
-- select Distinct(FS.Candidate_Id),CD.Course_Code,CD.Department_Id,FS.Enquiry_Type          
--  from [Tbl_FollowUp_Status] FS                
--  INNER JOIN  dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id=FS.[Candidate_Id]               
--  INNER JOIN dbo.tbl_New_Admission NA ON NA.New_Admission_Id=CPD.New_Admission_Id               
--  --INNER JOIN [Tbl_FollowUp_Detail] FD ON FD.Candidate_Id=FS.Candidate_Id           
--  INNER JOIN dbo.Tbl_Department CD ON CD.Department_Id=NA.Department_Id          
--  where  FS.Candidate_Id=CPD.Candidate_Id
    ')
END
