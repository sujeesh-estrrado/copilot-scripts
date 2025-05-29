IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_New_Admission_byStudentId_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_New_Admission_byStudentId_New]
(@candidate_id int)
as
begin
select month( Batch_From) as month,year(Batch_From) AS YEAR,Batch_Id,Org_Id,
Department_Id as pgmid,Course_Category_Name,Course_Category_Id 
from view_Student_program_bind where Candidate_Id=@candidate_id;
end
    ')
END;
