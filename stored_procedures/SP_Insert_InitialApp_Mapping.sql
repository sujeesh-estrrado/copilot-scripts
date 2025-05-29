IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_InitialApp_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Insert_InitialApp_Mapping]
(@user_Id bigint  
,@Initial_Application_Id bigint)  
 
AS  
BEGIN  
 INSERT INTO [Tbl_InitialApp_UserMapping]
           (user_Id  
           ,Initial_Application_Id )  
            
     VALUES  
           (@user_Id  
   ,@Initial_Application_Id)  
     
SELECT @@IDENTITY  
END   
    ')
END;
