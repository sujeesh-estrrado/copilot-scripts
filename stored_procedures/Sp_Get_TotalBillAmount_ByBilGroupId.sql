IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_TotalBillAmount_ByBilGroupId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       create procedure [dbo].[Sp_Get_TotalBillAmount_ByBilGroupId]
	@BilGroupId bigint
AS
BEGIN
	SELECT       SUM(b.totalamountpayable) AS TotalAmt
	FROM            dbo.student_bill_group AS bg LEFT OUTER JOIN
					dbo.student_bill AS b ON b.billgroupid = bg.billgroupid LEFT OUTER JOIN
					dbo.ref_accountcode AS A ON b.accountcodeid = A.id
	where bg.billgroupid=@BilGroupId
END
    ')
END
