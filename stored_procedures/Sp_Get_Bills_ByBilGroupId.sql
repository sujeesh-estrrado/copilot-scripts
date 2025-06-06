IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Bills_ByBilGroupId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_Bills_ByBilGroupId]
        @BilGroupId BIGINT
        AS
        BEGIN
            SELECT        
                bg.docno, 
                b.totalamountpayable,
                CONCAT(A.name, '' - '', b.description) AS description, 
                CASE 
                    WHEN taxcode_id = 1 THEN ''S'' 
                    WHEN taxcode_id = 2 THEN ''E'' 
                    WHEN taxcode_id = 3 THEN ''Z'' 
                END AS [taxcode_id],
                bg.docno AS Expr1, 
                bg.totalamount, 
                bg.studentid,
                CONVERT(VARCHAR, bg.dateissued, 105) AS dateissued, 
                bg.createdby AS cashierid
            FROM 
                dbo.student_bill_group AS bg 
            LEFT OUTER JOIN 
                dbo.student_bill AS b ON b.billgroupid = bg.billgroupid 
            LEFT OUTER JOIN 
                dbo.ref_accountcode AS A ON b.accountcodeid = A.id
            WHERE 
                bg.billgroupid = @BilGroupId
        END
    ')
END
