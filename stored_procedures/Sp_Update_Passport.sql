IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Passport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
Create Procedure [dbo].[Sp_Update_Passport]
@Candidate_Id bigint,
@PassportNo Varchar(100),
@passexp date
as
begin
update Tbl_Candidate_Personal_Det set AdharNumber=@PassportNo , PassportDate = @passexp where Candidate_Id=@Candidate_Id
end
   ')
END;
