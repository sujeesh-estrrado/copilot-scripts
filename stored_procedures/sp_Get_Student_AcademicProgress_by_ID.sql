IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Student_AcademicProgress_by_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  CREATE procedure [dbo].[sp_Get_Student_AcademicProgress_by_ID]--35958
(@User_Id bigint)
as
Begin
select BD.Batch_Id, P.Candidate_Id,Candidate_Fname,Candidate_Lname,AdharNumber,DP.Semester_Id,
case when RegDate is null then ''N/A'' when RegDate='''' then ''N/A'' else REPLACE(REPLACE(CONVERT(VARCHAR,RegDate,106), '' '',''/''), '','','''')end as SubmissionDate,
case when R.Created_Date is null then ''N/A'' when R.Created_Date='''' then ''N/A'' else REPLACE(REPLACE(CONVERT(VARCHAR,R.Created_Date,106), '' '',''/''), '','','''')end as AdmissionDate,
case when DP.Duration_Period_from is null then ''N/A'' when DP.Duration_Period_from='''' then ''N/A'' else REPLACE(REPLACE(CONVERT(VARCHAR,DP.Duration_Period_from,106), '' '',''/''), '','','''')end as sem1startdate,
 ''N/A'' as sem1ExamDate,''N/A'' as ResultPublishStatus,''N/A'' as FinalSelection

from dbo.Tbl_Candidate_Personal_Det P
inner join Tbl_Candidate_ContactDetails C on C.Candidate_Id=P.Candidate_Id 
left join Tbl_Student_Registration R on R.Candidate_Id=P.Candidate_Id
left join tbl_New_Admission NA on NA.New_Admission_Id=P.New_Admission_Id
left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id
left join Tbl_Course_Duration_PeriodDetails DP on DP.Batch_Id = BD.Batch_Id
where P.Candidate_Id=@User_Id and Semester_Id=1
end

--select * from Tbl_Candidate_Personal_Det where Candidate_Id=30073
--select * from Tbl_Candidate_ContactDetails where Candidate_Id=20034
--select * from Tbl_Student_Semester where Candidate_Id=30073
--select * from Tbl_Student_Registration
    ');
END;
