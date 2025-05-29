IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Current_Transfer_General_Stock_By_Product_Id_And_Department_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Current_Transfer_General_Stock_By_Product_Id_And_Department_Id]           
(          
@Product_Id bigint ,        
@Department_Id bigint         
)           
          
as          
begin          
        
select     
    
(sum(g.TQuantity) -     
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
    
)) as TotalTransferQuantity     
    
from Tbl_General_Department_Transfer g          
where Product_Id=@Product_Id and Department_Id=@Department_Id       
group by g.Product_Id,g.Department_Id;       
          
        
        
end
    ');
END;
