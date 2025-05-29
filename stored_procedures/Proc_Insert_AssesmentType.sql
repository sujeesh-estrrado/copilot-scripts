IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_AssesmentType]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Insert_AssesmentType]     
 (@Assesment_Type  varchar(100),@Assessment_Type_Code  varchar(50) )    
AS    
IF EXISTS(SELECT Assesment_Type FROM dbo.Tbl_Assessment_Type  Where LTRIM(Assesment_Type) = LTRIM(@Assesment_Type))    
BEGIN    
RAISERROR (''AssesmentType already Exists.'', -- Message text.    
               16, -- Severity.    
               1 -- State.    
               );    
END    
ELSE    
     
BEGIN     
     
     
  insert into dbo.Tbl_Assessment_Type (Assesment_Type,Assessment_Type_Code)    
  values(@Assesment_Type,@Assessment_Type_Code)    
    
END 
    ')
END;
