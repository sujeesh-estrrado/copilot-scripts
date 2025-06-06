IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Course_Level](@Course_Level_id bigint)

AS

BEGIN

    UPDATE [dbo].[Tbl_Course_Level]
        SET     Course_Level_Status = 1, Delete_Status=1, Update_Date=GETDATE()
        WHERE  course_Level_id = @Course_Level_id
END
    ')
END
