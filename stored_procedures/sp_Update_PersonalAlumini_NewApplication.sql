IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Update_PersonalAlumini_NewApplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE  procedure [dbo].[sp_Update_PersonalAlumini_NewApplication]-- 1,'''',100000,1
(
@flag bigint=0,
@Candidate_Id bigint=0,
@CounselorEmployee_id bigint=0
)
as

begin
    if(@flag=0)
        begin
            update Tbl_Candidate_Personal_Det set New_Admission_Id=NULL,ApplicationStatus=''pending'',active=1,RegDate=getdate(),
            CounselorEmployee_id=0,EnrollBy=NULL,IDMatrixNo='''',Agent_ID=0,Option2=NULL,Option3=NULL,FeeStatus=''not paid'',
            ApplicationStage=''Initial Application'',recruitedby_other=NULL
            where Candidate_Id=@Candidate_Id
        end
    if(@flag=1)
        begin
            update Tbl_Candidate_Personal_Det set 
            CounselorEmployee_id=@CounselorEmployee_id
            where Candidate_Id=@Candidate_Id
        end
end
   ')
END;
