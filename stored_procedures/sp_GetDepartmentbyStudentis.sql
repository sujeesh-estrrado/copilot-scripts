IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetDepartmentbyStudentis]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_GetDepartmentbyStudentis]-- 7
(@id bigint) 
as
begin
select * from Tbl_Department where Department_Id=@id;
end');
END;
