IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Englishmaster_list]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Englishmaster_list]  
as  
begin   
select English_Text_Id,English_Test  
from dbo.Tbl_EnglishTestMaster   
where  Delete_Status=0
end
	');
END;
