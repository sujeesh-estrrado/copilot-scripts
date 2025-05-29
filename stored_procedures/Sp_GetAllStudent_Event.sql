IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAllStudent_Event]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetAllStudent_Event]
@flag bigint
as
begin
if(@flag=0)
begin 
SELECT 
   Candidate_Id ,
    Candidate_Fname + '' '' + Candidate_Lname AS StudentName
FROM 
    [dbo].[Tbl_Candidate_Personal_Det]
WHERE 
    ApplicationStatus IS NOT NULL 
    AND [Candidate_DelStatus] = 0
    AND (New_Admission_Id <> '''' AND New_Admission_Id <> 0)

end
end
    ')
END;
