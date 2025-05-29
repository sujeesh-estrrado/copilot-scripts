IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_FineMasterDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_FineMasterDetails]  
AS  
BEGIN  
SELECT Tbl_LMS_Fine_Master.Fine_Master_Id,Tbl_LMS_Fine_Master.Role_Id,Tbl_LMS_Fine_Master.Is_AutoIncrement,  
Tbl_Role.role_Name,Tbl_Role.role_status
FROM dbo.Tbl_LMS_Fine_Master  
INNER JOIN Tbl_Role on Tbl_LMS_Fine_Master.role_Id=Tbl_Role.role_Id  
END  
');
END;