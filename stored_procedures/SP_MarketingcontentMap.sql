IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_MarketingcontentMap]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_MarketingcontentMap]
as
begin
select GroupCourseCodeId from groupcoursetemp
end');
END