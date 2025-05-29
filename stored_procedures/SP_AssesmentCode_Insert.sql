IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_AssesmentCode_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_AssesmentCode_Insert]                     
                  
@Assessment_Code varchar(50),                      
@Assessment_Desc varchar(100)                 
AS                      
BEGIN     
Declare @cnt bigint    
set @cnt= (select count(Assessment_Code_Id) from Tbl_Assessment_Code_Master where Assessment_Code=@Assessment_Code)    
if(@cnt=0)    
begin                    
insert into dbo.Tbl_Assessment_Code_Master (Assessment_Code,Assessment_Desc)            
values(@Assessment_Code,@Assessment_Desc)            
   select Scope_identity()     
   end    
   else    
   begin    
   select ''0''   
   end          
END
    ')
END;
