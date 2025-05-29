IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Update_StudentNewApplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Insert_Update_StudentNewApplication]
(@Candidate_Id bigint=0,
@New_Admission_Id bigint=0,
@Option2 bigint=0,
@Option3 bigint=0,
@Campus bigint=0,
@CounselorEmployee_id bigint=0,
@EnrollBy Varchar(MAX)='''',
@ApplicationStatus Varchar(MAX)='''',
@Mode_Of_Study Varchar(MAX)='''',
@billoutstanding decimal(18,2)=0
)
as 
begin
if not  exists(select * from Tbl_Student_NewApplication where Candidate_Id=@Candidate_Id and Candidate_DelStatus=0)
begin
Insert into Tbl_Student_NewApplication(
Candidate_Id,Candidate_DelStatus,New_Admission_Id,Option2,Option3,RegDate,Campus,CounselorCampus,CounselorEmployee_id,
EnrollBy,Active_Status,IDMatrixNo,ApplicationStatus,FeeStatus,Mode_Of_Study,Edit_status,Edit_request,
billoutstanding,Invoice_Status,Payment_Request_Status,create_date,active,LastUpdate,Edit_request_remark,
documentcomplete,ButtonStatus,ApplicationStage) values
(@Candidate_Id,0,@New_Admission_Id,@Option2,@Option3,GETDATE(),@Campus,@Campus,@CounselorEmployee_id,
@EnrollBy,''Active'','''',@ApplicationStatus,'''',@Mode_Of_Study,0,0,
@billoutstanding,'''','''',GETDATE(),1,GETDATE(),'''',0,''Programme'',''Initial Application'')
end
--else
 
--begin
--Update Tbl_Student_NewApplication set New_Admission_Id=@New_Admission_Id,
--Option2=@Option2,Option3=@Option3,Campus=@Campus,Mode_Of_Study=@Mode_Of_Study,LastUpdate=getdate()
-- where Candidate_Id=@Candidate_Id
--end

end

    ');
END;
