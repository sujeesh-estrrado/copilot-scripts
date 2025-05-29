IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_load_department_withFacultyid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_load_department_withFacultyid](@levelofprogram bigint)
as
begin
select * from Tbl_Department where GraduationTypeId=@levelofprogram;
end
    ');
END;
