IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_paymentDetails]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[Sp_Get_paymentDetails]-- 622894
 -- Sp_Get_paymentDetails 4  
 @transactionid bigint  
AS  
BEGIN  
SELECT        CAST(p.amount AS decimal(18, 2)) AS amount, (case when p.description <>'''' then  p.description else  A.name end) as description ,  
    CONVERT(VARCHAR(10),  p.dateissued, 105) as  dateissued, t.amount AS totalamount, t.docno, CONVERT(varchar, t.refdocdate, 105) AS TransDocDate,  
     A.taxcode_id, ME.name AS methodofpay, ME.id,t.paymentmethod, p.refno, t.studentid,bg.docno as invoiceno,   
                BAN.name AS bankname, t.remarks,  
    (CASE WHEN A.taxcode_id IS NULL THEN ''E'' WHEN A.taxcode_id = ''0'' THEN ''E'' WHEN A.taxcode_id = '''' THEN ''-NA-'' when taxcode_id=1 then ''S'' when taxcode_id=2 then ''E'' when taxcode_id=3 then ''Z'' ELSE A.taxcode_id END) AS reftaxcode,  
    t.cashierid,t.accountcodeid AS Expr2,p.transactionid, p.checkdate  
FROM            dbo.student_payment AS p left JOIN  
                         dbo.ref_accountcode AS A ON p.accountcodeid = A.id LEFT OUTER JOIN  
                         dbo.student_transaction AS t ON p.transactionid = t.transactionid LEFT OUTER JOIN  
                         dbo.fixed_payment_method AS ME ON t.paymentmethod = ME.id LEFT OUTER JOIN  
                         dbo.ref_bank AS BAN ON p.bankname = BAN.id   left join 
                         student_bill b on b.billid=p.billid left join 
                         student_bill_group bg on bg.billgroupid=b.billgroupid
where p.transactionid=@transactionid  
  
  
END
    ')
END
GO