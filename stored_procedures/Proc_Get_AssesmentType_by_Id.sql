IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_AssesmentType_by_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Get_AssesmentType_by_Id]     
 (@Assessment_Type_Id bigint)    
AS    
 
BEGIN    
    
 select * from Tbl_Assessment_Type
             
                  
  WHERE  Assessment_Type_Id                = @Assessment_Type_Id    
    
END
    ')
END;
