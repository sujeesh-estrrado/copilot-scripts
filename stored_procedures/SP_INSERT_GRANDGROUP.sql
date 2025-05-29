IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_GRANDGROUP]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_INSERT_GRANDGROUP]      
(    
  @grandgroupcourse varchar(50),    
  @grandgroupdesc varchar(50)    
  )      
AS              
              
IF EXISTS(SELECT GrandGroupCode FROM dbo.Tbl_Grand_Group where GrandGroupCode=@grandgroupcourse)    
BEGIN              
    RAISERROR (''Data Already Exists.'', -- Message text.              
          16, -- Severity.              
          1 -- State.              
          );              
END              
ELSE      
  begin     
        
    INSERT INTO dbo.Tbl_Grand_Group     
    (    
     GrandGroupCode,    
     GrandGroupDesc,
     delstatus    
    )      
    VALUES (    
     @grandgroupcourse,    
     @grandgroupdesc,
     0    
    )        
    SELECT SCOPE_IDENTITY()       
  END');
END;
