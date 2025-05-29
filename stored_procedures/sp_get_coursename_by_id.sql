IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_coursename_by_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_get_coursename_by_id]  --1
(@CourseId bigint)
As
Begin
Select Department_Name,Department_Id,Course_Code from dbo.Tbl_Department where Department_Id=@CourseId
and Department_Status=0

End
    ');
END;
