IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentLedger]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[sp_StudentLedger] --33,''M''
--[dbo].[sp_StudentLedger] 1,''M''
(
@StudentID bigint,
@FlagLedger char,
@courseID bigint=0
)
as
begin
if(@FlagLedger=''A'')
BEGIN
SELECT        ST.transactionid, ST.dateissued,
    case 
        when(ST.transactiontype=0) then SBG.docno 
        else  ST.docno
    end as docno,
    case 
        when(ST.transactiontype=0) then concat(AC.name,'' - '',ST.description) 
        else  ST.description
    end as description,
    --concat(AC.name,''-'',ST.description)as description,
     CAST(ST.amount as decimal(18,2)) as amount, ST.transactiontype,
    case when (SBG.billgroupid is NULL or SBG.billgroupid='''') then 0 else SBG.billgroupid end as billgroupid,
    ST.canadjust --,(select Approvalstatus from Approval_Request where studentid=@StudentID)
    ,0 as Approvalstatus, COALESCE(relatedid,0) as adjustmentamount, AC.name as code,ST.dateissued--,ST.adjustmentamount
            
FROM            dbo.student_bill AS SB INNER JOIN
                         dbo.ref_accountcode AS AC ON SB.accountcodeid = AC.id RIGHT OUTER JOIN
                         dbo.student_transaction AS ST ON SB.billid = ST.billid LEFT OUTER JOIN
                         dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid
                         --left join Approval_Request  AR on st.studentid = AR.studentid
                         --left join Tbl_Candidate_Personal_Det p on SB.studentid=p.Candidate_Id
    where  ST.studentid = @StudentID  and ST.billcancel = 0
    and (ST.courseid = @courseID or @courseID =0)
    order by ST.dateissued
end
ELSE
BEGIN
    SELECT        ST.transactionid, ST.dateissued,
    case 
        when(ST.transactiontype=0) then SBG.docno 
        else  ST.docno
    end as docno,
    case 
        when(ST.transactiontype=0) then concat(AC.name,'' - '',ST.description) 
        else  ST.description
    end as description,
    --concat(AC.name,''-'',ST.description)as description,
     CAST(ST.amount as decimal(18,2)) as amount, ST.transactiontype,
    case when (SBG.billgroupid is NULL or SBG.billgroupid='''') then 0 else SBG.billgroupid end as billgroupid,
    ST.canadjust --,(select Approvalstatus from Approval_Request where studentid=@StudentID)
    ,0 as Approvalstatus, COALESCE(relatedid,0) as adjustmentamount, AC.name as code,ST.dateissued--,ST.adjustmentamount
            
FROM            dbo.student_bill AS SB INNER JOIN
                         dbo.ref_accountcode AS AC ON SB.accountcodeid = AC.id RIGHT OUTER JOIN
                         dbo.student_transaction AS ST ON SB.billid = ST.billid LEFT OUTER JOIN
                         dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid
                         --left join Approval_Request  AR on st.studentid = AR.studentid
                         --left join Tbl_Candidate_Personal_Det p on SB.studentid=p.Candidate_Id
    where  ST.studentid = @StudentID and (ST.flagledger = @FlagLedger or @FlagLedger is null) and ST.billcancel = 0
    and (ST.courseid = @courseID or @courseID =0)
    order by ST.dateissued
end
END
    ')
END
