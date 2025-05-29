IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Maximum_RecieptNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Maximum_RecieptNo]    
as    
begin    
    
--select max(ISNULL(ReceiptNo,0)) as ReceiptNo from dbo.Tbl_Fee_Entry  
select isNull(max(ReceiptNo),0) as ReceiptNo from dbo.Tbl_Fee_Entry 
end

   ')
END;
