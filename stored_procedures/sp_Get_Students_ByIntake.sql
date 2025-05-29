IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Students_ByIntake]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[sp_Get_Students_ByIntake]
(
@intake_id bigint=0
)
as
begin
SELECT        distinct (CPD.Candidate_Id), CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname) as studentname,
n.Batch_Id,CPD.Agent_ID
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD inner join Tbl_Student_status S on s


.id=CPD.active
		left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id
					LEFT OUTER JOIN
					tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id left join
					dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN
					dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id LEFT OUTER JOIN
					Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join
					dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId 
					 LEFT OUTER JOIN
					dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN
					dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN
					dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId	
					left join Tbl_Student_status JJ on JJ.id=CPD.active
		where (CPD.Agent_ID!=0 and CPD.Agent_ID is not null) and (n.Batch_Id= @intake_id or @intake_id=0)

end


    ')
END;
