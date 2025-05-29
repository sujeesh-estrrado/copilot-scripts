IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_General_Department_Stock]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[SP_Get_General_Department_Stock]


as

begin


select  GDT.Product_Id,D.Dept_Id ,isnull(sum(TQuantity),0) as TotalDepartmentStock,
(select isnull(sum(RQuantity),0)  from dbo.Tbl_Department_General_Return where Department_Id=D.Dept_Id and Product_Id=GDT.Product_Id ) as CurrentDepartmentReturn,
(isnull(sum(TQuantity),0)-(select isnull(sum(RQuantity),0)  from dbo.Tbl_Department_General_Return where Department_Id=D.Dept_Id and Product_Id=GDT.Product_Id )) as CurrentDepartmentStock,P.Product_Name
from dbo.Tbl_General_Department_Transfer GDT left join dbo.Tbl_Products P on P.Product_Id=GDT.Product_Id
left join dbo.Tbl_Emp_Department D on D.Dept_Id=GDT.Department_Id group by GDT.Product_Id,D.Dept_Id,TQuantity ,P.Product_Name
end
    ')
END
