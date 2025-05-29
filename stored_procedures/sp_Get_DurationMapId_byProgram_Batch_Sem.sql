IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_DurationMapId_byProgram_Batch_Sem]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_DurationMapId_byProgram_Batch_Sem]
(@ProgramID bigint=0,
@SemId bigint=0,
@BatchID bigint=0
)
as
begin

	SELECT        CDM.Duration_Mapping_Id, bd.Batch_From, bd.Batch_To, bd.Batch_Code + ''-'' + cs.Semester_Code AS BatchSemester, D.Department_Name, D.Department_Id, 
							 cs.Semester_Id, bd.Batch_Id
	FROM            dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN
							 dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id LEFT OUTER JOIN
							 dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cd.Semester_Id LEFT OUTER JOIN
							 dbo.Tbl_Course_Duration_Mapping AS CDM ON CDM.Duration_Period_Id = cd.Duration_Period_Id LEFT OUTER JOIN
							 dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = CDM.Course_Department_Id LEFT OUTER JOIN
							 dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = Cdep.Course_Category_Id LEFT OUTER JOIN
							 dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id
	WHERE        (D.Department_Id = @ProgramID) AND (cs.Semester_Id = @SemId) AND (bd.Batch_Id = @BatchID)
end
');
END;
