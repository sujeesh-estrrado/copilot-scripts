IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_INSERT_SUBJSTUDMAPCHILD]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_INSERT_SUBJSTUDMAPCHILD]
(@Subject_Master_Id bigint,@Subject_Id bigint)

AS BEGIN

INSERT INTO dbo.Tbl_Student_Subject_Child(Student_Subject_Map_Master,
Subject_Id) VALUES(@Subject_Master_Id,@Subject_Id)

SELECT SCOPE_IDENTITY()

END

    ')
END
