IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Student_Intake_Migration]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE procedure [dbo].[sp_Get_Student_Intake_Migration]-- 256
(
@Candidateid bigint
--,@Course_Department_Id bigint
)
As
Begin


SELECT distinct CPD.Candidate_Id as ID,SG.BloodGroup,CPD.Candidate_Id  ,cdp.Duration_Period_Id,
EC.Employee_FName+'' ''+EC.Employee_LName as Employee_Name,ss.Duration_Mapping_Id,
CPD.RegDate,case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from 
Tbl_Course_Batch_Duration cbd where
cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,
CPD.CounselorCampus,
CPD.TypeOfStudent,
CONCAT(CPD.Candidate_Fname,'' '',CPD.Candidate_Lname )as CandidateName,
CPD.Candidate_Fname,CPD.AdharNumber,
CPD.Candidate_Dob as DOB,


CPD.New_Admission_Id as AdmnID,
CPD.ApplicationStage as Stage,
CPD.ApplicationStatus as ApplicationStatus,
CC.Candidate_idNo as IdentificationNumber ,

CC.Candidate_ContAddress as Address,
CC.Candidate_Mob1 as MobileNumber,
CC.Candidate_Email as EmailID 

,
CCat.Course_Category_Id,
CPD.Hostel_Required as Hostel_Required,

cbd.Batch_Id as BatchID,

cbd.Batch_Code as Batch,
ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
NA.Batch_Id,




(Case when SR.UserId IS NULL  Then '' ''
Else Isnull(E.

 Employee_FName,''Admin'') END) as UserName,

NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],
NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],

NA.Department_Id as DepartmentID,


case when  NA.Department_Id=

0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where
D.Department_Id=NA.Department_Id)  end  as Department


FROM Tbl_Candidate_Personal_Det  CPD

left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id left join
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0
and   ss.student_semester_current_status=1
left JOIN
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id

left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id

left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id

left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id

left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id
left join  Tbl_Department D on NA.Department_Id=D.Department_Id
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)
 left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id
left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id and EC.Employee_Status=0)
left Join (
select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where Follow_Up_Detail_Id in
(select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id

where CPD.Candidate_Id=@Candidateid

end
    ');
END;
