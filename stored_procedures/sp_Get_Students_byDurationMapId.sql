IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Students_byDurationMapId]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Get_Students_byDurationMapId]
    @Duration_Mapping_Id BIGINT = 0
AS
BEGIN
    SELECT 
        SS.Candidate_Id, 
        SS.Student_Semester_Current_Status, 
        CPD.ApplicationStatus
    FROM 
        dbo.Tbl_Student_Semester AS SS
    INNER JOIN 
        dbo.Tbl_Candidate_Personal_Det AS CPD ON SS.Candidate_Id = CPD.Candidate_Id
    WHERE 
        SS.Duration_Mapping_Id = @Duration_Mapping_Id 
        AND SS.Student_Semester_Delete_Status <> 1 
        AND CPD.ApplicationStatus = ''Completed''
        AND CPD.active = 3
END
    ')
END;