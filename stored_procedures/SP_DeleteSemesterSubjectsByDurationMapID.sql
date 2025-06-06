IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DeleteSemesterSubjectsByDurationMapID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_DeleteSemesterSubjectsByDurationMapID](@Duration_Mapping_Id bigint)
as
begin
DELETE FROM Tbl_Semester_Subjects WHERE Duration_Mapping_Id=@Duration_Mapping_Id
end
    ')
END
