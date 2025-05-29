IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Getall_GroupReceipt_ExcelLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Getall_GroupReceipt_ExcelLog]
(
@Excel_Name varchar(MAX)=''''
)
as
begin
    
        select * from Tbl_GroupReceipt_ExcelLog where Delete_Status=0 and Excel_Name=@Excel_Name
        
        
end
    ')
END;
