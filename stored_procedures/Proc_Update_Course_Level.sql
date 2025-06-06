IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_Course_Level]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Proc_Update_Course_Level](@Course_Level_Id bigint,@Course_Level_Name varchar(300),
                    @Course_Level_Descripition varchar(500),@Course_Level_Date Datetime)

AS

BEGIN

    UPDATE [dbo].[Tbl_Course_Level]
        SET    
               course_Level_Name              = @Course_Level_Name,
               course_Level_Descripition      = @Course_Level_Descripition,
               course_Level_Date              = @Course_Level_Date
              
              
        WHERE  course_Level_Id                = @Course_Level_Id

END
    ')
END
