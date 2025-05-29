IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Student_Holidays]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_Student_Holidays]    
(@Student_Holiday_Name varchar(100),@Student_Holiday_FromDate datetime,@Student_Holiday_ToDate datetime)      
as      
begin      
      
insert into Tbl_Student_Holidays (Student_Holiday_Name,Student_Holiday_FromDate,Student_Holiday_ToDate)    
 values(@Student_Holiday_Name,@Student_Holiday_FromDate,@Student_Holiday_ToDate)      
      
end

    ')
END;
