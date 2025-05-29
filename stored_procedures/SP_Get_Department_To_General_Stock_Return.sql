IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Department_To_General_Stock_Return]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Department_To_General_Stock_Return]  
  
as  
  
begin  
  
select distinct Department_Id,(select Dept_Name from dbo.Tbl_Emp_Department where Dept_Id=Department_id) as Department_Name  
 from   dbo.Tbl_Department_General_Return
  
end
	');
END;
