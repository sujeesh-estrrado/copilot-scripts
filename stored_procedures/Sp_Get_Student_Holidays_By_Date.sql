IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Student_Holidays_By_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Student_Holidays_By_Date]
(
@checkdate datetime
)

as

begin

select * from dbo.Tbl_Student_Holidays where @checkdate between 
Student_Holiday_FromDate and Student_Holiday_ToDate


end
    ')
END;
