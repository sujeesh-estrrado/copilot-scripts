IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Emp_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Emp_Department] 
(@Dept_Id bigint,
@Parnt_Id bigint)
AS 
BEGIN 
if not exists (select * from Tbl_Employee_Official where Department_Id=@Dept_Id)
    begin
        if not exists (select * from Tbl_Emp_Department where Parent_Dept=@Parnt_Id)
            begin
                Update Tbl_Emp_Department set Delete_Status=1 WHERE Dept_Id=@Dept_Id
            end
    end


END 
    ')
END
