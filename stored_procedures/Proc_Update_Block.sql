IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Block]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE procedure [dbo].[Proc_Update_Block]      
(@Block_Id bigint,@Block_Name varchar(200),      
 @Block_Code varchar(50))      
      
AS     
    
IF  EXISTS (SELECT Block_Name FROM [Tbl_Block] WHERE            
 Block_Name=@Block_Name and Block_Id<>@Block_Id and Block_DelStatus = 0)             
BEGIN              
RAISERROR(''Your data already Exist.'',16,1);              
END           
ELSE      
      
BEGIN      
      
UPDATE [dbo].[Tbl_Block]      
SET Block_Name = @Block_Name,      
    Block_Code = @Block_Code      
                     
                    
                    
WHERE  Block_Id = @Block_Id      
      
END

   ')
END;
