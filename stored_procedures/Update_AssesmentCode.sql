IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Update_AssesmentCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Update_AssesmentCode]                       
@Assessment_Code_Id  bigint,                        
@Assessment_Code varchar(50),                        
@Assessment_Desc varchar(100)                   
AS                        
BEGIN    
update Tbl_Assessment_Code_Master  
set Assessment_Code=@Assessment_Code,  
  Assessment_Desc=@Assessment_Desc  
  where Assessment_Code_Id=@Assessment_Code_Id  
      delete from Tbl_Assessment_Code_Child where Assessment_Code_Id=@Assessment_Code_Id  
      select @Assessment_Code_Id
END
    ')
END;
