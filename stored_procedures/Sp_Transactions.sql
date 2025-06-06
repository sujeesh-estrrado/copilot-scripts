IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Transactions]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Transactions]
(
@flag bigint =0,
@transactionid bigint = 0
)
as
begin
    if(@flag=1)
    begin
        SELECT [transactionid]
              ,[accountcodeid]
              ,[docno]
              ,[description]
              ,[amount]
              ,[balance]
              ,[paymentmethod]
              ,[transactiontype]
              ,[remarks]
              ,[datetimeissued]
              ,[dateissued]
              ,[refdocno]
              ,[refdocdate]
              ,[cashierid]
              ,[studentid]
              ,[courseid]
              ,[semesterno]
              ,[intakeid]
              ,[semesterid]
              ,[billid]
              ,[billgroupid]
              ,[relatedid]
              ,[adjustedid]
              ,[adjustmentamount]
              ,[canadjust]
              ,[thirdpartyid]
              ,[printcount]
              ,[billcancel]
              ,[flagledger]
              ,[Status]
          FROM [dbo].[student_transaction]
          where [transactionid] = @transactionid
    end
    if(@flag=2)
    begin
        SELECT [receiptid]
                    ,[receiptnumber]
                    ,[accountcodeid]
                    ,[description]
                    ,[amount]
                    ,[payment]
                    ,[balance]
                    ,[paymentmethod]
                    ,[remarks]
                    ,[datetimeissued]
                    ,[cashierid]
                    ,[studentid]
                    ,[transactionid]
                    ,[billid]
                    ,[dateissued]
                    ,[bankname]
                    ,[refno]
                    ,[checkdate]
                    ,[adjustmentamount]
                    ,[canadjust]
                    ,[flagledger]
                    ,(amount-adjustmentamount) as adjustableAmount
        FROM [dbo].[student_payment]
        where transactionid = @transactionid
                
        order by receiptid desc 
    end

end 
    ')
END
