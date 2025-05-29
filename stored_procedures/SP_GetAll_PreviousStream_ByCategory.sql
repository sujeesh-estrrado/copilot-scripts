IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_PreviousStream_ByCategory]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_PreviousStream_ByCategory]  
as   
begin  
  
select  Tbl_Previous_Subjects.Previous_Subject_Id as ID,dbo.Tbl_Previous_Subjects.Previous_Stream_Id as StreamID,dbo.Tbl_Previous_Stream.Category as Category,  
Tbl_Previous_Stream.Previous_Stream_Name as StreamName, Tbl_Previous_Subjects.Previous_Subject_Name as SubjectName,
Tbl_Course_Category.Course_Category_Name as [Category Name]
from dbo.Tbl_Previous_Subjects   
inner join dbo.Tbl_Previous_Stream on Tbl_Previous_Subjects.Previous_Stream_Id=Tbl_Previous_Stream.Previous_Stream_Id  
inner join dbo.Tbl_Course_Category on dbo.Tbl_Previous_Stream.Category=dbo.Tbl_Course_Category.Course_Category_Id
end
    ')
END
GO