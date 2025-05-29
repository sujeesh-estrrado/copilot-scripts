IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GradeSchemeUpdate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GradeSchemeUpdate](                   
@Grade_Scheme  varchar(50),                    
@Description varchar(100),                    
@MaxMark decimal(18,2),  
@Grade_Scheme_Id bigint  ,
@resit_status bit
)             
AS                    
BEGIN                     
Update dbo.Tbl_GradingScheme       
set       
Grade_Scheme=@Grade_Scheme,      
[Description]=@Description,      
MaxMark=@MaxMark  ,
resit_status=@resit_status
where Grade_Scheme_Id= @Grade_Scheme_Id      
   delete from dbo.Tbl_GradeSchemeSetup where Grade_Scheme_Id= @Grade_Scheme_Id  
   delete from   Tbl_GradeSpecial where Grade_Scheme_Id= @Grade_Scheme_Id     
   select @Grade_Scheme_Id          
END  
    ');
END;
