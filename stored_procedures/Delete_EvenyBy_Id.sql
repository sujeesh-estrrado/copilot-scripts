IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delete_EvenyBy_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Delete_EvenyBy_Id]
@Event_Id bigint
as
begin

update Tbl_EventList set DelStatus=1 where Event_Id=@Event_Id
end
    ')
END;
