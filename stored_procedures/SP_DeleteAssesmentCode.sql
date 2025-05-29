IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteAssesmentCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_DeleteAssesmentCode]          
@Assessment_Code_Id bigint          
AS          
BEGIN          
        if not exists(select * from Tbl_New_Course where AssessmentCode=@Assessment_Code_Id)  
  begin  
  Delete From Tbl_Assessment_Code_Master        
  WHERE Assessment_Code_Id = @Assessment_Code_Id          
        
delete from  dbo.Tbl_Assessment_Code_Child where Assessment_Code_Id = @Assessment_Code_Id    
end  
--          
          
END  
    ')
END;
