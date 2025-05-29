IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_getUserId_byEmployeeID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_getUserId_byEmployeeID]  
(@Employee_Id bigint )  
  
AS BEGIN  
  
SELECT User_Id FROM dbo.Tbl_Employee_User WHERE Employee_Id=@Employee_Id  
  
END
    ');
END;
