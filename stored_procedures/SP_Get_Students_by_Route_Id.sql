IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_by_Route_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_Students_by_Route_Id]
@Duration_Mapping_Id bigint,
@RouteFeeId  bigint
AS
BEGIN
    Select
    S.Student_Semester_Id,
    S.Candidate_Id,
    S.Duration_Mapping_Id,
    Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname As [CandidateName],
    ISNULL(Student_Route_Mapping_Id, 0) As Student_Route_Mapping_Id,
    ISNULL((Select Student_Route_Mapping_Id From Tbl_Student_Route_Mapping where RouteFeeId <> @RouteFeeId and Candidate_Id = C.Candidate_Id), 0)  As OtherRouteId
    From Tbl_Student_Semester S
    Inner Join Tbl_Candidate_Personal_Det C On S.Candidate_Id = C.Candidate_Id
    Left Join Tbl_Student_Route_Mapping srm on srm.Candidate_Id = C.Candidate_Id and srm.RouteFeeId = @RouteFeeId
    Where S.Duration_Mapping_Id = @Duration_Mapping_Id and Student_Semester_Current_Status = 1 and Student_Semester_Delete_Status = 0
    Order By CandidateName ASC
End
    ')
END;
