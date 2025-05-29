IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_EMPLOYEE_CERTIFICATE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERT_EMPLOYEE_CERTIFICATE]   
 @Employee_Id bigint  
--,@Title varchar(50)  
,@Image_Path varchar(500)  
AS  
BEGIN  
INSERT INTO [Tbl_Employee_Certificates]  
           ([Employee_Id]  
--           ,[Title]  
           ,[Image_Path])  
     VALUES  
           (@Employee_Id  
--           ,@Title  
           ,@Image_Path)   
END');
END;
