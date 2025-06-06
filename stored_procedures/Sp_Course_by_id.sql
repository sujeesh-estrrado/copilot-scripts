IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Course_by_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Course_by_id] --1252  
(@id bigint,
 @Flag bigint=0


)  
as  
begin  
                                        
 if(@Flag=0)
 begin
  SELECT DISTINCT   
                         TOP (100) PERCENT CPD.Candidate_Id AS ID, SG.BloodGroup,CPD.active,fg.groupid,convert(varchar(50),cdp.Duration_Period_From,103) as Duration_Period_From, Concat(Candidate_Fname , '' '' , CPD.Candidate_Lname) AS CandidateName,CPD.CounselorEmployee_id,n.Nationality as nationality,cpd.RegDate as RegDate,  
                          CPD.Candidate_Fname, CPD.AdharNumber, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CPD.AdharNumber as icno,CPD.TypeOfStudent,CPD.SourceOfFunding as Sponsor ,  
                         CC.Candidate_idNo AS IdentificationNumber, CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email AS EmailID,CPD.Mode_Of_Study,   cpd.IDMatrixNo,
                         CCat.Course_Category_Id,im.id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id, CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE  
                             (SELECT        cbd.Batch_Code  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (SELECT        cbd.dateregsatart  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) as Registration_Date,DATEADD(DAY, -7, (SELECT        cbd.dateregsatart  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id)) AS OneWeekBeforeRegDate,    DATEDIFF(MONTH, cbd.Batch_From, cbd.Batch_To) / 12 AS Years,
    DATEDIFF(MONTH, cbd.Batch_From, cbd.Batch_To) % 12 AS Months, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END)   
                         AS UserName, NA.Course_Level_Id AS LevelID, CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID,   
                         CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID, CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE  
                             (SELECT        D .Department_Name  
                               FROM            Tbl_Department D  
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department ,D.Course_Code AS Prgmcode, CPD.Candidate_Img,
                 SS.SEMESTER_NO,cdp.Semester_Id
                --'''' SEMESTER_NO
                 ,(SELECT CONVERT(DATE, cbd.Batch_From) 
FROM Tbl_Course_Batch_Duration cbd
WHERE cbd.Batch_Id = NA.Batch_Id)AS Intake_StartDate,(SELECT CONVERT(DATE, cbd.Batch_To) 
FROM Tbl_Course_Batch_Duration cbd
WHERE cbd.Batch_Id = NA.Batch_Id)AS Intake_EndDate,
                                 '''' as LevelType,(select distinct fg.totalintl from fee_group fg where fg.programIntakeID=cbd.Batch_Id and fg.Promotional=0 and fg.deletestatus=0) as Interntnl_Fee,(select distinct fg.totallocal from fee_group fg where fg.programIntakeID=cbd.Batch_Id and fg.Promotional=0 and fg.deletestatus=0) as Local_Fee, '''' as MMU_Faculty_Code,'''' as AdmitTerm,'''' as Study_Mode,'''' AS Prgm_Duration 
FROM            dbo.Tbl_Course_Level AS CL INNER JOIN  
                         dbo.Tbl_Department AS D ON CL.Course_Level_Id = D.GraduationTypeId RIGHT OUTER JOIN  
                         dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN  
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
             LEFT OUTER JOIN  
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id  AND   
                         SS.Student_Semester_Current_Status = 1 
             LEFT OUTER JOIN  
                         --dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN  
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
             LEFT OUTER JOIN  
                        dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdp.Duration_Period_Id = ss.Duration_Period_Id--- and SS.SEMESTER_NO=cdp.Semester_Id 
             LEFT OUTER JOIN  
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
             inner join Tbl_IntakeMaster im on im.id=cbd.IntakeMasterID
             LEFT OUTER JOIN 
             fee_group as fg on fg.programIntakeID=cbd.Batch_Id
             --LEFT OUTER JOIN  
       --                  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id
             LEFT OUTER JOIN  
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id ON D.Department_Id = NA.Department_Id LEFT OUTER JOIN  
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN  
                         dbo.Tbl_Employee AS E ON E.Employee_Id =  
                             (SELECT        Employee_Id  
                               FROM            dbo.Tbl_Employee_User  
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN  
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id  
        left join Tbl_Nationality n on n.Nationality_Id=try_convert(bigint,CPD.Candidate_Nationality  )
WHERE         (CPD.Candidate_Id = @id)   --AND fg.deleteStatus=0
ORDER BY ID DESC  
 end  
 
 if(@Flag=1)
 begin
  SELECT DISTINCT   
                         TOP (100) PERCENT CPD.Candidate_Id AS ID, SG.BloodGroup,CPD.active, Concat(Candidate_Fname , '' '' , CPD.Candidate_Lname) AS CandidateName,CPD.CounselorEmployee_id,n.Nationality as nationality,  
                          CPD.Candidate_Fname, CPD.AdharNumber, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CPD.AdharNumber as icno,CPD.TypeOfStudent,  
                         CC.Candidate_idNo AS IdentificationNumber, CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email AS EmailID,CPD.Mode_Of_Study,     cpd.IDMatrixNo, 
                         CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id, CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE  
                             (SELECT        cbd.Batch_Code  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (SELECT        cbd.dateregsatart  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) as Registration_Date, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END)   
                         AS UserName, NA.Course_Level_Id AS LevelID, CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID,   
                         CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID, CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE  
                             (SELECT        D .Department_Name  
                               FROM            Tbl_Department D  
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department , CPD.Candidate_Img,
                 SS.SemesterId AS semester_id,
                 SS.SEMESTER_NO
                --'''' SEMESTER_NO
                 ,(SELECT        cbd.Batch_From  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) as Intake_StartDate,
                                 '''' as LevelType,'''' as MMU_Faculty_Code,'''' as AdmitTerm,'''' as Study_Mode,'''' AS Prgm_Duration 
FROM            dbo.Tbl_Course_Level AS CL INNER JOIN  
                         dbo.Tbl_Department AS D ON CL.Course_Level_Id = D.GraduationTypeId RIGHT OUTER JOIN  
                         dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN  
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
             LEFT OUTER JOIN  
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id  AND   
                         SS.Student_Semester_Current_Status = 1 
             LEFT OUTER JOIN  
                         --dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN  
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.Option2 
             --LEFT OUTER JOIN  
       --                  dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON NA.Batch_Id = cdp.Duration_Period_Id and SS.SEMESTER_NO=cdp.Semester_Id 
             LEFT OUTER JOIN  
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
             --LEFT OUTER JOIN  
       --                  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id
             LEFT OUTER JOIN  
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id ON D.Department_Id = NA.Department_Id LEFT OUTER JOIN  
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN  
                         dbo.Tbl_Employee AS E ON E.Employee_Id =  
                             (SELECT        Employee_Id  
                               FROM            dbo.Tbl_Employee_User  
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN  
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id  
        left join Tbl_Nationality n on n.Nationality_Id=try_convert(bigint,CPD.Candidate_Nationality  )
WHERE         (CPD.Candidate_Id = @id)  
ORDER BY ID DESC  
 end  

 if(@Flag=2)
 begin
  SELECT DISTINCT   
                         TOP (100) PERCENT CPD.Candidate_Id AS ID, SG.BloodGroup,CPD.active, Concat(Candidate_Fname , '' '' , CPD.Candidate_Lname) AS CandidateName,CPD.CounselorEmployee_id,n.Nationality as nationality,  
                          CPD.Candidate_Fname, CPD.AdharNumber, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CPD.AdharNumber as icno,CPD.TypeOfStudent,  
                         CC.Candidate_idNo AS IdentificationNumber, CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email AS EmailID,CPD.Mode_Of_Study,      
                         CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id, CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE  
                             (SELECT        cbd.Batch_Code  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (SELECT        cbd.dateregsatart  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) as Registration_Date, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END)   
                         AS UserName, NA.Course_Level_Id AS LevelID, CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID,   
                         CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID, CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE  
                             (SELECT        D .Department_Name  
                               FROM            Tbl_Department D  
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department , CPD.Candidate_Img,
                  SS.SemesterId AS semester_id,
                 SS.SEMESTER_NO
                --'''' SEMESTER_NO
                 ,(SELECT        cbd.Batch_From  
                               FROM            Tbl_Course_Batch_Duration cbd  
                               WHERE        cbd.Batch_Id = NA.Batch_Id) as Intake_StartDate,
                                 '''' as LevelType,'''' as MMU_Faculty_Code,'''' as AdmitTerm,'''' as Study_Mode,'''' AS Prgm_Duration 
FROM            dbo.Tbl_Course_Level AS CL INNER JOIN  
                         dbo.Tbl_Department AS D ON CL.Course_Level_Id = D.GraduationTypeId RIGHT OUTER JOIN  
                         dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN  
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id 
             LEFT OUTER JOIN  
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id  AND   
                         SS.Student_Semester_Current_Status = 1 
             LEFT OUTER JOIN  
                         --dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN  
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.Option3 
             --LEFT OUTER JOIN  
       --                  dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON NA.Batch_Id = cdp.Duration_Period_Id and SS.SEMESTER_NO=cdp.Semester_Id 
             LEFT OUTER JOIN  
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = NA.Batch_Id 
             --LEFT OUTER JOIN  
       --                  dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id
             LEFT OUTER JOIN  
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id ON D.Department_Id = NA.Department_Id LEFT OUTER JOIN  
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN  
                         dbo.Tbl_Employee AS E ON E.Employee_Id =  
                             (SELECT        Employee_Id  
                               FROM            dbo.Tbl_Employee_User  
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN  
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id  
        left join Tbl_Nationality n on n.Nationality_Id=try_convert(bigint,CPD.Candidate_Nationality  )
WHERE         (CPD.Candidate_Id = @id)  
ORDER BY ID DESC  
 end 

    END
    ')
END
