IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_New_Admission_byCandidate_Id_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Get_New_Admission_byCandidate_Id_New]
(@candidate_id int)
as
begin
select month( Batch_From) as month,year(Batch_From) AS YEAR,Batch_Id,Org_Id,--fORMAT( Batch_From,''MM'') as month,
Department_Id as pgmid,Course_Category_Name,Course_Category_Id,course_level_id,Batch from view_programL_bind where Candidate_Id=@candidate_id;
end
    ')
END;
