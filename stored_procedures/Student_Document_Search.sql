IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Student_Document_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Student_Document_Search] 

--[dbo].[Student_Document_Search] ''LIYABEGU'',-1,0

@Name varchar(50)='''',
@type  bigint =-1,
@Accountcodeid bigint =0
as
begin
    if (@type=6)
        begin
                    SELECT    top 1000    ST.transactionid, CONVERT(varchar, ST.dateissued, 23)as dateissued,
                case 
                    when(ST.transactiontype=0) then SBG.docno 
                    else  ST.docno
                end as docno,
                CONCAT(AC.name, '' - '', ST.description) AS Description, ST.amount, ST.transactiontype,
                case when (SBG.billgroupid is NULL or SBG.billgroupid='''') then 0 else SBG.billgroupid end as billgroupid,st.studentid,
                ST.canadjust,CONCAT(Candidate_Fname,'' '',Candidate_Lname)as StudentName,ST.transactiontype,id as accountcodeid
            
            FROM            dbo.student_bill AS SB INNER JOIN
                                     dbo.ref_accountcode AS AC ON SB.accountcodeid = AC.id RIGHT OUTER JOIN
                                     dbo.student_transaction AS ST ON SB.billid = ST.billid LEFT OUTER JOIN
                                     dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid
                            
                                     left join Tbl_Candidate_Personal_Det pd on pd.Candidate_Id=ST.studentid
                where   St.billcancel=0 and (ST.description LIKE ''%'' + @Name + ''%'') 
            
    
        end

    if (@type=-2)
    begin
            SELECT   top 1000     ST.transactionid, CONVERT(varchar, ST.dateissued, 23) AS dateissued, CASE WHEN (ST.transactiontype = 0) THEN SBG.docno ELSE ST.docno END AS docno,
             ST.amount, SP.description  AS Description  , ST.transactiontype, 
                                 CASE WHEN (SBG.billgroupid IS NULL OR
                                 SBG.billgroupid = '''') THEN 0 ELSE SBG.billgroupid END AS billgroupid, ST.studentid, ST.canadjust, 
                            CONCAT(Candidate_Fname,'' '',Candidate_Lname) AS StudentName
        FROM            dbo.student_transaction AS ST INNER JOIN
                                 dbo.student_payment AS SP ON ST.transactionid = SP.transactionid LEFT OUTER JOIN
                                 dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid LEFT OUTER JOIN
                                 dbo.Tbl_Candidate_Personal_Det AS pd ON pd.Candidate_Id = ST.studentid
        WHERE        (ST.billcancel = 0) AND (ST.adjustedid LIKE ''%'' + @Name + ''%'')
    end

    else
        begin
                SELECT     top 1000   ST.transactionid, CONVERT(varchar, ST.dateissued, 23)as dateissued,
                case 
                    when(ST.transactiontype=0) then SBG.docno 
                    else  ST.docno
                end as docno,
                CONCAT(AC.name, '' - '', ST.description) AS Description, ST.amount, ST.transactiontype,
                case when (SBG.billgroupid is NULL or SBG.billgroupid='''') then 0 else SBG.billgroupid end as billgroupid,st.studentid,
                ST.canadjust,CONCAT(Candidate_Fname,'' '',Candidate_Lname)as StudentName,ST.transactiontype,id as accountcodeid
            
            FROM            dbo.student_bill AS SB INNER JOIN
                                     dbo.ref_accountcode AS AC ON SB.accountcodeid = AC.id RIGHT OUTER JOIN
                                     dbo.student_transaction AS ST ON SB.billid = ST.billid LEFT OUTER JOIN
                                     dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid
                                     left join Tbl_Candidate_Personal_Det pd on pd.Candidate_Id=ST.studentid
                where   St.billcancel=0 and  ((ST.docno LIKE ''%'' + @Name + ''%'') or(concat(pd.Candidate_Fname,pd.Candidate_Mname,pd.Candidate_Lname) LIKE ''%'' + @Name + ''%'') or (pd.Candidate_Fname LIKE ''%'' + @Name + ''%'') 
                or (pd.Candidate_Mname LIKE ''%'' + @Name + ''%'') or (pd.Candidate_Lname LIKE ''%'' + @Name + ''%'')or (sbg.docno LIKE ''%'' + @Name + ''%'') 
                or (pd.AdharNumber LIKE ''%'' + @Name + ''%'') or (pd.IDMatrixNo LIKE ''%'' + @Name + ''%'') or (ST.description LIKE ''%'' + @Name + ''%'') ) and (ST.transactiontype = @type or @type = -1)
                and (AC.id = @Accountcodeid or @Accountcodeid =0)
        end

END
    ')
END;
GO
