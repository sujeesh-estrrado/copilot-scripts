-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[getLeads]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[getLeads]
(
    @generateBy bigint,
    @generateByEmail varchar(100)='''',
    @leadName nvarchar(200)='''',
    @leadIDNo varchar(50)='''',
    @sourceName varchar(200)='''',
    @sourceCat varchar(50)='''',
    @counsellorID bigint=0,
    @dtFrom datetime=null,
    @dtTo datetime=null,
    @pageSize smallint=0,
    @curPage smallint=1,
    @sortBy varchar(50)='''',
    @sortDir varchar(5)=''''
)    
as    
BEGIN
Declare @curDt date,
    @orgID tinyint=0,@isTeamLeader tinyint,@isLeader tinyint,
    @rowCnt int,@SQL nvarchar(max),@sortOrder varchar(200)

SET NOCOUNT ON

Set @curDt=convert(date,getdate())


Select @orgID=orgID,@isTeamLeader=isTeamLeader,@isLeader=isLeader From Tbl_SPOrg Where counsellorEmail=@generateByEmail

Create table #tmpLead(candidateID bigint primary key,sourceCat varchar(20))

If @generateBy=0 or @isLeader=1 or @orgID=0
Begin
    Insert into #tmpLead
    Select Candidate_Id,
        case when cpd.Source_name like ''%reutili%'' then ''Reutilization''
            when cpd.Source_name like ''%call%'' and cpd.Source_name like ''%cent%'' then ''Call Centre''
            when cpd.Source_name like ''%call in%'' then ''Call In''
            when cpd.Source_name like ''%walk in%'' then ''Walk In''
            when cpd.Source_name like ''%sql%'' then ''SQL''
            when cpd.Source_name like ''%event%'' then ''Event''
            when cpd.Source_name like ''%upu%'' then ''UPU''
            when cpd.Source_name like ''%stpm%'' then ''STPM''
            when cpd.Source_name like ''%hot%'' and cpd.Source_name like ''%tips%'' then ''SPM Hot Tips''
            when cpd.Source_name like ''%spm%'' then ''SPM''
            when cpd.Source_name like ''%open%'' and cpd.Source_name like ''%day%'' then ''Open Day''
            when cpd.Source_name like ''%star%'' and cpd.Source_name like ''%penang%'' then ''Education Fair''
            when cpd.Source_name like ''%edu%'' and cpd.Source_name like ''%fair%'' then ''Education Fair''
            when cpd.Source_name like ''%fair%'' then ''Education Fair''
            when cpd.Source_name like ''%study%'' and cpd.Source_name like ''%malaysia%'' then ''Email Enquiries''
            when cpd.Source_name like ''%email%'' then ''Email Enquiries''
            when cpd.Source_name like ''%fb%'' or cpd.Source_name like ''%facebook%'' then ''FB Landing Page''
            when cpd.Source_name like ''%zzupe%'' and cpd.sourcecategory=''facebook'' then ''FB Landing Page''
            when cpd.Source_name like ''%instagram%'' then ''IG Landing Page''
            when cpd.Source_name like ''%zzupe%'' and cpd.sourcecategory=''instagram'' then ''IG Landing Page''
            when cpd.Source_name like ''%zzupe%'' then ''Zzupe Landing Page''
            when cpd.Source_name like ''%landingi%'' then ''Zzupe Landing Page''
            else ''SPM'' end sourceCat
    From Tbl_Lead_Personal_Det cpd
    Where cpd.ApplicationStatus in (''Lead'')
        and (CounselorEmployee_id=@counsellorID or isnull(@counsellorID,0)<1)
        and (trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'' or isnull(@leadName,'''')='''')
        and (isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'' or isnull(@leadIDNo,'''')='''')
        and (isnull(Source_name,'''') like ''%''+@sourceName+''%'' or isnull(@sourceName,'''')='''')
        and (
            convert(date,RegDate)>=@dtFrom and convert(date,RegDate)<dateadd(day,1,@dtTo)
                or (@dtFrom is null and @dtTo is null)    
                or (@dtFrom is null and convert(date,RegDate)<dateadd(day,1,@dtTo))    
                or (convert(date,RegDate)>=@dtFrom and @dtTo is null)
            )
End
Else If @isTeamLeader=1
Begin
    Insert into #tmpLead
    Select Candidate_Id,
        case when cpd.Source_name like ''%reutili%'' then ''Reutilization''
            when cpd.Source_name like ''%call%'' and cpd.Source_name like ''%cent%'' then ''Call Centre''
            when cpd.Source_name like ''%call in%'' then ''Call In''
            when cpd.Source_name like ''%walk in%'' then ''Walk In''
            when cpd.Source_name like ''%sql%'' then ''SQL''
            when cpd.Source_name like ''%event%'' then ''Event''
            when cpd.Source_name like ''%upu%'' then ''UPU''
            when cpd.Source_name like ''%stpm%'' then ''STPM''
            when cpd.Source_name like ''%hot%'' and cpd.Source_name like ''%tips%'' then ''SPM Hot Tips''
            when cpd.Source_name like ''%spm%'' then ''SPM''
            when cpd.Source_name like ''%open%'' and cpd.Source_name like ''%day%'' then ''Open Day''
            when cpd.Source_name like ''%star%'' and cpd.Source_name like ''%penang%'' then ''Education Fair''
            when cpd.Source_name like ''%edu%'' and cpd.Source_name like ''%fair%'' then ''Education Fair''
            when cpd.Source_name like ''%fair%'' then ''Education Fair''
            when cpd.Source_name like ''%study%'' and cpd.Source_name like ''%malaysia%'' then ''Email Enquiries''
            when cpd.Source_name like ''%email%'' then ''Email Enquiries''
            when cpd.Source_name like ''%fb%'' or cpd.Source_name like ''%facebook%'' then ''FB Landing Page''
            when cpd.Source_name like ''%zzupe%'' and cpd.sourcecategory=''facebook'' then ''FB Landing Page''
            when cpd.Source_name like ''%instagram%'' then ''IG Landing Page''
            when cpd.Source_name like ''%zzupe%'' and cpd.sourcecategory=''instagram'' then ''IG Landing Page''
            when cpd.Source_name like ''%zzupe%'' then ''Zzupe Landing Page''
            when cpd.Source_name like ''%landingi%'' then ''Zzupe Landing Page''
            else ''SPM'' end sourceCat
    From Tbl_Lead_Personal_Det cpd
        inner join Tbl_Employee ec on cpd.CounselorEmployee_id=ec.Employee_Id
    Where cpd.ApplicationStatus in (''Lead'')
        and Employee_Mail in
            (Select counsellorEmail From Tbl_SPOrg Where orgID=@orgID)
        and (CounselorEmployee_id=@counsellorID or isnull(@counsellorID,0)<1)
        and (trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'' or isnull(@leadName,'''')='''')
        and (isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'' or isnull(@leadIDNo,'''')='''')
        and (isnull(Source_name,'''') like ''%''+@sourceName+''%'' or isnull(@sourceName,'''')='''')
        and (
            convert(date,RegDate)>=@dtFrom and convert(date,RegDate)<dateadd(day,1,@dtTo)
                or (@dtFrom is null and @dtTo is null)    
                or (@dtFrom is null and convert(date,RegDate)<dateadd(day,1,@dtTo))    
                or (convert(date,RegDate)>=@dtFrom and @dtTo is null)
            )
End
Else
Begin
    Insert into #tmpLead
    Select Candidate_Id,
        case when cpd.Source_name like ''%reutili%'' then ''Reutilization''
            when cpd.Source_name like ''%call%'' and cpd.Source_name like ''%cent%'' then ''Call Centre''
            when cpd.Source_name like ''%call in%'' then ''Call In''
            when cpd.Source_name like ''%walk in%'' then ''Walk In''
            when cpd.Source_name like ''%sql%'' then ''SQL''
            when cpd.Source_name like ''%event%'' then ''Event''
            when cpd.Source_name like ''%upu%'' then ''UPU''
            when cpd.Source_name like ''%stpm%'' then ''STPM''
            when cpd.Source_name like ''%hot%'' and cpd.Source_name like ''%tips%'' then ''SPM Hot Tips''
            when cpd.Source_name like ''%spm%'' then ''SPM''
            when cpd.Source_name like ''%open%'' and cpd.Source_name like ''%day%'' then ''Open Day''
            when cpd.Source_name like ''%star%'' and cpd.Source_name like ''%penang%'' then ''Education Fair''
            when cpd.Source_name like ''%edu%'' and cpd.Source_name like ''%fair%'' then ''Education Fair''
            when cpd.Source_name like ''%fair%'' then ''Education Fair''
            when cpd.Source_name like ''%study%'' and cpd.Source_name like ''%malaysia%'' then ''Email Enquiries''
            when cpd.Source_name like ''%email%'' then ''Email Enquiries''
            when cpd.Source_name like ''%fb%'' or cpd.Source_name like ''%facebook%'' then ''FB Landing Page''
            when cpd.Source_name like ''%zzupe%'' and cpd.sourcecategory=''facebook'' then ''FB Landing Page''
            when cpd.Source_name like ''%instagram%'' then ''IG Landing Page''
            when cpd.Source_name like ''%zzupe%'' and cpd.sourcecategory=''instagram'' then ''IG Landing Page''
            when cpd.Source_name like ''%zzupe%'' then ''Zzupe Landing Page''
            when cpd.Source_name like ''%landingi%'' then ''Zzupe Landing Page''
            else ''SPM'' end sourceCat
    From Tbl_Lead_Personal_Det cpd
    Where cpd.ApplicationStatus in (''Lead'')
        and CounselorEmployee_id=@generateBy
        and (trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'' or isnull(@leadName,'''')='''')
        and (isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'' or isnull(@leadIDNo,'''')='''')
        and (isnull(Source_name,'''') like ''%''+@sourceName+''%'' or isnull(@sourceName,'''')='''')
        and (
            convert(date,RegDate)>=@dtFrom and convert(date,RegDate)<dateadd(day,1,@dtTo)
                or (@dtFrom is null and @dtTo is null)    
                or (@dtFrom is null and convert(date,RegDate)<dateadd(day,1,@dtTo))    
                or (convert(date,RegDate)>=@dtFrom and @dtTo is null)
            )
End




If @pageSize=0
Begin
    Select fcpd.candidateID ID,
        trim(concat(trim(cpd.Candidate_Fname),'' '',trim(cpd.Candidate_Lname))) [Full Name],cpd.AdharNumber [ID No],
        CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
        cpd.Scolorship_Remark Remark,
        RegDate [Lead Reg Date],
        cpd.Source_name [Source],
        fcpd.sourceCat [Source Category],
        trim(concat(trim(EC.Employee_FName),'' '',trim(EC.Employee_LName))) Counsellor,
        case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
        case when cpd.ApplicationStatus in (''Lead'',''Rejected'') then cpd.ApplicationStatus
            else ''Moved To Enquiry'' end [Application Status],
        FD.Respond_Type [Follow-Up Status]
    From #tmpLead fcpd
        inner join Tbl_Lead_Personal_Det cpd on fcpd.candidateID=cpd.Candidate_id
        inner join Tbl_Employee EC on EC.Employee_Id=cpd.CounselorEmployee_id
        left outer join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
        left outer join Tbl_Lead_ContactDetails CC on cpd.Candidate_Id=CC.Candidate_Id
        left outer join Tbl_Nationality N on cpd.Candidate_Nationality=N.Nationality_Id
        left outer join
            (Select Candidate_Id,Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
            From Tbl_FollowUpLead_Detail
            Where isnull(Delete_Status,0)=0
                and Follow_Up_Detail_Id in
                    (Select max(Follow_Up_Detail_Id)
                    From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
                    Where isnull(Delete_Status,0)=0
                    Group by fud.Candidate_Id)
                and Action_Taken=0) FD on cpd.Candidate_Id=FD.Candidate_Id
        left outer join Tbl_LandingiURL pg on cpd.Page_Id=LandingiURL_Id
        left outer join Tbl_LeadAssign lcl on cpd.Candidate_Id=lcl.Candidate_Id and lcl.isLatest=1
        left outer join Tbl_LeadAssign lcp on cpd.Candidate_Id=lcp.Candidate_Id and lcp.isPrev=1
        left outer join Tbl_Employee pec on lcp.CounselorEmployee_id=pec.Employee_Id
    Where (fcpd.sourceCat=@sourceCat or isnull(@sourceCat,'''')='''')
    Order by [Lead Reg Date] desc,ID desc
    Select @@ROWCOUNT rowCnt
End
Else
Begin
    Select fcpd.candidateID ID,
        trim(concat(trim(cpd.Candidate_Fname),'' '',trim(cpd.Candidate_Lname))) [Full Name],cpd.AdharNumber [ID No],
        CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
        cpd.Scolorship_Remark Remark,
        RegDate [Lead Reg Date],
        cpd.Source_name [Source],
        fcpd.sourceCat [Source Category],
        trim(concat(trim(EC.Employee_FName),'' '',trim(EC.Employee_LName))) Counsellor,
        case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
        case when cpd.ApplicationStatus in (''Lead'',''Rejected'') then cpd.ApplicationStatus
            else ''Moved To Enquiry'' end [Application Status],
        FD.Respond_Type [Follow-Up Status]
    Into #tmp1
    From #tmpLead fcpd
        inner join Tbl_Lead_Personal_Det cpd on fcpd.candidateID=cpd.Candidate_id
        inner join Tbl_Employee EC on EC.Employee_Id=cpd.CounselorEmployee_id
        left outer join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
        left outer join Tbl_Lead_ContactDetails CC on cpd.Candidate_Id=CC.Candidate_Id
        left outer join Tbl_Nationality N on cpd.Candidate_Nationality=N.Nationality_Id
        left outer join
            (Select Candidate_Id,Next_Date,Respond_Type,Followup_Date,Followup_time,Remarks
            From Tbl_FollowUpLead_Detail
            Where isnull(Delete_Status,0)=0
                and Follow_Up_Detail_Id in
                    (Select max(Follow_Up_Detail_Id)
                    From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
                    Where isnull(Delete_Status,0)=0
                    Group by fud.Candidate_Id)
                and Action_Taken=0) FD on cpd.Candidate_Id=FD.Candidate_Id
        left outer join Tbl_LandingiURL pg on cpd.Page_Id=LandingiURL_Id
        left outer join Tbl_LeadAssign lcl on cpd.Candidate_Id=lcl.Candidate_Id and lcl.isLatest=1
        left outer join Tbl_LeadAssign lcp on cpd.Candidate_Id=lcp.Candidate_Id and lcp.isPrev=1
        left outer join Tbl_Employee pec on lcp.CounselorEmployee_id=pec.Employee_Id
    Where (fcpd.sourceCat=@sourceCat or isnull(@sourceCat,'''')='''')
    
    Select @rowCnt=count(*) From #tmp1

    If isnull(@sortBy,'''')=''''
        Select @sortOrder=''[Lead Reg Date] desc,ID desc''
    Else
        Select @sortOrder=''[''+@sortBy+'']''+case isnull(@sortDir,'''') when '''' then '''' else '' ''+@sortDir end

    Select @SQL=
    ''Select * From #tmp1'' +
    '' Order by '' + @sortOrder +
    '' Offset '' + str((@curPage-1)*@pageSize) + '' rows'' +
    '' Fetch next '' + str(@pageSize) + '' rows only''

    Exec sp_executesql @sql

    Select @rowCnt rowCnt
        
    Drop table #tmp1
End

Drop table #tmpLead
/*
exec getLeads 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31''
exec getLeads 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',10,1
exec getLeads 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',10,2
exec getLeads 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',10,10
exec getLeads 0,'''','''','''','''','''',1334,null,null
exec getLeads 0,'''','''','''','''','''',1334,null,null,10,1
exec getLeads 0,'''','''','''','''','''',1334,null,null,10,2
exec getLeads 0,'''','''','''','''','''',1334,null,null,10,10
*/
END
    ')
END;
GO
