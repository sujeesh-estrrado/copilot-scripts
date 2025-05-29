IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Purchase_Request_By_Purchase_Request_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_Purchase_Request_By_Purchase_Request_Id]  
(  
@Purchase_Request_Id bigint  
)  
  
as  
  
begin  

declare @PurchaseCode varchar(50)

set @PurchaseCode=(Select top 1 Purchase_Request_Code            
From dbo.Tbl_Purchase_Request where Purchase_Request_Id=@Purchase_Request_Id)  
  
Select pr.*,p.Product_Name,pu.Units_Name,u.user_name,u.role_Id,r.role_Name from   
  
dbo.Tbl_Purchase_Request pr left join dbo.Tbl_Products p on pr.Product_Id=p.Product_Id  
  
left join dbo.Tbl_Product_Units pu on pr.Unit_Id=pu.Units_id left join dbo.Tbl_User u on  
  
pr.Requested_User_Id=u.user_Id left join dbo.tbl_Role r on r.role_Id=u.role_Id where  
  
 pr.Purchase_Request_Code= @PurchaseCode 
  
  
end
    ')
END
