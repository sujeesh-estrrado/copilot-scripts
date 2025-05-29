IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Getall_CandidateStudents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Getall_CandidateStudents]  --0,''a''
(@Flag bigint=0,
@SearchTerm varchar(Max)='''')
as
begin
                                      
if(@Flag=0)
begin                                        
SELECT Candidate_Id,concat(Candidate_Fname,'' '',Candidate_Lname,'' ('',AdharNumber,'')'')as Studentname 
from Tbl_Candidate_Personal_Det where (concat(Candidate_Fname,'' '',Candidate_Lname) like concat(''%'',@SearchTerm,''%'') 
or AdharNumber like concat(''%'',@SearchTerm,''%''))

order by concat(Candidate_Fname,'' '',Candidate_Lname)


end
                                                        
    END
    ')
END;
