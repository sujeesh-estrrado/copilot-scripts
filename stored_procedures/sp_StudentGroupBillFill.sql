IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentGroupBillFill]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_StudentGroupBillFill]       
--[dbo].[sp_StudentGroupBillFill] 3,4,3945,''''    
@FacultyId bigint = 0 ,      
@ProgramId bigint = 0 ,      
@Intakeid bigint = 0 ,      
@Type varchar(50)       
--@Semesterno bigint = 0       
as      
begin      
      
 SELECT     distinct  (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname,'' '', CPD.Candidate_Lname)       
  AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img, CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport,       
  CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.Status, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo, --CPD.ApplicationStatus,      
  CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1,        
  bd.Batch_Id, bd.Batch_Code as Intake, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id      
  ,S.name as ApplicationStatus  --, cs.Semester_Id, cs.Semester_Name, SS.Student_Semester_Current_Status    
 FROM                
 dbo.Tbl_Candidate_Personal_Det AS CPD     
 inner join Tbl_Student_status S on s.id=CPD.active      
 left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id      
 LEFT OUTER JOIN   tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id     
 left join   dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id    
     
 --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN      
 --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN      
 LEFT OUTER JOIN   dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id     
 --LEFT OUTER JOIN  Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id     
 --left join  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId       
 LEFT OUTER JOIN  dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id     
 LEFT OUTER JOIN  dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id     
 LEFT OUTER JOIN  dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId      
           
            
 WHERE      
 (CPD.TypeOfStudent = @Type or @Type = '''' or @Type is null )        
--AND  (cs.Semester_Id = @Semesterno or @Semesterno=0)
--and  (CPD.active =3)      
 --and(cd.Batch_Id= @Intakeid or @Intakeid=0 )and      
 --(D.Department_Id = @ProgramId or @ProgramId=0 )      
 --and(CL.Course_Level_Id = @FacultyId or @FacultyId=0 )      
 --and (CPD.CounselorCampus = @Campus or @Campus='''' )and      
 and
 (n.Batch_Id= @Intakeid or @Intakeid=0 )and      
 (n.Department_Id = @ProgramId or @ProgramId=0 )      
 and(n.Course_Level_Id = @FacultyId or @FacultyId=0 )      
 --and      
 --(CPD.ApplicationStatus IS NOT NULL) AND       
 --(CPD.Candidate_DelStatus = 0) AND       
 --(CPD.New_Admission_Id <> '''') AND       
 --(CPD.New_Admission_Id <> 0)  
 --and SS.Student_Semester_Current_Status = 1    
     
 order by  StudentName       
end 
    ')
END
