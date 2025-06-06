IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_student_bill_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Sp_student_bill_Insert]
    -- Add the parameters for the stored procedure here
    @accountcodeid bigint,
    @description varchar(255),
    @docno varchar(50),
    @studentid bigint,
    @totalamount decimal(18, 0),
    @totalamountpayable decimal(18, 0),
    @totalamountpaid decimal(18, 0),
    @outstandingbalance decimal(18, 0),
    @adjustmentamount decimal(18, 0),
    @amount decimal(18, 0),
    @balance decimal(18, 0),
    @paymentmethod bigint,
    @transactiontype bigint,
    @remarks varchar(255),
    @refdocno varchar(20),
    --@refdocdate datetime='''',
    @cashierid bigint,
    @courseid bigint,
    @semesterno bigint,
    @intakeid bigint,
    @semesterid bigint,
    @relatedid bigint,
    @adjustedid bigint,
    @thirdpartyid bigint,
    @canadjust bigint,
    @billcancel bigint,
    @dateissued datetime,
    @datedue datetime,
    @printcount bigint,
    @flagledger char(10),
    @createdby bigint,
    @result1 int out,
    @result2 int out
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
             SAVE TRANSACTION MySavePoint;
                 BEGIN TRY
                
                    Insert into student_bill_group(docno,studentid,totalamount,dateissued,
                    datedue,printcount,flagledger,createdby,datecreated)
                    values(@docno,@studentid,@totalamount,@dateissued,
                    @datedue,@printcount,@flagledger,@createdby,GETUTCDATE())
                    set @result1=@@IDENTITY


                    Insert into student_bill(accountcodeid,docno,[description],studentid,totalamountpayable,
                    totalamountpaid,outstandingbalance,billgroupid,dateissue,datedue,datecreated,createdby,
                    adjustmentamount,canadjust,billcancel,flagledger)
                    Values(@accountcodeid,@docno,@description,@studentid,@totalamountpayable,@totalamountpaid,
                    @outstandingbalance,@result1,@dateissued,@datedue,GETUTCDATE(),@createdby,
                    @adjustmentamount,@canadjust,@billcancel,@flagledger)
                    set @result2=@@IDENTITY

                    --Insert into student_transaction(accountcodeid,docno,[description],amount,balance,
                    --paymentmethod,transactiontype,remarks,datetimeissued,dateissued,refdocno,
                    ----refdocdate,
                    --cashierid,studentid,courseid,semesterno,intakeid,semesterid,billid,billgroupid,relatedid,
                    --adjustedid,adjustmentamount,canadjust,thirdpartyid,printcount,billcancel,flagledger)
                    --Values(@accountcodeid,@docno,@description,@amount,@balance,@paymentmethod,@transactiontype,
                    --@remarks,@dateissued,@datedue,@refdocno,
                    ----@refdocdate,
                    --@cashierid,@studentid,@cashierid,@semesterno,
                    --@intakeid,@semesterid,@result2,@result1,@relatedid,@adjustedid,@adjustmentamount,@canadjust,@thirdpartyid,
                    --@printcount,@billcancel,@flagledger)

                 END TRY
         BEGIN CATCH
                IF @@TRANCOUNT > 0
                BEGIN
                    ROLLBACK TRANSACTION MySavePoint; -- rollback to MySavePoint
                END
        END CATCH
    COMMIT TRANSACTION 

    
END

    ')
END
