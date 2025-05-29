IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_AssesmentType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Update_AssesmentType]     
 (@Assessment_Type_Id bigint,@Assesment_Type varchar(100),@Assessment_Type_Code varchar(50))    
AS    
 
BEGIN    
    
 UPDATE dbo.Tbl_Assessment_Type     
  SET        
                
      Assesment_Type                = @Assesment_Type,    
      Assessment_Type_Code             = @Assessment_Type_Code    
             
                  
  WHERE  Assessment_Type_Id                = @Assessment_Type_Id    

  Update Tbl_Assessment_Code_Child set AssesmentTypeCode=@Assessment_Type_Code where Assessment_Type_Id=@Assessment_Type_Id
    
END
    ')
END;
