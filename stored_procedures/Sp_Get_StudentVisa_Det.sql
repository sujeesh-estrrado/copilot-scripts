IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_StudentVisa_Det]')
    AND type = N'P'
)
BEGIN
    EXEC('
  create procedure [dbo].[Sp_Get_StudentVisa_Det]
@Candidate_Id bigint
as
begin

select *,CPD.PassportDate from Tbl_Visa_Renewal VR LEFT JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id= VR.Candidate_Id where VR.Candidate_Id=@Candidate_Id and VR.Del_Status=0 order by VR.Applied_Date
end
    ')
END;
