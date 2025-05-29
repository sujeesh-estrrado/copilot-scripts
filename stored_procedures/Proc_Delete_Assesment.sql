IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Assesment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Delete_Assesment] --5        
(@Assessment_Type_Id  bigint)            
            
AS            
            
BEGIN       
if not exists( select * from Tbl_Assessment_Code_Child where Assessment_Type_Id= @Assessment_Type_Id )  
  
Begin  
  Delete From dbo.Tbl_Assessment_Type --Tbl_Fee_Head          
 WHERE   Assessment_Type_Id= @Assessment_Type_Id            
-- UPDATE dbo.Tbl_Fee_Head             
--  SET    Fee_Head_DelStatus  = 1            
--  WHERE Fee_Head_Id  = @Fee_Head_Id     
  
End  
END 

    ')
END;
