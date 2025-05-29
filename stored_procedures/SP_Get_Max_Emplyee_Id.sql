IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Max_Emplyee_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_Max_Emplyee_Id]


as

begin

select isnull(max(Employee_Id)+1,0) as  Max_Employee_Id from dbo.Tbl_Employee

end
    ')
END
