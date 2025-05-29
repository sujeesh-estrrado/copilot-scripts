IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Holidays]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_Holidays]
(@Holiday_Name varchar(100),@Holiday_FromDate datetime,@Holiday_ToDate datetime)  
as  
begin  
  
insert into Tbl_Holidays (Holiday_Name,Holiday_FromDate,Holiday_ToDate)
 values(@Holiday_Name,@Holiday_FromDate,@Holiday_ToDate)  
  
end
    ')
END;
