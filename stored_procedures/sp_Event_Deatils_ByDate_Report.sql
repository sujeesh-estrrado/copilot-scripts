IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Event_Deatils_ByDate_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Event_Deatils_ByDate_Report] --0,''2019-11-02'',''2019-11-10'',1000000,1
(
@flag BIGINT=0,
@fromdate datetime = NULL,
@Todate datetime = NULL,
@PageSize bigint=10,
@CurrentPage bigint=1
)
as
begin
Declare @UpperBand int
   Declare @LowerBand int

   SET @LowerBand  = (@CurrentPage - 1) * @PageSize
   SET @UpperBand  = (@CurrentPage * @PageSize) + 1

IF(@flag=0)
BEGIN
select distinct T.Team_Id, T.Team_Name,TF.TeamLead,

 (select count(*) from Tbl_Event_Details where Team_Id=T.Team_Id
 and (((CONVERT(date,End_Date)) >= @fromdate and (CONVERT(date,End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,End_Date)) >= @fromdate))) NumberOfEvents,


 (select Count(*) from Tbl_Candidate_Personal_Det CPD LEFT JOIN Tbl_Event_Details EF ON EF.Event_Id=CPD.Event_Id where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' 
 and ApplicationStatus!=''Pending'' and CPD.Event_Id=EF.Event_id
 and CPD.Event_Id in (select Event_Id from Tbl_Event_Details where EF.Team_Id=T.Team_Id)
 and (((CONVERT(date,ED.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate)))as Conversion_to_Sales,  
 
 (select sum(Budget) from Tbl_Particulars_Detailss P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where EF.Team_Id=T.Team_Id
 and (((CONVERT(date,ED.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) Team_Budget,
 
 (select sum(ActualExpense) from Tbl_Particulars_Detailss P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where EF.Team_Id=T.Team_Id
  and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) Team_Actual_Exp,
 
 (select sum(P.TargetedStudent) from Tbl_Event_Details P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where EF.Team_Id=T.Team_Id
  and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) TargetStudent,

 (select Count(*) from Tbl_Candidate_Personal_Det CPD left join Tbl_Event_Details EF on EF.Event_Id=CPD.Event_ID where CPD.Event_Id in (select Event_Id from Tbl_Event_Details where ED.Team_Id=T.Team_Id)
  and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate)))as Total_Enquiry,
 
 (select Count(*) from Tbl_Candidate_Personal_Det P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where p.ApplicationStatus=''Completed'' and EF.Team_Id=T.Team_Id
   and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) Conversion_to_Activation


 from Tbl_Teams T 

 left join Tbl_Event_Details ED  on ED.Team_Id=T.Team_Id
 left join Tbl_Candidate_Personal_Det CPD  on CPD.Event_Id=ED.Event_Id
 left join Tbl_Counsellor_Teamforming TF on TF.Team_Id=T.Team_Id
 where ED.Del_Status=0 and  ED.Team_Id in(select Team_Id from Tbl_Teams) and
 (((CONVERT(date,ED.End_Date)) >= @fromdate and (CONVERT(date,ED.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,ED.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,ED.End_Date)) >= @fromdate))
 order by  T.Team_Id asc


         OFFSET @PageSize * (@CurrentPage - 1) ROWS
   FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END
IF(@flag=1)
BEGIN
with Level1 as(
select distinct T.Team_Id, T.Team_Name,TF.TeamLead,

 (select count(*) from Tbl_Event_Details where Team_Id=T.Team_Id
 and (((CONVERT(date,End_Date)) >= @fromdate and (CONVERT(date,End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,End_Date)) >= @fromdate))) NumberOfEvents,


 (select Count(*) from Tbl_Candidate_Personal_Det CPD LEFT JOIN Tbl_Event_Details EF ON EF.Event_Id=CPD.Event_Id where ApplicationStatus!=''Completed'' and ApplicationStatus!=''rejected'' and ApplicationStatus!=''pending'' 
 and ApplicationStatus!=''Pending'' and CPD.Event_Id=EF.Event_id
 and CPD.Event_Id in (select Event_Id from Tbl_Event_Details where EF.Team_Id=T.Team_Id)
 and (((CONVERT(date,ED.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate)))as Conversion_to_Sales,  
 
 (select sum(Budget) from Tbl_Particulars_Detailss P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where EF.Team_Id=T.Team_Id
 and (((CONVERT(date,ED.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) Team_Budget,
 
 (select sum(ActualExpense) from Tbl_Particulars_Detailss P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where EF.Team_Id=T.Team_Id
  and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) Team_Actual_Exp,
 
 (select sum(P.TargetedStudent) from Tbl_Event_Details P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where EF.Team_Id=T.Team_Id
  and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) TargetStudent,

 (select Count(*) from Tbl_Candidate_Personal_Det CPD left join Tbl_Event_Details EF on EF.Event_Id=CPD.Event_ID where CPD.Event_Id in (select Event_Id from Tbl_Event_Details where ED.Team_Id=T.Team_Id)
  and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate)))as Total_Enquiry,
 
 (select Count(*) from Tbl_Candidate_Personal_Det P left join Tbl_Event_Details EF on EF.Event_Id=P.Event_ID where p.ApplicationStatus=''Completed'' and EF.Team_Id=T.Team_Id
   and (((CONVERT(date,EF.End_Date)) >= @fromdate and (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate)) 
 OR (@fromdate IS NULL AND @Todate IS NULL)
 OR (@fromdate IS NULL AND (CONVERT(date,EF.End_Date)) < DATEADD(day,1,@Todate))
 OR (@Todate IS NULL AND (CONVERT(date,EF.End_Date)) >= @fromdate))) Conversion_to_Activation

 from Tbl_Teams T 

 left join Tbl_Event_Details ED  on ED.Team_Id=T.Team_Id
 left join Tbl_Candidate_Personal_Det CPD  on CPD.Event_Id=ED.Event_Id
 left join Tbl_Counsellor_Teamforming TF on TF.Team_Id=T.Team_Id
 where ED.Del_Status=0 and  ED.Team_Id in(select Team_Id from Tbl_Teams)

)
select count(*)as counts from Level1 
END
end
    ')
END
