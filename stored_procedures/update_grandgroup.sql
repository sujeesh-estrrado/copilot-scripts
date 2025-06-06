IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[update_grandgroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[update_grandgroup]        
(      
  @grandgroupcourse varchar(50),      
  @grandgroupdesc varchar(50),    
  @GrandGroupCodeId bigint      
  )        
AS                
    
  begin       
          
    update  dbo.Tbl_Grand_Group       
    set GrandGroupCode=@grandgroupcourse,GrandGroupDesc=@grandgroupdesc,delstatus=0      
where GrandGroupCodeId=@GrandGroupCodeId    
    --SELECT SCOPE_IDENTITY()         
  END
    ')
END;
GO
