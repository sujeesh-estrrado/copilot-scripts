IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetTemplatePath]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetTemplatePath](@id bigint)  
as  
begin   
select * from Tbl_Template_generation where delete_status=0 and Template_id=@id;  
end  
    ');
END;
