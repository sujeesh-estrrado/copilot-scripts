IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[rptLeads220629]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[rptLeads220629]  
(
  @generateBy bigint,
  @startDt datetime=null,
  @endDt datetime=null,
  @pageSize smallint=0,
  @curPage smallint=1,
  @curSheet tinyint=0
)    
as    
BEGIN
Declare @rptKeys keyvalue_table,@rowCnt int,
  @curDt date

SET NOCOUNT ON

Set @curDt=convert(date,getdate())


Insert into @rptKeys values(''Report Code'',''LeadReport'')
  
If @startDt is not null or @endDt is not null
  Insert into @rptKeys
  Select ''Filter Date'',
      case when isnull(@startDt,''1900/1/1'')=isnull(@endDt,''2099/12/31'') then convert(varchar(10),@startDt,103)
        when @startDt is not null and @endDt is not null then convert(varchar(10),@startDt,103)+'' to ''+convert(varchar(10),@endDt,103)
        when @startDt is not null then ''Starting from ''+ convert(varchar(10),@startDt,103)
        else ''As at ''+convert(varchar(10),@endDt,103) end


Create table #tmpLead(candidateID bigint primary key)

Insert into #tmpLead
Select Candidate_Id
From Tbl_Lead_Personal_Det
Where (
  convert(date,RegDate)>=@startDt and convert(date,RegDate)<dateadd(day,1,@endDt)
    or (@startDt is null and @endDt is null)    
    or (@startDt is null and convert(date,RegDate)<dateadd(day,1,@endDt))    
    or (convert(date,RegDate)>=@startDt and @endDt is null)
  )
UNION
Select Candidate_Id
From Tbl_FollowUpLead_Detail
Where (
  convert(date,Followup_Date)>=@startDt and convert(date,Followup_Date)<dateadd(day,1,@endDt)
    or (@startDt is null and @endDt is null)    
    or (@startDt is null and convert(date,Followup_Date)<dateadd(day,1,@endDt))    
    or (convert(date,Followup_Date)>=@startDt and @endDt is null)
  )
Group by Candidate_Id




If @pageSize>0 and @curSheet=0
  Set @curSheet=1


