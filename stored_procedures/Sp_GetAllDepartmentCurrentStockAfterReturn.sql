IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllDepartmentCurrentStockAfterReturn]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_GetAllDepartmentCurrentStockAfterReturn]
As
begin
  
select g.Product_Id,g.Department_Id,sum(g.TQuantity)as DepartmentStockWithoutSales,p.Product_Name,p.Prod_Cat_Id,ED.Dept_Name,  
(  
select Tbl_Product_Categories.Prod_Cat_Name   
 from Tbl_Product_Categories   
where Tbl_Product_Categories.Prod_Cat_Id = p.Prod_Cat_id   
)as Category,  
  
isnull((select isnull(sum(S1.Sales_Quantity ),0)    
from Tbl_DepartmentStoreProducts S1    
left join dbo.Tbl_DepartmentSales  S2 on S1.DeptSales_Id=S2.DeptSales_Id and S2.Dept_Id=g.Department_Id    
where S1.Product_Id=g.Product_Id and S2.Dept_Id=g.Department_Id   
group by S1.Product_Id),0) as SalesStock  ,  

isnull((select sum(R.RQuantity)
from Tbl_Department_General_Return R
where R.Product_Id = g.Product_Id and R.Department_Id=g.Department_Id 
group by R.Product_Id,R.Department_Id),0) as ReturnedDepartmentStock ,

(  
sum(g.TQuantity) - 
( 
isnull((select isnull(sum(S1.Sales_Quantity ),0)    
from Tbl_DepartmentStoreProducts S1    
left join dbo.Tbl_DepartmentSales  S2 on S1.DeptSales_Id=S2.DeptSales_Id and S2.Dept_Id=g.Department_Id    
where S1.Product_Id=g.Product_Id and S2.Dept_Id=g.Department_Id   
group by S1.Product_Id),0) + 
isnull((select sum(R.RQuantity)
from Tbl_Department_General_Return R
where R.Product_Id = g.Product_Id and R.Department_Id=g.Department_Id 
group by R.Product_Id,R.Department_Id),0)
)
) as CurrentDepartmentStock   
  
  
from dbo.Tbl_General_Department_Transfer g  
left join Tbl_Products p on g.Product_Id = p.Product_Id      
left join Tbl_Product_Categories on p.Prod_Cat_id=Tbl_Product_Categories.Prod_Cat_Id   
left join Tbl_Emp_Department ED on g.Department_Id= ED.Dept_Id  

 
group by g.Product_Id,g.Department_Id,p.Product_Name,p.Prod_Cat_Id,ED.Dept_Name;        

End


    ')
END
