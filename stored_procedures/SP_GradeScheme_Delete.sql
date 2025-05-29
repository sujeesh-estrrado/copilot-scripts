IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GradeScheme_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GradeScheme_Delete]          
@Grade_Scheme_Id bigint          
AS          
BEGIN          
        
   if not exists(select * from Tbl_New_Course where Grade_Id=@Grade_Scheme_Id and Delete_Status=0)  
   begin  
  Delete From Tbl_GradingScheme        
  WHERE Grade_Scheme_Id = @Grade_Scheme_Id          
        
delete from  dbo.Tbl_GradeSchemeSetup where Grade_Scheme_Id=@Grade_Scheme_Id      
delete from  dbo.Tbl_GradeSpecial where Grade_Scheme_Id=@Grade_Scheme_Id   
end  
--          
          
END  
    ');
END;
