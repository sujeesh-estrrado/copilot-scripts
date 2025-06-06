IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertEventPaymeny]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_InsertEventPaymeny]
@Flag bigint,
@PaymentDetails varchar(100)=null,
    @Amount bigint=null,
    @eventid bigint
as
if(@flag=4)
begin
insert into Tbl_EventPaymentMapping(Event_Id,PaymentDetails,Amount,CreatedDate,UpdatedDate,Del_Status,TotalAmount)
values(@eventid,@PaymentDetails,@Amount,GETDATE(),GETDATE(),0,@Amount)
end

   ')
END;
