IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[deletegroupcoursetemp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[deletegroupcoursetemp]
as begin
delete from groupcoursetemp
select scope_identity()
end
    ')
END
