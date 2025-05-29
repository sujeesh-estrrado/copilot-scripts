IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Candidate_PersonalDet_otherstab]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Update_Candidate_PersonalDet_otherstab]
(@Candidate_Id bigint,
@Room_required varchar(max),
@Room_Type varchar(max))

as
begin
update Tbl_Candidate_Personal_Det set Room_Type=@Room_Type,Hostel_Required=@Room_required where Candidate_Id=@Candidate_Id;
end
    ')
END
