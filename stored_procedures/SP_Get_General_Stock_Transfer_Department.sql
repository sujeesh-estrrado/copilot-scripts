IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_General_Stock_Transfer_Department]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[SP_Get_General_Stock_Transfer_Department]  
  
as  
  
begin  
  
select distinct Department_Id,(select Dept_Name from dbo.Tbl_Emp_Department where Dept_Id=Department_id) as Department_Name  
 from dbo.Tbl_General_Department_Transfer  
  
end
    ')
END
