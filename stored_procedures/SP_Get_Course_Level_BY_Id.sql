IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Course_Level_BY_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Course_Level_BY_Id](@Course_Level_Id bigint)

AS

BEGIN

	select Course_Level_Id,Course_Level_Name,Course_Level_Descripition ,Course_Level_Date
	from Tbl_Course_Level
	where Course_level_Status=0 and course_Level_Id=@Course_Level_Id
END
    ');
END;
