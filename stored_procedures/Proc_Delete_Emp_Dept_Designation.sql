IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Emp_Dept_Designation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Delete_Emp_Dept_Designation](@Dept_Desig_ID bigint)
as
begin 
if not exists (select * from Tbl_Employee_Official where Designation_Id=@Dept_Desig_ID )
BEGIN
update Tbl_Emp_DeptDesignation set Delete_Status=1,Dept_Designation_Status=1,Updated_Date=getdate() where Dept_Designation_Id=@Dept_Desig_ID
end 


end 
    ')
END
