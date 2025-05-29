IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Issue_Department_Store_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Issue_Department_Store_Report]--''10/07/2014'',''05/22/2015''    
(@FromDate datetime, @ToDate Datetime)    
as begin    
    
    
select pc.Prod_Cat_Name,p.Product_Id,p.Product_Name,d.Dept_Name,d.Dept_Id, sum(TQuantity) as Qty,isnull(gt.Unit_Price,0) as price    
from dbo.Tbl_General_Department_Transfer gt inner join Tbl_Products p  on p.Product_Id= gt.Product_Id    
inner join Tbl_Product_Categories pc on pc.Prod_Cat_Id=p.Prod_Cat_Id    
inner join Tbl_Emp_Department d on d.Dept_Id=gt.Department_Id where  gt.Tdate between  @FromDate and @ToDate      
group by p.Product_Name,p.Product_Id,d.Dept_Name,gt.Unit_Price,pc.Prod_Cat_Name,d.Dept_Id   
    
 end
');
END;