IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetRunning_No]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_GetRunning_No]
as
begin
select max(Offerletter_id)+1  as Running_no from Tbl_Offerlettre
end
');
END;