IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Candidate_PersonalDet_programtab]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Update_Candidate_PersonalDet_programtab](@Candidate_Id bigint,@Modeofstydu varchar(500),@Sponser varchar(200),@remark varchar(max),@Campus varchar(200),@FromStream varchar(100),@empid bigint)
as
begin
update Tbl_Candidate_Personal_Det set Mode_Of_Study=@Modeofstydu,Scolorship_Name=@Sponser,Campus=@Campus,CounselorCampus=@Campus,
Scolorship_Remark=@remark,counselorEmployee_id=@empid
--,Candidate_Stream=@FromStream
where Candidate_Id=@Candidate_Id;
end

    ')
END
