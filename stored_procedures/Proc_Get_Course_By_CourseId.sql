IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Course_By_CourseId]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[Proc_Get_Course_By_CourseId](@Course_Id int,@Flag bigint=0)

AS
BEGIN
if(@Flag=0)
begin
SELECT Tbl_Course.Course_Id as ID ,Tbl_Course.Course_Name as Course,
Tbl_Course.Course_Suffix ,Tbl_Course.Course_Prefix,Tbl_Course.Course_Type,
Tbl_Course.Course_Duration ,Tbl_Course.Course_Duration_Type,Tbl_Course.Streem_Id
         FROM Tbl_Course

INNER JOIN Tbl_Streams ON Tbl_Course.Streem_Id=Tbl_Streams.Stream_Id
    WHERE  Tbl_Course.Course_Id=@Course_Id AND Tbl_Course.Course_Status=0
    end
    else if(@Flag=1)
    begin
    select * from Tbl_New_Course where Course_Id=@Course_Id
    end
            
END
    ')
END;
