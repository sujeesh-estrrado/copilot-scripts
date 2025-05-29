IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_AssesmentType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Get_AssesmentType]     
  
AS  
 
BEGIN    
    
 select * from Tbl_Assessment_Type
             
                  

    
END
    ')
END;