If @curSheet in (1,0)
Begin
  If @pageSize=0
  Begin
    Select fcpd.candidateID e_LeadID,
      concat(trim(CPD.Candidate_Fname),'' '',trim(CPD.Candidate_Lname)) [Full Name],CPD.AdharNumber [NRIC/Passport],
      CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
      substring((substring(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + len(''Course Opted :''), len(CPD.Scolorship_Remark))),
        charindex(''Course Opted :'',(substring(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + len(''Course Opted :''), len(CPD.Scolorship_Remark)))),
        charindex('', Nationality:'',(substring(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + len(''Course Opted :''), len(CPD.Scolorship_Remark))))) [Opted Programme],
      case when isnull(CPD.Page_Id,0) in (0) Then ''Landing'' else pg.LandingiURL_Name end [Page Name],
      CPD.Source_name [Source],
      case when CPD.Source_name like ''%reutili%'' then ''Reutilization''
        when CPD.Source_name like ''%upu%'' then ''UPU''
        when CPD.Source_name like ''%stpm%'' then ''STPM''
        when CPD.Source_name like ''%hot%'' and CPD.Source_name like ''%tips%'' then ''SPM Hot Tips''
        when CPD.Source_name like ''%spm%'' then ''SPM''
        when CPD.Source_name like ''%open%'' and CPD.Source_name like ''%day%'' then ''Open Day''
        when CPD.Source_name like ''%star%'' and CPD.Source_name like ''%penang%'' then ''Education Fair''
        when CPD.Source_name like ''%edu%'' and CPD.Source_name like ''%fair%'' then ''Education Fair''
        when CPD.Source_name like ''%fair%'' then ''Education Fair''
        when CPD.Source_name like ''%email%'' then ''Email Enquiries''
        when CPD.Source_name like ''%fb%'' or CPD.Source_name like ''%facebook%'' then ''FB Landing Page''
        when CPD.Source_name like ''%zzupe%'' and CPD.sourcecategory=''facebook'' then ''FB Landing Page''
        when CPD.Source_name like ''%instagram%'' then ''IG Landing Page''
        when CPD.Source_name like ''%zzupe%'' and CPD.sourcecategory=''instagram'' then ''IG Landing Page''
        when CPD.Source_name like ''%zzupe%'' then ''Zzupe Landing Page''
        when CPD.Source_name like ''%landingi%'' then ''Landingi''
        else ''SPM'' end [Source Category],
      case when CPD.ApplicationStatus in (''Lead'',''rejected'') Then CPD.ApplicationStatus
        else ''Moved To Enquiry'' end [Application Status],
      case when CPD.ApplicationStatus=''rejected'' then CPD.Reject_remark else '''' end [Reject Reason],
      CPD.Scolorship_Remark Remark,
      concat(EC.Employee_FName,'' '',EC.Employee_LName) Counsellor,
      case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
      lcl.startDtim [Counsellor Change DateTime],
      concat(pec.Employee_FName,'' '',pec.Employee_LName) [Previous Counsellor],
      convert(date,RegDate) [Lead Reg Date],
        convert(time,RegDate) [Lead Reg Time],
      convert(date,FD1.Followup_Date) [First Follow-Up Date],
        convert(time,FD1.Followup_time) [First Follow-Up Time],
        FD1.Remarks [First Follow-Up Remark],FD1.Respond_Type [First Follow-Up Response Type],
      convert(date,FD.Followup_Date) [Latest Follow-Up Date],
        convert(time,FD.Followup_time) [Latest Follow-Up Time],
        FD.Remarks [Latest Follow-Up Remark],FD.Respond_Type [Latest Follow-Up Response Type],
        convert(date,FD.Next_Date) [Latest Next Follow-Up Date]
    From #tmpLead fcpd
      inner join Tbl_Lead_Personal_Det CPD on fcpd.candidateID=CPD.Candidate_id
      inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
      left outer join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
      left outer join Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
      left outer join Tbl_Nationality N on CPD.Candidate_Nationality=N.Nationality_Id
      left outer join
        (Select Candidate_Id,Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
        From Tbl_FollowUpLead_Detail
        Where isnull(Delete_Status,0)=0
          and Follow_Up_Detail_Id in
            (Select min(Follow_Up_Detail_Id)
            From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
            Where isnull(Delete_Status,0)=0
            Group by fud.Candidate_Id)
          and Action_Taken=0) FD1 on CPD.Candidate_Id=FD1.Candidate_Id
      left outer join
        (Select Candidate_Id,Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
        From Tbl_FollowUpLead_Detail
        Where isnull(Delete_Status,0)=0
          and Follow_Up_Detail_Id in
            (Select max(Follow_Up_Detail_Id)
            From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
            Where isnull(Delete_Status,0)=0
            Group by fud.Candidate_Id)
          and Action_Taken=0) FD on CPD.Candidate_Id=FD.Candidate_Id
      left outer join Tbl_LandingiURL pg on CPD.Page_Id=LandingiURL_Id
      left outer join Tbl_LeadAssign lcl on CPD.Candidate_Id=lcl.Candidate_Id and lcl.isLatest=1
      left outer join Tbl_LeadAssign lcp on CPD.Candidate_Id=lcp.Candidate_Id and lcp.isPrev=1
      left outer join Tbl_Employee pec on lcp.CounselorEmployee_id=pec.Employee_Id
    Order by [Lead Reg Date] desc,e_LeadID desc
    Set @rowCnt=@@ROWCOUNT
  End
  Else
  Begin
    Select fcpd.candidateID e_LeadID,
      concat(trim(CPD.Candidate_Fname),'' '',trim(CPD.Candidate_Lname)) [Full Name],CPD.AdharNumber [NRIC/Passport],
      CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
      substring((substring(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + len(''Course Opted :''), len(CPD.Scolorship_Remark))),
        charindex(''Course Opted :'',(substring(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + len(''Course Opted :''), len(CPD.Scolorship_Remark)))),
        charindex('', Nationality:'',(substring(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + len(''Course Opted :''), len(CPD.Scolorship_Remark))))) [Opted Programme],
      case when isnull(CPD.Page_Id,0) in (0) Then ''Landing'' else pg.LandingiURL_Name end [Page Name],
      CPD.Source_name [Source],
      case when CPD.Source_name like ''%reutili%'' then ''Reutilization''
        when CPD.Source_name like ''%upu%'' then ''UPU''
        when CPD.Source_name like ''%stpm%'' then ''STPM''
        when CPD.Source_name like ''%hot%'' and CPD.Source_name like ''%tips%'' then ''SPM Hot Tips''
        when CPD.Source_name like ''%spm%'' then ''SPM''
        when CPD.Source_name like ''%open%'' and CPD.Source_name like ''%day%'' then ''Open Day''
        when CPD.Source_name like ''%star%'' and CPD.Source_name like ''%penang%'' then ''Education Fair''
        when CPD.Source_name like ''%edu%'' and CPD.Source_name like ''%fair%'' then ''Education Fair''
        when CPD.Source_name like ''%fair%'' then ''Education Fair''
        when CPD.Source_name like ''%email%'' then ''Email Enquiries''
        when CPD.Source_name like ''%fb%'' or CPD.Source_name like ''%facebook%'' then ''FB Landing Page''
        when CPD.Source_name like ''%zzupe%'' and CPD.sourcecategory=''facebook'' then ''FB Landing Page''
        when CPD.Source_name like ''%instagram%'' then ''IG Landing Page''
        when CPD.Source_name like ''%zzupe%'' and CPD.sourcecategory=''instagram'' then ''IG Landing Page''
        when CPD.Source_name like ''%zzupe%'' then ''Zzupe Landing Page''
        when CPD.Source_name like ''%landingi%'' then ''Landingi''
        else ''SPM'' end [Source Category],
      case when CPD.ApplicationStatus in (''Lead'',''rejected'') Then CPD.ApplicationStatus
        else ''Moved To Enquiry'' end [Application Status],
      case when CPD.ApplicationStatus=''rejected'' then CPD.Reject_remark else '''' end [Reject Reason],
      CPD.Scolorship_Remark Remark,
      concat(EC.Employee_FName,'' '',EC.Employee_LName) Counsellor,
      case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
      lcl.startDtim [Counsellor Change DateTime],
      concat(pec.Employee_FName,'' '',pec.Employee_LName) [Previous Counsellor],
      convert(date,RegDate) [Lead Reg Date],
        convert(time,RegDate) [Lead Reg Time],
      convert(date,FD1.Followup_Date) [First Follow-Up Date],
        convert(time,FD1.Followup_time) [First Follow-Up Time],
        FD1.Remarks [First Follow-Up Remark],FD1.Respond_Type [First Follow-Up Response Type],
      convert(date,FD.Followup_Date) [Latest Follow-Up Date],
        convert(time,FD.Followup_time) [Latest Follow-Up Time],
        FD.Remarks [Latest Follow-Up Remark],FD.Respond_Type [Latest Follow-Up Response Type],
        convert(date,FD.Next_Date) [Latest Next Follow-Up Date]
    Into #tmp1
    From #tmpLead fcpd
      inner join Tbl_Lead_Personal_Det CPD on fcpd.candidateID=CPD.Candidate_id
      inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
      left outer join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
      left outer join Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
      left outer join Tbl_Nationality N on CPD.Candidate_Nationality=N.Nationality_Id
      left outer join
        (Select Candidate_Id,Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
        From Tbl_FollowUpLead_Detail
        Where isnull(Delete_Status,0)=0
          and Follow_Up_Detail_Id in
            (Select min(Follow_Up_Detail_Id)
            From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
            Where isnull(Delete_Status,0)=0
            Group by fud.Candidate_Id)
          and Action_Taken=0) FD1 on CPD.Candidate_Id=FD1.Candidate_Id
      left outer join
        (Select Candidate_Id,Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
        From Tbl_FollowUpLead_Detail
        Where isnull(Delete_Status,0)=0
          and Follow_Up_Detail_Id in
            (Select max(Follow_Up_Detail_Id)
            From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
            Where isnull(Delete_Status,0)=0
            Group by fud.Candidate_Id)
          and Action_Taken=0) FD on CPD.Candidate_Id=FD.Candidate_Id
      left outer join Tbl_LandingiURL pg on CPD.Page_Id=LandingiURL_Id
      left outer join Tbl_LeadAssign lcl on CPD.Candidate_Id=lcl.Candidate_Id and lcl.isLatest=1
      left outer join Tbl_LeadAssign lcp on CPD.Candidate_Id=lcp.Candidate_Id and lcp.isPrev=1
      left outer join Tbl_Employee pec on lcp.CounselorEmployee_id=pec.Employee_Id
    Order by [Lead Reg Date] desc,e_LeadID desc
  
    Select @rowCnt=count(*) From #tmp1

    Select * From #tmp1
    Order by [Lead Reg Date] desc,e_LeadID desc
    Offset (@curPage-1)*@pageSize rows
    Fetch next @pageSize rows only
    
    Drop table #tmp1
  End

  Insert into @rptKeys values(''Sheet Title'',''Lead List'')
  Insert into @rptKeys values(''Sheet Code'',''leads'')

  Select * From @rptKeys
  UNION ALL
  Select ''Total Record'',cast(isnull(@rowCnt,0) as varchar(20))
