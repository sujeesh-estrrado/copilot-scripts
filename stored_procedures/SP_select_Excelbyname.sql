IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_select_Excelbyname]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  Procedure [dbo].[SP_select_Excelbyname](@name varchar(max))  
as  
begin  
select * from Tbl_Excel_upload_log where Excel_name=@name and delete_status=0
 
end
');
END;