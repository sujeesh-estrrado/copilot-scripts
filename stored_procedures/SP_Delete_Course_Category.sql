IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Course_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Course_Category](@Course_Category_id bigint)

AS

BEGIN

    UPDATE [dbo].[Tbl_Course_Category]
        SET     Course_Category_Status = 1
        WHERE  course_Category_id = @Course_Category_id
END
    ')
END