End


If @curSheet in (2,0)
Begin
  If @pageSize=0
  Begin
    Select fu.Follow_Up_Detail_Id logID,fcpd.candidateID e_LeadID,
      concat(trim(CPD.Candidate_Fname),'' '',trim(CPD.Candidate_Lname)) [Full Name],
      convert(date,Followup_Date) [Follow-Up Date],
        convert(time,Followup_time) [Follow-Up Time],[Medium],Remarks Remark,Respond_Type [Response Type],
      convert(date,Next_Date) [Next Follow-Up Date],
      concat(EC.Employee_FName,'' '',EC.Employee_LName) Counsellor
    From #tmpLead fcpd
      inner join Tbl_Lead_Personal_Det CPD on fcpd.candidateID=CPD.Candidate_id
      inner join Tbl_FollowUpLead_Detail fu on fcpd.candidateID=fu.Candidate_id
      inner join Tbl_Employee EC on fu.Counselor_Employee=EC.Employee_Id  
    Where isnull(fu.Delete_Status,0)=0
    Order by e_LeadID desc,[Follow-Up Date],[Follow-Up Time]
    Set @rowCnt=@@ROWCOUNT
  End
  Else
  Begin
    Select fu.Follow_Up_Detail_Id logID,fcpd.candidateID e_LeadID,
      concat(trim(CPD.Candidate_Fname),'' '',trim(CPD.Candidate_Lname)) [Full Name],
      convert(date,Followup_Date) [Follow-Up Date],
        convert(time,Followup_time) [Follow-Up Time],[Medium],Remarks Remark,Respond_Type [Response Type],
      convert(date,Next_Date) [Next Follow-Up Date],
      concat(EC.Employee_FName,'' '',EC.Employee_LName) Counsellor
    Into #tmp2
    From #tmpLead fcpd
      inner join Tbl_Lead_Personal_Det CPD on fcpd.candidateID=CPD.Candidate_id
      inner join Tbl_FollowUpLead_Detail fu on fcpd.candidateID=fu.Candidate_id
      inner join Tbl_Employee EC on fu.Counselor_Employee=EC.Employee_Id  
    Where isnull(fu.Delete_Status,0)=0
    Order by e_LeadID desc,[Follow-Up Date],[Follow-Up Time]
  
    Select @rowCnt=count(*) From #tmp2

    Select * From #tmp2
    Order by e_LeadID desc,[Follow-Up Date],[Follow-Up Time]
    Offset (@curPage-1)*@pageSize rows
    Fetch next @pageSize rows only

    Drop table #tmp2
  End


  Delete @rptKeys Where [key] in (''Sheet Title'',''Sheet Code'')
  Insert into @rptKeys values(''Sheet Title'',''Lead Follow-Ups'')
  Insert into @rptKeys values(''Sheet Code'',''followups'')

  Select * From @rptKeys
  UNION ALL
  Select ''Total Record'',cast(isnull(@rowCnt,0) as varchar(20))
End

Drop table #tmpLead
/*
exec rptLeads 1
exec rptLeads 1,null,null,10,1,1
exec rptLeads 1,null,null,10,2,1
exec rptLeads 1,''2021/1/1'',''2021/3/31''
exec rptLeads 1,''2021/1/1'',''2021/3/31'',10,1,1
exec rptLeads 1,''2021/1/1'',''2021/12/17'',10,2,1
exec rptLeads 1,''2021/1/1'',''2021/12/17'',10,3,1
exec rptLeads 1,''2021/1/1'',''2021/12/17'',10,1,2
*/
END
    ')
END
