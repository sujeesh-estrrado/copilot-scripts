IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_counsellorLeadApplicationbyMonthReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_counsellorLeadApplicationbyMonthReport]-- 1,''862,1211,948''
(
@flag bigint=0,
@EmployeeIds varchar(max)=''''
)
as
if(@flag=0)
begin
Declare @janCurrentYear bigint
Declare @janOnlineCurrentYear bigint
Declare @febCurrentYear bigint
Declare @febOnlineCurrentYear bigint
Declare @marCurrentYear bigint
Declare @marOnlineCurrentYear bigint
Declare @aprCurrentYear bigint
Declare @aprOnlineCurrentYear bigint
Declare @mayCurrentYear bigint
Declare @mayOnlineCurrentYear bigint
Declare @junCurrentYear bigint
Declare @junOnlineCurrentYear bigint
Declare @julCurrentYear bigint
Declare @julOnlineCurrentYear bigint
Declare @augCurrentYear bigint
Declare @augOnlineCurrentYear bigint
Declare @sepCurrentYear bigint
Declare @sepOnlineCurrentYear bigint
Declare @octCurrentYear bigint
Declare @octOnlineCurrentYear bigint
Declare @novCurrentYear bigint
Declare @novOnlineCurrentYear bigint
Declare @decCurrentYear bigint
Declare @decOnlineCurrentYear bigint



set @janCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''01/01/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @janOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''01/01/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @febCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''02/02/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @febOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''02/02/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @marCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''03/03/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @marOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''03/03/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @aprCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''04/04/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @aprOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''04/04/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @mayCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''05/05/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @mayOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''05/05/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @junCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''06/06/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))
 
set @junOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''06/06/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @julCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''07/07/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @julOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''07/07/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @augCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''08/08/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @augOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''08/08/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @sepCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''09/09/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @sepOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''09/09/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @octCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''10/10/2019'') and  year(RegDate)=YEAR(GETDATE()) and  Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @octOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''10/10/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @novCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''11/11/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @novOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''11/11/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @decCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''12/12/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @decOnlineCurrentYear =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''12/12/2019'') and  year(RegDate)=YEAR(GETDATE()) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))


  begin
    
   Create table #tempchart(janCurrentYear varchar(Max),janOnlineCurrentYear varchar(Max),febCurrentYear varchar(Max),febOnlineCurrentYear varchar(Max),marCurrentYear varchar(Max),marOnlineCurrentYear varchar(Max),aprCurrentYear varchar(Max),
   aprOnlineCurrentYear varchar(Max),mayCurrentYear varchar(Max),mayOnlineCurrentYear varchar(Max),junCurrentYear varchar(Max),junOnlineCurrentYear varchar(Max),julCurrentYear varchar(Max),julOnlineCurrentYear varchar(Max),augCurrentYear varchar(Max),augOnlineCurrentYear varchar(Max),sepCurrentYear varchar(Max),sepOnlineCurrentYear varchar(Max),
   octCurrentYear varchar(Max),octOnlineCurrentYear varchar(Max),novCurrentYear varchar(Max),novOnlineCurrentYear varchar(Max),decCurrentYear varchar(Max),decOnlineCurrentYear varchar(Max))
insert into #tempchart
select @janCurrentYear as janCurrentYear ,@janOnlineCurrentYear as janOnlineCurrentYear ,@febCurrentYear as febCurrentYear,@febOnlineCurrentYear as febOnlineCurrentYear, @marCurrentYear as marCurrentYear,@marOnlineCurrentYear as marOnlineCurrentYear,@aprCurrentYear as aprCurrentYear,
@aprOnlineCurrentYear as aprOnlineCurrentYear,@mayCurrentYear as mayCurrentYear,@mayOnlineCurrentYear as mayOnlineCurrentYear,@junCurrentYear as junCurrentYear,@junOnlineCurrentYear as junOnlineCurrentYear,@julCurrentYear julCurrentYear,
@julOnlineCurrentYear as julOnlineCurrentYear,@augCurrentYear as augCurrentYear ,@augOnlineCurrentYear as augOnlineCurrentYear
,@sepCurrentYear as sepCurrentYear,@sepOnlineCurrentYear as sepOnlineCurrentYear,@octCurrentYear as octCurrentYear,@octOnlineCurrentYear as octOnlineCurrentYear,@novCurrentYear novCurrentYear,@novOnlineCurrentYear as novOnlineCurrentYear,
@decCurrentYear as decCurrentYear,@decOnlineCurrentYear as decOnlineCurrentYear


select * from #tempchart --where value!=0



end
end


if(@flag=1)
begin
Declare @janoneYearback bigint
Declare @janOnlineoneYearback bigint
Declare @feboneYearback bigint
Declare @febOnlineoneYearback bigint
Declare @maroneYearback bigint
Declare @marOnlineoneYearback bigint
Declare @aproneYearback bigint
Declare @aprOnlineoneYearback bigint
Declare @mayoneYearback bigint
Declare @mayOnlineoneYearback bigint
Declare @junoneYearback bigint
Declare @junOnlineoneYearback bigint
Declare @juloneYearback bigint
Declare @julOnlineoneYearback bigint
Declare @augoneYearback bigint
Declare @augOnlineoneYearback bigint
Declare @seponeYearback bigint
Declare @sepOnlineoneYearback bigint
Declare @octoneYearback bigint
Declare @octOnlineoneYearback bigint
Declare @novoneYearback bigint
Declare @novOnlineoneYearback bigint
Declare @deconeYearback bigint
Declare @decOnlineoneYearback bigint



set @janoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''01/01/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @janOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''01/01/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @feboneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''02/02/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @febOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''02/02/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @maroneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''03/03/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @marOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''03/03/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @aproneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''04/04/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @aprOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''04/04/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @mayoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''05/05/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @mayOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''05/05/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @junoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''06/06/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))
 
set @junOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''06/06/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @juloneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''07/07/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @julOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''07/07/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @augoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''08/08/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @augOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''08/08/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @seponeYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''09/09/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @sepOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''09/09/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @octoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''10/10/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @octOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''10/10/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @novoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''11/11/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @novOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''11/11/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @deconeYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''12/12/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @decOnlineoneYearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''12/12/2019'') and  year(RegDate)=year(DATEADD(year,-1,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))


  begin
    
   Create table #tempchart1(janoneYearback varchar(Max),janOnlineoneYearback varchar(Max),feboneYearback varchar(Max),febOnlineoneYearback varchar(Max),maroneYearback varchar(Max),marOnlineoneYearback varchar(Max),aproneYearback varchar(Max),
   aprOnlineoneYearback varchar(Max),mayoneYearback varchar(Max),mayOnlineoneYearback varchar(Max),junoneYearback varchar(Max),junOnlineoneYearback varchar(Max),juloneYearback varchar(Max),julOnlineoneYearback varchar(Max),augoneYearback varchar(Max),augOnlineoneYearback varchar(Max),seponeYearback varchar(Max),sepOnlineoneYearback varchar(Max),
   octoneYearback varchar(Max),octOnlineoneYearback varchar(Max),novoneYearback varchar(Max),novOnlineoneYearback varchar(Max),deconeYearback varchar(Max),decOnlineoneYearback varchar(Max))
insert into #tempchart1
select @janoneYearback as janoneYearback ,@janOnlineoneYearback as janOnlineoneYearback ,@feboneYearback as feboneYearback,@febOnlineoneYearback as febOnlineoneYearback, @maroneYearback as maroneYearback,@marOnlineoneYearback as marOnlineoneYearback,@aproneYearback as aproneYearback,
@aprOnlineoneYearback as aprOnlineoneYearback,@mayoneYearback as mayoneYearback,@mayOnlineoneYearback as mayOnlineoneYearback,@junoneYearback as junoneYearback,@junOnlineoneYearback as junOnlineoneYearback,@juloneYearback juloneYearback,@julOnlineoneYearback as julOnlineoneYearback,@augoneYearback as augoneYearback ,@augOnlineoneYearback as augOnlineoneYearback
,@seponeYearback as seponeYearback,@sepOnlineoneYearback as sepOnlineoneYearback,@octoneYearback as octoneYearback,@octOnlineoneYearback as octOnlineoneYearback,@novoneYearback novoneYearback,@novOnlineoneYearback as novOnlineoneYearback,@deconeYearback as deconeYearback,@decOnlineoneYearback as decOnlineoneYearback


select * from #tempchart1 --where value!=0


end
end
if(@flag=2)
begin
Declare @janTwoyearback bigint
Declare @janOnlineTwoyearback bigint
Declare @febTwoyearback bigint
Declare @febOnlineTwoyearback bigint
Declare @marTwoyearback bigint
Declare @marOnlineTwoyearback bigint
Declare @aprTwoyearback bigint
Declare @aprOnlineTwoyearback bigint
Declare @mayTwoyearback bigint
Declare @mayOnlineTwoyearback bigint
Declare @junTwoyearback bigint
Declare @junOnlineTwoyearback bigint
Declare @julTwoyearback bigint
Declare @julOnlineTwoyearback bigint
Declare @augTwoyearback bigint
Declare @augOnlineTwoyearback bigint
Declare @sepTwoyearback bigint
Declare @sepOnlineTwoyearback bigint
Declare @octTwoyearback bigint
Declare @octOnlineTwoyearback bigint
Declare @novTwoyearback bigint
Declare @novOnlineTwoyearback bigint
Declare @decTwoyearback bigint
Declare @decOnlineTwoyearback bigint



set @janTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''01/01/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @janOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''01/01/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @febTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''02/02/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @febOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''02/02/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @marTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''03/03/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @marOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''03/03/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @aprTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''04/04/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @aprOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''04/04/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @mayTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''05/05/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @mayOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''05/05/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @junTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''06/06/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))
 
set @junOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''06/06/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @julTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''07/07/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @julOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''07/07/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @augTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''08/08/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @augOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''08/08/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @sepTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''09/09/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @sepOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''09/09/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @octTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''10/10/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @octOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''10/10/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @novTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''11/11/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @novOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''11/11/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @decTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''12/12/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=0 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))

set @decOnlineTwoyearback =(select count(*) from Tbl_Candidate_Personal_Det  where month(RegDate)=month(''12/12/2019'') and  year(RegDate)=year(DATEADD(year,-2,GETDATE())) and Online_OfflineStatus=1 and (CounselorEmployee_id IN(SELECT CAST(Item AS INTEGER) 
FROM dbo.SplitString(@EmployeeIds, '','')) or @EmployeeIds=''''))


  begin
    
   Create table #tempchart2(janTwoyearback varchar(Max),janOnlineTwoyearback varchar(Max),febTwoyearback varchar(Max),febOnlineTwoyearback varchar(Max),marTwoyearback varchar(Max),marOnlineTwoyearback varchar(Max),aprTwoyearback varchar(Max),
   aprOnlineTwoyearback varchar(Max),mayTwoyearback varchar(Max),mayOnlineTwoyearback varchar(Max),junTwoyearback varchar(Max),junOnlineTwoyearback varchar(Max),julTwoyearback varchar(Max),julOnlineTwoyearback varchar(Max),augTwoyearback varchar(Max),augOnlineTwoyearback varchar(Max),sepTwoyearback varchar(Max),sepOnlineTwoyearback varchar(Max),
   octTwoyearback varchar(Max),octOnlineTwoyearback varchar(Max),novTwoyearback varchar(Max),novOnlineTwoyearback varchar(Max),decTwoyearback varchar(Max),decOnlineTwoyearback varchar(Max))
