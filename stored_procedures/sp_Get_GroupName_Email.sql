IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_GroupName_Email]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_GroupName_Email]        
  (        
  @flag bigint=0        
  )        
as        
BEGIN        
if(@flag=0)        
begin        
    Select GroupEmail_Id,GroupName from Tbl_GroupEmail     
    
    
 end        
       
        
END 

   ')
END;
