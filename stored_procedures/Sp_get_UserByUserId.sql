IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_get_UserByUserId]')
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[Sp_get_UserByUserId]  
@userid bigint  
AS  
BEGIN  
  SELECT  * from dbo.tbl_User where user_Id=@userid    
END

    ')
END
GO