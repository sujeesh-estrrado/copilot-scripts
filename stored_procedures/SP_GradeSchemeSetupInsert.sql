IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GradeSchemeSetupInsert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GradeSchemeSetupInsert]                   
@Grade_Scheme_Id  bigint,                    
@From decimal(18,2),                    
@To decimal(18,2),                    
@Grade varchar(50),  
@Pass varchar(50),    
@GradeDescription varchar(50),
  @GradePoint decimal(18,2)
              
AS                    
BEGIN                     
insert into dbo.Tbl_GradeSchemeSetup (Grade_Scheme_Id,[From],[To],Grade,Pass,GradeDescription,GradePoint)          
values(@Grade_Scheme_Id,@From,@To,@Grade,@Pass,@GradeDescription,@GradePoint)          
 select Scope_identity()        
END
   ')
END;
