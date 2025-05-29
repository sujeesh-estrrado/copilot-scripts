IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GradeScheme_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GradeScheme_Insert]                             
@Grade_Scheme  varchar(50)='''',                              
@Description varchar(100)='''',                              
@MaxMark decimal(18,2)=0 ,      
@resit_status bit =null,  
@flag bigint=0  
AS                              
BEGIN             
           
 if(@flag=0)  
 begin  
          
 if not exists(select Grade_Scheme from Tbl_GradingScheme where  Grade_Scheme=@Grade_Scheme)    
  begin    
   insert into dbo.Tbl_GradingScheme (Grade_Scheme,[Description],MaxMark,resit_status)                    
   values(@Grade_Scheme,@Description,@MaxMark,@resit_status)                    
      select Scope_identity()       
  end            
end             
  if(@flag=1)  
  
 begin          
  select Grade_Scheme from Tbl_GradingScheme where  Grade_Scheme=@Grade_Scheme    
      
   end            
           
END  
    ');
END;
