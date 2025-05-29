IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Issue_GeneralStore_Store_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Issue_GeneralStore_Store_Report] --''05/28/2015'',''08/12/2015''      
(@FromDate datetime, @ToDate datetime)      
as begin      
      
select p.Product_Id,pc.Prod_Cat_Name,p.Product_Name,s.Store_Name,s.Store_Id,isnull(gs.Unit_price,0) as Unit_price, isnull(sum(TransferQuantity),0) as Qty   
from dbo.Tbl_GeneralStore_to_Store gs inner join Tbl_Products p  on p.Product_Id= gs.Product_Id   
inner join Tbl_Product_Categories pc on pc.Prod_Cat_Id=p.Prod_Cat_Id  
inner join Tbl_Store s on s.Store_Id=gs.TransferStore_Id where  gs.TransferDate between @FromDate and @ToDate group by p.Product_Name,p.Product_Id,s.Store_Name,gs.Unit_price,s.Store_Id,pc.Prod_Cat_Name    
      
end
');
END;