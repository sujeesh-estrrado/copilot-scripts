IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Tbl_Employee_Experience_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Tbl_Employee_Experience_By_Employee_Id](
@Employee_Id bigint
)
as

begin

delete from dbo.Tbl_Employee_Experience where Employee_Id=@Employee_Id

end
    ')
END
