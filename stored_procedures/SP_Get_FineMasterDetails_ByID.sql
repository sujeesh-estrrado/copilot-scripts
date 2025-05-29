IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_FineMasterDetails_ByID]')
    AND type = N'P'
)
BEGIN
    EXEC('
  -- =============================================  
create procedure [dbo].[SP_Get_FineMasterDetails_ByID](@Fine_Master_Id bigint)
AS
BEGIN
SELECT * FROM dbo.Tbl_LMS_Fine_Master
INNER  JOIN dbo.Tbl_LMS_Fine_Details on Tbl_LMS_Fine_Master.Fine_Master_Id=dbo.Tbl_LMS_Fine_Details.Fine_Master_Id
INNER JOIN Tbl_Role on Tbl_LMS_Fine_Master.Role_Id=Tbl_Role.Role_Id
WHERE Tbl_LMS_Fine_Master.Fine_Master_Id=@Fine_Master_Id
END
  
    ')
END
