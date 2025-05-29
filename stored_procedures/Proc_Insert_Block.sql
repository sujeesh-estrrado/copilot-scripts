IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Block]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Proc_Insert_Block]     
 (@Block_Name varchar(200),@Block_Code varchar(50))    
AS    
IF EXISTS(SELECT Block_Name FROM Tbl_Block Where Block_Name = @Block_Name and Block_DelStatus = 0)    
BEGIN    
RAISERROR (''Your data already Exist.'', -- Message text.    
               16, -- Severity.    
               1 -- State.    
               );    
END    
ELSE    
    
     
BEGIN     
     
  insert into Tbl_Block(Block_Name,Block_Code)    
  values(@Block_Name,@Block_Code)    
    
 SELECT SCOPE_IDENTITY()    
END
  
    ')
END
GO