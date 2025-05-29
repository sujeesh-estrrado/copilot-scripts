IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_OnlinePayments]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_OnlinePayments]
(
@flag int =0,
@ID bigint= 0,
@RefNo  varchar(MAX)='''',
@PaymentId  varchar(50)='''',
@Amount decimal(18, 0)= 0,
@StudentID  bigint= 0,
@TransId    varchar(50)='''',
@Status int= 0,
@dateTime   datetime='''',
@ErrDesc varchar(MAX)='''',
@MerchantCode varchar(MAX)='''',
@eCurrency varchar(MAX)='''',
@Remark varchar(MAX)='''',
@AuthCode varchar(MAX)='''',
@Signature varchar(max) NULL,
@CCName varchar(50) NULL,
@CCNo varchar(50) NULL,
@S_bankname varchar(50) NULL,
@S_country varchar(50) NULL,
@result int =0 output 
)
as
begin
    if @flag=1
    begin
     INSERT INTO [dbo].[Tbl_OnlinePayment]
            ([RefNo],[PaymentId],[Amount],[StudentID],[TransId],[eStatus],[dateTime],[ErrDesc],[MerchantCode],[eCurrency],[Remark]
                    ,[AuthCode],[Signature],[CCName],[CCNo],[S_bankname],[S_country])
     VALUES
           (@RefNo,@PaymentId,@Amount,@StudentID,@TransId,@Status,@dateTime,@ErrDesc,@MerchantCode,@eCurrency,@Remark
           ,@AuthCode,@Signature,@CCName,@CCNo,@S_bankname,@S_country)

    SET @result=SCOPE_IDENTITY()
        select  @result as OPaymentId
    end

end

    ')
END;
