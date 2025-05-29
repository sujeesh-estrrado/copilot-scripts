IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_ApprovedPurchase_Requests]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GetAll_ApprovedPurchase_Requests]      
      
as      
      
begin      
      
Select distinct pr. Purchase_Request_Code,pr.Requested_User_Id,pr.Purchase_Request_Date,pr.Status_Remarks,pr.Request_Status,u.user_name    
from dbo.Tbl_Purchase_Request pr     
left join dbo.Tbl_User u on  pr.Requested_User_Id=u.user_Id    
left join dbo.tbl_Role r on r.role_Id=u.role_Id     
  
where pr.Request_Status=''Approved''  
      
      
end
    ');
END
GO