IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Fee_Code_By_Intake_course]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE  procedure [dbo].[SP_Get_Fee_Code_By_Intake_course] --11830 ,27297
(@IntakeId bigint,@DurationMappingId bigint)

as begin

select IFM.FeeCode,IFM.InakeFeecodeMapID from dbo.Tbl_IntakeFeecodeMap IFM
--inner join dbo.Tbl_Course_Department CD on CD.Department_Id=IFM.CourseId
--inner join dbo.Tbl_Course_Duration_Mapping CDM on CDM.Course_Department_Id=CD.Course_Department_Id
where IFM.IntakeId=@IntakeId and IFM.CourseId=@DurationMappingId
end

    ')
END