insert into #tempchart2
select @janTwoyearback as janTwoyearback ,@janOnlineTwoyearback as janOnlineTwoyearback ,@febTwoyearback as febTwoyearback,@febOnlineTwoyearback as febOnlineTwoyearback, @marTwoyearback as marTwoyearback,@marOnlineTwoyearback as marOnlineTwoyearback,
@aprTwoyearback as aprTwoyearback,
@aprOnlineTwoyearback as aprOnlineTwoyearback,@mayTwoyearback as mayTwoyearback,@mayOnlineTwoyearback as mayOnlineTwoyearback,@junTwoyearback as junTwoyearback,@junOnlineTwoyearback as junOnlineTwoyearback,@julTwoyearback julTwoyearback,
@julOnlineTwoyearback as julOnlineTwoyearback,@augTwoyearback as augTwoyearback ,@augOnlineTwoyearback as augOnlineTwoyearback
,@sepTwoyearback as sepTwoyearback,@sepOnlineTwoyearback as sepOnlineTwoyearback,@octTwoyearback as octTwoyearback,@octOnlineTwoyearback as octOnlineTwoyearback,@novTwoyearback novTwoyearback,@novOnlineTwoyearback as novOnlineTwoyearback,
@decTwoyearback as decTwoyearback,@decOnlineTwoyearback as decOnlineTwoyearback


select * from #tempchart2 --where value!=0


end
end
    ')
END
