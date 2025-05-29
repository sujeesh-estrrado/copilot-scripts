IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_inserted_Subjectid_LMS]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_inserted_Subjectid_LMS]
@Candidateid bigint
As Begin
select SM.Student_Subject_Map_Master,SM.Candidate_id,SC.Subject_Id
from Tbl_Student_Subject_Master SM inner join Tbl_Student_Subject_Child SC 
On SC.Student_Subject_Map_Master=SM.Student_Subject_Map_Master
where SM.Candidate_id=@Candidateid

END
    ')
END
