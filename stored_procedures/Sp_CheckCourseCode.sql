IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CheckCourseCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Sp_CheckCourseCode](@cousrecode varchar(200))
as
begin
select * from Tbl_New_Course where Course_Code=@cousrecode and Delete_Status=0;
end

    ')
END
