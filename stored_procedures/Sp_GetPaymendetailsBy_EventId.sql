IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetPaymendetailsBy_EventId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetPaymendetailsBy_EventId]
@Event_Id bigint
as
 begin
 select PaymentDetails,Amount,TotalAmount from Tbl_EventPaymentMapping where Event_Id=@Event_Id
 end

   ')
END;
