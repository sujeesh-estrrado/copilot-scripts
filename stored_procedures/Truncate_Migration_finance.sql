IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Truncate_Migration_finance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Truncate_Migration_finance]
as
begin

truncate table student_payment_float
truncate table student_bill
truncate table student_bill_group
truncate table student_transaction
truncate table student_payment
end

    ')
END;
GO
