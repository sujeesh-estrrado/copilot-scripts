IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_CHECK_REGISTER_NO_EXISTS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_CHECK_REGISTER_NO_EXISTS]  
AS          
BEGIN         
  Select            
   
 University_Regno FROM Tbl_Candidate_University_Regno    
      
END    


   ')
END;
