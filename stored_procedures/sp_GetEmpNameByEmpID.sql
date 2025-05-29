IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetEmpNameByEmpID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_GetEmpNameByEmpID]
(
@EmpID bigint=0
)
as
begin
	select *
	from Tbl_Employee_User as EU
			left join Tbl_Employee as E
	on EU.Employee_Id = E.Employee_Id
	where E.Employee_Id = @EmpID
end');
END;
