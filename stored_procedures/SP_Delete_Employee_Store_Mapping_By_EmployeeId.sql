IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Employee_Store_Mapping_By_EmployeeId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Employee_Store_Mapping_By_EmployeeId]
(
@Employee_Id bigint
)

as 

begin

delete from dbo.Tbl_Employee_Store_Mapping where Employee_Id=@Employee_Id

end
    ')
END
