IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Student_NewApplication_programtab]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Update_Student_NewApplication_programtab]
(@Candidate_Id bigint,@Modeofstudy varchar(500),@Sponser varchar(200),
@remark varchar(max),@Campus varchar(200))
as
begin
update Tbl_Student_NewApplication set Mode_Of_Study=@Modeofstudy,
Scolorship_Name=@Sponser,Campus=@Campus,CounselorCampus=@Campus,
Scolorship_Remark=@remark where Candidate_Id=@Candidate_Id;

    if exists(select ApplicationStage from Tbl_Student_NewApplication where ApplicationStatus=''pending'' or ApplicationStatus=''Pending'')
        begin
            Update Tbl_Student_NewApplication set ApplicationStage=''In-Progress''
            where ApplicationStatus=''pending'' or ApplicationStatus=''Pending''
        end
end
    ')
END;
