IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Semester_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Course_Semester_Delete]
@Semester_Id bigint
AS
BEGIN
if not exists(select * from Tbl_Course_Duration_PeriodDetails where Semester_Id=@Semester_Id and Closing_Date>GETDATE())
begin
UPDATE Tbl_Course_Semester 
SET Semester_DelStatus=1 
WHERE Semester_Id=@Semester_Id
end
END
    ')
END
