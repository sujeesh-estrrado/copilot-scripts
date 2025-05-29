IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Excel]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE Procedure [dbo].[SP_Insert_Excel](@userid bigint,@name varchar(max),@sourcename varchar(max),@sourceofinformation varchar(max),@count bigint)  
as  
begin  
if not exists(select * from Tbl_Excel_upload_log where Excel_name=@name and delete_status=0)  
begin  
  
insert into Tbl_Excel_upload_log (Excel_name,delete_status,Upload_date,Uploaded_by,Source,source_name,total_count) values(@name,0,getdate(),@userid,@sourceofinformation,@sourcename,@count)  
select SCOPE_IDENTITY();  
end  
end              ');
END;
