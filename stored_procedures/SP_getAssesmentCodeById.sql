IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_getAssesmentCodeById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_getAssesmentCodeById]      
@Assessment_Code_Id bigint      
AS      
BEGIN      
      
 select * from Tbl_Assessment_Code_Master where Assessment_Code_Id = @Assessment_Code_Id 
 select * from Tbl_Assessment_Code_Child where Assessment_Code_Id = @Assessment_Code_Id 
   
      
END

   ')
END;
