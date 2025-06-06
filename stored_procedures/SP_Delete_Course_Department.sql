IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Course_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Course_Department](@Course_Department_id bigint)

AS

BEGIN

    UPDATE [dbo].[Tbl_Course_Department]
        SET     Course_Department_Status = 1
        WHERE  course_Department_id = @Course_Department_id
END

    ')
END
