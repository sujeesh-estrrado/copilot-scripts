IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GradeSpecial]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GradeSpecial]                   
@Grade_Scheme_Id  bigint,                    
@UnBoundGrade varchar(50),                    
@UnBoundDesc varchar(50),                    
@Pass varchar(50),  
@DefaultGrade bit,    
@Priority varchar(50)
              
AS                    
BEGIN                     
insert into dbo.Tbl_GradeSpecial (Grade_Scheme_Id,UnBoundGrade,UnBoundDesc,Pass,DefaultGrade,Priority)          
values(@Grade_Scheme_Id,@UnBoundGrade,@UnBoundDesc,@Pass,@DefaultGrade,@Priority)          
 select Scope_identity()        
END

   ')
END;
