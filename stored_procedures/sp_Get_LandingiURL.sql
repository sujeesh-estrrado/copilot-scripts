IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_LandingiURL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_LandingiURL]        
  (        
  @flag bigint=0        
  )        
as        
BEGIN        
if(@flag=0)        
begin        
    Select LandingiURL_Id,LandingiURL_Name from Tbl_LandingiURL      
 end        
       
        
END

    ')
END;
