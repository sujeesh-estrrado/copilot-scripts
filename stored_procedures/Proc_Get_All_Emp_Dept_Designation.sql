IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_All_Emp_Dept_Designation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Get_All_Emp_Dept_Designation]  
  
as  
begin  
  
select  Tbl_Emp_DeptDesignation.Dept_Designation_Id as ID,Tbl_Emp_DeptDesignation.Dept_Designation_Name as Designation  
       
  
from  
        Tbl_Emp_DeptDesignation   
where Tbl_Emp_DeptDesignation.Dept_Designation_Status=0 and Tbl_Emp_DeptDesignation.Delete_Status=0
order by  Designation
  
end
    ')
END
