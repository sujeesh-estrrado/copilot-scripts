IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[UnassignfacultyDean]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[UnassignfacultyDean]
    (
    @courselevel_id bigint=0
    )
AS
BEGIN
    update Tbl_Course_Level set Faculty_dean_id=null where Course_Level_Id=@courselevel_id
END

    ')
END;
GO
