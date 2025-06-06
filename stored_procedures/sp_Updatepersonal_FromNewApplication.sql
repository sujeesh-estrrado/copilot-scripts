IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Updatepersonal_FromNewApplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[sp_Updatepersonal_FromNewApplication] --0,0,0,''all'',''2018-09-01 00:00:00.000'',null,1,100000
(
@Candidate_Id bigint=0
)
as 
begin
if exists(select * from Tbl_Student_NewApplication where candidate_DelStatus=0 and Candidate_Id=@Candidate_Id)
    begin
        declare @New_Admission_Id bigint=(select  New_Admission_Id from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @Option2 bigint=(select  Option2 from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @Option3 bigint=(select  Option3 from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @ApplicationStage varchar(Max)=(select  ApplicationStage from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @CounselorEmployee_Id bigint=(select  CounselorEmployee_Id from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @ApplicationStatus varchar(Max)=(select  ApplicationStatus from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @regdate datetime=(select  regdate from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);
        declare @active bigint=(select  active from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and candidate_DelStatus=0);

        Update tbl_Candidate_personal_Det set   
             New_Admission_Id=@New_Admission_Id
             ,Option2=@Option2,Option3=@Option3,
             ApplicationStage=@ApplicationStage,CounselorEmployee_Id=@CounselorEmployee_Id,
             ApplicationStatus=@ApplicationStatus,regdate=@regdate,active=@active 
             where Candidate_Id=@Candidate_Id and candidate_DelStatus=0

        Update Tbl_Student_NewApplication set candidate_DelStatus=1 where Candidate_Id=@Candidate_Id

    end
end
    ')
END;
