IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_EmpoyeeuserID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_get_EmpoyeeuserID] 
@user_Id bigint 
AS  
BEGIN  
select * from tbl_User  where user_Id=@user_Id  
END
	');
END;
