IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Report_Log]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Report_Log] 
(
@Employee_Id bigint=0,
@Report_Url varchar(MAX)='''',
@Report_Name varchar(MAX)=''''
)
as 
begin
	

	Insert into Tbl_Report_Log
	(Employee_Id,Report_Url,Report_Name,Generate_Time)values
	(@Employee_Id,@Report_Url,@Report_Name,getdate())

end
');
END;