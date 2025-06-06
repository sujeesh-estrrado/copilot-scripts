IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[getLeads3]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[getLeads3]
(
    @generateBy bigint,
    @generateByEmail varchar(100)='''',
    @leadName nvarchar(200)='''',
    @leadIDNo varchar(50)='''',
    @sourceName varchar(200)='''',
    @sourceCat varchar(50)='''',
    @counsellorID bigint=0,
    @regDtFrom datetime=null,
    @regDtTo datetime=null,
    @nextFUpDtFrom datetime=null,
    @nextFUpDtTo datetime=null,
    @followupStatus varchar(50)='''',
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
Create table #tmpEnq(candidateID bigint primary key,sourceCat varchar(20))

If @generateBy=0 or @isLeader=1 or @orgID=0
Begin
    Insert into #tmpLead
    Select Candidate_Id,
        case when cpd.Source_name like ''%reutili%'' then ''Reutilization''
            when cpd.Source_name like ''%call%'' and cpd.Source_name like ''%cent%'' then ''Call Centre''
            when cpd.Source_name like ''%call in%'' then ''Call In''
            when cpd.Source_name like ''%walk in%'' then ''Walk In''
            when cpd.Source_name like ''%event%'' then ''Event''
            when cpd.Source_name like ''%upu%'' then ''UPU''
            when cpd.Source_name like ''%stpm%'' then ''STPM''
            when cpd.Source_name like ''%hot%'' and cpd.Source_name like ''%tips%'' then ''SPM Hot Tips''
            when cpd.Source_name like ''%spm%'' then ''SPM''
            when cpd.Source_name like ''%open%'' and cpd.Source_name like ''%day%'' then ''Open Day''
            when cpd.Source_name like ''%yes2malaysia%'' then ''Education Fair''
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
            when cpd.Source_name like ''%ce%'' then ''CE''
            when cpd.Source_name like ''%sql%'' then ''SQL''
            else ''SPM'' end sourceCat
    From Tbl_Lead_Personal_Det cpd
    Where cpd.ApplicationStatus in (''Lead'')
        and (isnull(@counsellorID,0)<1 or CounselorEmployee_id=@counsellorID)
        and (isnull(@leadName,'''')='''' or trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'')
        and (isnull(@leadIDNo,'''')='''' or isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'')
        and (isnull(@sourceName,'''')='''' or isnull(Source_name,'''') like ''%''+@sourceName+''%'')
        and ((@regDtFrom is null and @regDtTo is null)
                or (@regDtFrom is null and convert(date,RegDate)<dateadd(day,1,@regDtTo))
                or (@regDtTo is null and convert(date,RegDate)>=@regDtFrom)
                or convert(date,RegDate)>=@regDtFrom and convert(date,RegDate)<dateadd(day,1,@regDtTo)
            )

    Insert into #tmpEnq
    Select Candidate_Id,
        case when isnull(cpd.Parish,'''') like ''%reutili%'' then ''Reutilization''
            when isnull(cpd.Parish,'''') like ''%call%'' and isnull(cpd.Parish,'''') like ''%cent%'' then ''Call Centre''
            when isnull(cpd.Parish,'''') like ''%call in%'' then ''Call In''
            when isnull(cpd.Parish,'''') like ''%walk in%'' then ''Walk In''
            when isnull(cpd.Parish,'''') like ''%event%'' then ''Event''
            when isnull(cpd.Parish,'''') like ''%upu%'' then ''UPU''
            when isnull(cpd.Parish,'''') like ''%stpm%'' then ''STPM''
            when isnull(cpd.Parish,'''') like ''%hot%'' and isnull(cpd.Parish,'''') like ''%tips%'' then ''SPM Hot Tips''
            when isnull(cpd.Parish,'''') like ''%spm%'' then ''SPM''
            when isnull(cpd.Parish,'''') like ''%open%'' and isnull(cpd.Parish,'''') like ''%day%'' then ''Open Day''
            when isnull(cpd.Parish,'''') like ''%yes2malaysia%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%star%'' and isnull(cpd.Parish,'''') like ''%penang%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%edu%'' and isnull(cpd.Parish,'''') like ''%fair%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%fair%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%study%'' and isnull(cpd.Parish,'''') like ''%malaysia%'' then ''Email Enquiries''
            when isnull(cpd.Parish,'''') like ''%email%'' then ''Email Enquiries''
            when isnull(cpd.Parish,'''') like ''%fb%'' or isnull(cpd.Parish,'''') like ''%facebook%'' then ''FB Landing Page''
            --when isnull(cpd.Parish,'''') like ''%zzupe%'' and cpd.sourcecategory=''facebook'' then ''FB Landing Page''
            when isnull(cpd.Parish,'''') like ''%instagram%'' then ''IG Landing Page''
            --when isnull(cpd.Parish,'''') like ''%zzupe%'' and cpd.sourcecategory=''instagram'' then ''IG Landing Page''
            when isnull(cpd.Parish,'''') like ''%zzupe%'' then ''Zzupe Landing Page''
            when isnull(cpd.Parish,'''') like ''%landingi%'' then ''Zzupe Landing Page''
            when isnull(cpd.Parish,'''') like ''%ce%'' then ''CE''
            when isnull(cpd.Parish,'''') like ''%sql%'' then ''SQL''
            else '''' end sourceCat
    From Tbl_Candidate_Personal_Det cpd
    Where cpd.ApplicationStatus in (''pending'',''submited'')
        and (isnull(@counsellorID,0)<1 or CounselorEmployee_id=@counsellorID)
        and (isnull(@leadName,'''')='''' or trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'')
        and (isnull(@leadIDNo,'''')='''' or isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'')
        and (isnull(@sourceName,'''')='''' or isnull(Parish,'''') like ''%''+@sourceName+''%'')
        and ((@regDtFrom is null and @regDtTo is null)
                or (@regDtFrom is null and convert(date,RegDate)<dateadd(day,1,@regDtTo))    
                or (@regDtTo is null and convert(date,RegDate)>=@regDtFrom)
                or convert(date,RegDate)>=@regDtFrom and convert(date,RegDate)<dateadd(day,1,@regDtTo)
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
            when cpd.Source_name like ''%event%'' then ''Event''
            when cpd.Source_name like ''%upu%'' then ''UPU''
            when cpd.Source_name like ''%stpm%'' then ''STPM''
            when cpd.Source_name like ''%hot%'' and cpd.Source_name like ''%tips%'' then ''SPM Hot Tips''
            when cpd.Source_name like ''%spm%'' then ''SPM''
            when cpd.Source_name like ''%open%'' and cpd.Source_name like ''%day%'' then ''Open Day''
            when cpd.Source_name like ''%yes2malaysia%'' then ''Education Fair''
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
            when cpd.Source_name like ''%ce%'' then ''CE''
            when cpd.Source_name like ''%sql%'' then ''SQL''
            else ''SPM'' end sourceCat
    From Tbl_Lead_Personal_Det cpd
        inner join Tbl_Employee ec on cpd.CounselorEmployee_id=ec.Employee_Id
    Where cpd.ApplicationStatus in (''Lead'')
        and Employee_Mail in
            (Select counsellorEmail From Tbl_SPOrg Where orgID=@orgID)
        and (isnull(@counsellorID,0)<1 or CounselorEmployee_id=@counsellorID)
        and (isnull(@leadName,'''')='''' or trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'')
        and (isnull(@leadIDNo,'''')='''' or isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'')
        and (isnull(@sourceName,'''')='''' or isnull(Source_name,'''') like ''%''+@sourceName+''%'')
        and ((@regDtFrom is null and @regDtTo is null)
                or (@regDtFrom is null and convert(date,RegDate)<dateadd(day,1,@regDtTo))
                or (@regDtTo is null and convert(date,RegDate)>=@regDtFrom)
                or convert(date,RegDate)>=@regDtFrom and convert(date,RegDate)<dateadd(day,1,@regDtTo)
            )

    Insert into #tmpEnq
    Select Candidate_Id,
        case when isnull(cpd.Parish,'''') like ''%reutili%'' then ''Reutilization''
            when isnull(cpd.Parish,'''') like ''%call%'' and isnull(cpd.Parish,'''') like ''%cent%'' then ''Call Centre''
            when isnull(cpd.Parish,'''') like ''%call in%'' then ''Call In''
            when isnull(cpd.Parish,'''') like ''%walk in%'' then ''Walk In''
            when isnull(cpd.Parish,'''') like ''%event%'' then ''Event''
            when isnull(cpd.Parish,'''') like ''%upu%'' then ''UPU''
            when isnull(cpd.Parish,'''') like ''%stpm%'' then ''STPM''
            when isnull(cpd.Parish,'''') like ''%hot%'' and isnull(cpd.Parish,'''') like ''%tips%'' then ''SPM Hot Tips''
            when isnull(cpd.Parish,'''') like ''%spm%'' then ''SPM''
            when isnull(cpd.Parish,'''') like ''%open%'' and isnull(cpd.Parish,'''') like ''%day%'' then ''Open Day''
            when isnull(cpd.Parish,'''') like ''%yes2malaysia%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%star%'' and isnull(cpd.Parish,'''') like ''%penang%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%edu%'' and isnull(cpd.Parish,'''') like ''%fair%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%fair%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%study%'' and isnull(cpd.Parish,'''') like ''%malaysia%'' then ''Email Enquiries''
            when isnull(cpd.Parish,'''') like ''%email%'' then ''Email Enquiries''
            when isnull(cpd.Parish,'''') like ''%fb%'' or isnull(cpd.Parish,'''') like ''%facebook%'' then ''FB Landing Page''
            --when isnull(cpd.Parish,'''') like ''%zzupe%'' and cpd.sourcecategory=''facebook'' then ''FB Landing Page''
            when isnull(cpd.Parish,'''') like ''%instagram%'' then ''IG Landing Page''
            --when isnull(cpd.Parish,'''') like ''%zzupe%'' and cpd.sourcecategory=''instagram'' then ''IG Landing Page''
            when isnull(cpd.Parish,'''') like ''%zzupe%'' then ''Zzupe Landing Page''
            when isnull(cpd.Parish,'''') like ''%landingi%'' then ''Zzupe Landing Page''
            when isnull(cpd.Parish,'''') like ''%ce%'' then ''CE''
            when isnull(cpd.Parish,'''') like ''%sql%'' then ''SQL''
            else '''' end sourceCat
    From Tbl_Candidate_Personal_Det cpd
        inner join Tbl_Employee ec on cpd.CounselorEmployee_id=ec.Employee_Id
    Where cpd.ApplicationStatus in (''pending'',''submited'')
        and Employee_Mail in
            (Select counsellorEmail From Tbl_SPOrg Where orgID=@orgID)
        and (isnull(@counsellorID,0)<1 or CounselorEmployee_id=@counsellorID)
        and (isnull(@leadName,'''')='''' or trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'')
        and (isnull(@leadIDNo,'''')='''' or isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'')
        and (isnull(@sourceName,'''')='''' or isnull(Parish,'''') like ''%''+@sourceName+''%'')
        and ((@regDtFrom is null and @regDtTo is null)
                or (@regDtFrom is null and convert(date,RegDate)<dateadd(day,1,@regDtTo))    
                or (@regDtTo is null and convert(date,RegDate)>=@regDtFrom)
                or convert(date,RegDate)>=@regDtFrom and convert(date,RegDate)<dateadd(day,1,@regDtTo)
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
            when cpd.Source_name like ''%event%'' then ''Event''
            when cpd.Source_name like ''%upu%'' then ''UPU''
            when cpd.Source_name like ''%stpm%'' then ''STPM''
            when cpd.Source_name like ''%hot%'' and cpd.Source_name like ''%tips%'' then ''SPM Hot Tips''
            when cpd.Source_name like ''%spm%'' then ''SPM''
            when cpd.Source_name like ''%open%'' and cpd.Source_name like ''%day%'' then ''Open Day''
            when cpd.Source_name like ''%yes2malaysia%'' then ''Education Fair''
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
            when cpd.Source_name like ''%ce%'' then ''CE''
            when cpd.Source_name like ''%sql%'' then ''SQL''
            else ''SPM'' end sourceCat
    From Tbl_Lead_Personal_Det cpd
    Where cpd.ApplicationStatus in (''Lead'')
        and CounselorEmployee_id=@generateBy
        and (isnull(@leadName,'''')='''' or trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'')
        and (isnull(@leadIDNo,'''')='''' or isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'')
        and (isnull(@sourceName,'''')='''' or isnull(Source_name,'''') like ''%''+@sourceName+''%'')
        and ((@regDtFrom is null and @regDtTo is null)
                or (@regDtFrom is null and convert(date,RegDate)<dateadd(day,1,@regDtTo))
                or (@regDtTo is null and convert(date,RegDate)>=@regDtFrom)
                or convert(date,RegDate)>=@regDtFrom and convert(date,RegDate)<dateadd(day,1,@regDtTo)
            )

    Insert into #tmpEnq
    Select Candidate_Id,
        case when isnull(cpd.Parish,'''') like ''%reutili%'' then ''Reutilization''
            when isnull(cpd.Parish,'''') like ''%call%'' and isnull(cpd.Parish,'''') like ''%cent%'' then ''Call Centre''
            when isnull(cpd.Parish,'''') like ''%call in%'' then ''Call In''
            when isnull(cpd.Parish,'''') like ''%walk in%'' then ''Walk In''
            when isnull(cpd.Parish,'''') like ''%event%'' then ''Event''
            when isnull(cpd.Parish,'''') like ''%upu%'' then ''UPU''
            when isnull(cpd.Parish,'''') like ''%stpm%'' then ''STPM''
            when isnull(cpd.Parish,'''') like ''%hot%'' and isnull(cpd.Parish,'''') like ''%tips%'' then ''SPM Hot Tips''
            when isnull(cpd.Parish,'''') like ''%spm%'' then ''SPM''
            when isnull(cpd.Parish,'''') like ''%open%'' and isnull(cpd.Parish,'''') like ''%day%'' then ''Open Day''
            when isnull(cpd.Parish,'''') like ''%yes2malaysia%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%star%'' and isnull(cpd.Parish,'''') like ''%penang%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%edu%'' and isnull(cpd.Parish,'''') like ''%fair%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%fair%'' then ''Education Fair''
            when isnull(cpd.Parish,'''') like ''%study%'' and isnull(cpd.Parish,'''') like ''%malaysia%'' then ''Email Enquiries''
            when isnull(cpd.Parish,'''') like ''%email%'' then ''Email Enquiries''
            when isnull(cpd.Parish,'''') like ''%fb%'' or isnull(cpd.Parish,'''') like ''%facebook%'' then ''FB Landing Page''
            --when isnull(cpd.Parish,'''') like ''%zzupe%'' and cpd.sourcecategory=''facebook'' then ''FB Landing Page''
            when isnull(cpd.Parish,'''') like ''%instagram%'' then ''IG Landing Page''
            --when isnull(cpd.Parish,'''') like ''%zzupe%'' and cpd.sourcecategory=''instagram'' then ''IG Landing Page''
            when isnull(cpd.Parish,'''') like ''%zzupe%'' then ''Zzupe Landing Page''
            when isnull(cpd.Parish,'''') like ''%landingi%'' then ''Zzupe Landing Page''
            when isnull(cpd.Parish,'''') like ''%ce%'' then ''CE''
            when isnull(cpd.Parish,'''') like ''%sql%'' then ''SQL''
            else '''' end sourceCat
    From Tbl_Candidate_Personal_Det cpd
    Where cpd.ApplicationStatus in (''pending'',''submited'')
        and CounselorEmployee_id=@generateBy
        and (isnull(@leadName,'''')='''' or trim(concat(trim(Candidate_FName),'' '',trim(Candidate_LName))) like ''%''+@leadName+''%'')
        and (isnull(@leadIDNo,'''')='''' or isnull(AdharNumber,'''') like ''%''+@leadIDNo+''%'')
        and (isnull(@sourceName,'''')='''' or isnull(Parish,'''') like ''%''+@sourceName+''%'')
        and ((@regDtFrom is null and @regDtTo is null)
                or (@regDtFrom is null and convert(date,RegDate)<dateadd(day,1,@regDtTo))    
                or (@regDtTo is null and convert(date,RegDate)>=@regDtFrom)
                or convert(date,RegDate)>=@regDtFrom and convert(date,RegDate)<dateadd(day,1,@regDtTo)
            )
End




If @pageSize=0
Begin
    Select fcpd.candidateID+100000000 ID,
        trim(concat(trim(cpd.Candidate_Fname),'' '',trim(cpd.Candidate_Lname))) [Full Name],cpd.AdharNumber [ID No],
        CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
        cpd.Scolorship_Remark Remark,
        RegDate [Reg Date],
        trim(concat(trim(EC.Employee_FName),'' '',trim(EC.Employee_LName))) Counsellor,
        case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
        isnull(leadStageName,'''') [Lead Stage],
        cpd.ApplicationStatus [Application Status],fup.Respond_Type [Follow-Up Status],
        cpd.Source_name [Source],fcpd.sourceCat [Source Category]
    From #tmpLead fcpd
        inner join Tbl_Lead_Personal_Det cpd on fcpd.candidateID=cpd.Candidate_id
        left join Tbl_Lead_ContactDetails CC on cpd.Candidate_Id=CC.Candidate_Id
        left join Tbl_Nationality N on cpd.Candidate_Nationality=N.Nationality_Id
        left join Tbl_Employee EC on EC.Employee_Id=cpd.CounselorEmployee_id
        left join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
        left join
            (Select Candidate_Id,Followup_Date,Followup_time,Respond_Type,Remarks,Next_Date
            From Tbl_FollowUpLead_Detail
            Where isnull(Delete_Status,0)=0
                and Follow_Up_Detail_Id in
                    (Select max(Follow_Up_Detail_Id)
                    From Tbl_FollowUpLead_Detail fup
                        inner join #tmpLead fcpd on fup.Candidate_Id=fcpd.candidateID
                    Where isnull(Delete_Status,0)=0
                    Group by fup.Candidate_Id)
                and Action_Taken=0
            ) fup on cpd.Candidate_Id=fup.Candidate_Id
        left join MDSDEV.dbo.vLeadLatestStage sfs on cpd.Candidate_Id=sfs.leadID and sfs.recordTypeID=1
    Where (isnull(@sourceCat,'''')='''' or fcpd.sourceCat=@sourceCat)
        and ((@nextFUpDtFrom is null and @nextFUpDtTo is null)
                or (Next_Date is not null
                    and (Next_Date>=isnull(@nextFUpDtFrom,''1900/1/1'') and Next_Date<dateadd(day,1,isnull(@nextFUpDtTo,''2099/12/31'')))                       
                    ))
        and (isnull(@followupStatus,'''')='''' or isnull(fup.Respond_Type,'''')=@followupStatus)
    UNION ALL
    Select fcpd.candidateID+200000000 ID,
        trim(concat(trim(cpd.Candidate_Fname),'' '',trim(cpd.Candidate_Lname))) [Full Name],cpd.AdharNumber [ID No],
        CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
        cpd.Scolorship_Remark Remark,
        RegDate [Reg Date],
        trim(concat(trim(EC.Employee_FName),'' '',trim(EC.Employee_LName))) Counsellor,
        case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
        isnull(leadStageName,'''') [Lead Stage],
        cpd.ApplicationStatus [Application Status],fup.Respond_Type [Follow-Up Status],
        cpd.Parish [Source],fcpd.sourceCat [Source Category]
    From #tmpEnq fcpd
        inner join Tbl_Candidate_Personal_Det cpd on fcpd.candidateID=cpd.Candidate_id
        left join Tbl_Candidate_ContactDetails cc on cpd.Candidate_Id=cc.Candidate_Id
        left join Tbl_Nationality N on cpd.Candidate_Nationality=N.Nationality_Id
        left join Tbl_Student_Registration sr on cpd.Candidate_Id=sr.Candidate_Id         
        left join Tbl_Employee ec on cpd.CounselorEmployee_id=ec.Employee_Id
        left join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
        left join
            (Select Candidate_Id,Followup_Date,Followup_time,Respond_Type,Remarks,Next_Date
            From Tbl_FollowUp_Detail
            Where isnull(Delete_Status,0)=0
                and Follow_Up_Detail_Id in
                    (Select max(Follow_Up_Detail_Id)
                    From Tbl_FollowUp_Detail fup
                        inner join #tmpEnq fcpd on fup.Candidate_Id=fcpd.candidateID
                    Where isnull(Delete_Status,0)=0
                    Group by Candidate_Id)
                and Action_Taken=0
            ) fup on fup.Candidate_Id=CPD.Candidate_Id
        left join MDSDEV.dbo.vLeadLatestStage sfs on cpd.Candidate_Id=sfs.leadID and sfs.recordTypeID=2
    Where (isnull(@sourceCat,'''')='''' or fcpd.sourceCat=@sourceCat)
        and ((@nextFUpDtFrom is null and @nextFUpDtTo is null)
                or (Next_Date is not null
                    and (Next_Date>=isnull(@nextFUpDtFrom,''1900/1/1'') and Next_Date<dateadd(day,1,isnull(@nextFUpDtTo,''2099/12/31'')))                       
                    ))
        and (isnull(@followupStatus,'''')='''' or isnull(fup.Respond_Type,'''')=@followupStatus)
    Order by [Reg Date] desc,ID desc
    Select @@ROWCOUNT rowCnt
End
Else
Begin
    Select fcpd.candidateID+100000000 ID,
        trim(concat(trim(cpd.Candidate_Fname),'' '',trim(cpd.Candidate_Lname))) [Full Name],cpd.AdharNumber [ID No],
        CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
        cpd.Scolorship_Remark Remark,
        RegDate [Reg Date],
        trim(concat(trim(EC.Employee_FName),'' '',trim(EC.Employee_LName))) Counsellor,
        case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
        isnull(leadStageName,'''') [Lead Stage],
        cpd.ApplicationStatus [Application Status],fup.Respond_Type [Follow-Up Status],
        cpd.Source_name [Source],fcpd.sourceCat [Source Category]
    Into #tmp1
    From #tmpLead fcpd
        inner join Tbl_Lead_Personal_Det cpd on fcpd.candidateID=cpd.Candidate_id
        left join Tbl_Employee EC on EC.Employee_Id=cpd.CounselorEmployee_id
        left join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
        left join Tbl_Lead_ContactDetails CC on cpd.Candidate_Id=CC.Candidate_Id
        left join Tbl_Nationality N on cpd.Candidate_Nationality=N.Nationality_Id
        left join
            (Select Candidate_Id,Followup_Date,Followup_time,Respond_Type,Remarks,Next_Date
            From Tbl_FollowUpLead_Detail
            Where isnull(Delete_Status,0)=0
                and Follow_Up_Detail_Id in
                    (Select max(Follow_Up_Detail_Id)
                    From Tbl_FollowUpLead_Detail fud inner join #tmpLead fcpd on fud.Candidate_Id=fcpd.candidateID
                    Where isnull(Delete_Status,0)=0
                    Group by fud.Candidate_Id)
                and Action_Taken=0
            ) fup on cpd.Candidate_Id=fup.Candidate_Id
        left join MDSDEV.dbo.vLeadLatestStage sfs on cpd.Candidate_Id=sfs.leadID and sfs.recordTypeID=1
    Where (isnull(@sourceCat,'''')='''' or fcpd.sourceCat=@sourceCat)
        and ((@nextFUpDtFrom is null and @nextFUpDtTo is null)
                or (Next_Date is not null
                    and (Next_Date>=isnull(@nextFUpDtFrom,''1900/1/1'') and Next_Date<dateadd(day,1,isnull(@nextFUpDtTo,''2099/12/31'')))                       
                    ))
        and (isnull(@followupStatus,'''')='''' or isnull(fup.Respond_Type,'''')=@followupStatus)

    Insert into #tmp1
    Select fcpd.candidateID+200000000 ID,
        trim(concat(trim(cpd.Candidate_Fname),'' '',trim(cpd.Candidate_Lname))) [Full Name],cpd.AdharNumber [ID No],
        CC.Candidate_Mob1 [Contact No],CC.Candidate_Email Email,isnull(N.Nationality,'''') Nationality,
        cpd.Scolorship_Remark Remark,
        RegDate [Reg Date],
        trim(concat(trim(EC.Employee_FName),'' '',trim(EC.Employee_LName))) Counsellor,
        case isnull(eco.orgID,0) when 1 then ''MU'' when 2 then ''MAIC'' when 3 then ''MCS'' when 4 then ''MURC Sw'' else '''' end [Counsellor Team],
        isnull(leadStageName,'''') [Lead Stage],
        cpd.ApplicationStatus [Application Status],fup.Respond_Type [Follow-Up Status],
        cpd.Parish [Source],fcpd.sourceCat [Source Category]
    From #tmpEnq fcpd
        inner join Tbl_Candidate_Personal_Det cpd on fcpd.candidateID=cpd.Candidate_id
        left join Tbl_Candidate_ContactDetails cc on cpd.Candidate_Id=cc.Candidate_Id
        left join Tbl_Nationality N on cpd.Candidate_Nationality=N.Nationality_Id
        left join Tbl_Student_Registration sr on cpd.Candidate_Id=sr.Candidate_Id         
        left join Tbl_Employee ec on cpd.CounselorEmployee_id=ec.Employee_Id
        left join Tbl_SPOrg eco on EC.Employee_Id=eco.counsellorID
        left join
            (Select Candidate_Id,Followup_Date,Followup_time,Respond_Type,Remarks,Next_Date
            From Tbl_FollowUp_Detail
            Where isnull(Delete_Status,0)=0
                and Follow_Up_Detail_Id in
                    (Select max(Follow_Up_Detail_Id)
                    From Tbl_FollowUp_Detail fup
                        inner join #tmpEnq fcpd on fup.Candidate_Id=fcpd.candidateID
                    Where isnull(Delete_Status,0)=0
                    Group by Candidate_Id)
                and Action_Taken=0
            ) fup on fup.Candidate_Id=CPD.Candidate_Id
        left join MDSDEV.dbo.vLeadLatestStage sfs on cpd.Candidate_Id=sfs.leadID and sfs.recordTypeID=2
    Where (isnull(@sourceCat,'''')='''' or fcpd.sourceCat=@sourceCat)
        and ((@nextFUpDtFrom is null and @nextFUpDtTo is null)
                or (Next_Date is not null
                    and (Next_Date>=isnull(@nextFUpDtFrom,''1900/1/1'') and Next_Date<dateadd(day,1,isnull(@nextFUpDtTo,''2099/12/31'')))                       
                    ))
        and (isnull(@followupStatus,'''')='''' or isnull(fup.Respond_Type,'''')=@followupStatus)
    
    Select @rowCnt=count(*) From #tmp1

    If isnull(@sortBy,'''')=''''
        Select @sortOrder=''[Reg Date] desc,ID desc''
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
exec getLeads3 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',null,null,''''
exec getLeads3 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',null,null,'''',10,1
exec getLeads3 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',null,null,'''',10,2
exec getLeads3 0,'''','''','''','''','''',0,''2022/7/1'',''2022/7/31'',null,null,'''',10,10
exec getLeads3 0,'''','''','''','''','''',1334,null,null,null,null,''''
exec getLeads3 0,'''',''deeshaalini'','''','''','''',0,null,null,null,null,'''',10,1
exec getLeads3 0,'''','''','''','''','''',1334,null,null,null,null,'''',10,2
exec getLeads3 0,'''','''','''','''','''',1334,null,null,null,null,'''',10,10
exec getLeads3 0,'''','''','''','''','''',1334,null,null,null,null,'''',10,1,''
*/
END
    ')
END
