IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllDepartmentSales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_GetAllDepartmentSales]  
As    
Begin    
select DeptSales_Id,Customer_Name,Invoice_Date,Grand_Total,s.Dept_Name   
from  dbo.Tbl_DepartmentSales  
Left Join dbo.Tbl_Emp_Department s on dbo.Tbl_DepartmentSales.Dept_Id = s.Dept_Id     
where Dept_Status = 0    
End


    ')
END
