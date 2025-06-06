IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Semester_Select_by_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Course_Semester_SELECT_BY_ID]
@Semester_Id bigint
AS
BEGIN
SELECT [Semester_Id]
      ,[Semester_Code]
      ,[Semester_Name]
      ,[Semester_DelStatus]
  FROM [Tbl_Course_Semester]
WHERE Semester_Id=@Semester_Id
END

   ')
END;
