IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Marketing_bind_Accepted_candidate_list]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Marketing_bind_Accepted_candidate_list] --0,'''',0,1,10,0,0,0,''991018755058''          
--[dbo].[Sp_Marketing_bind_Accepted_candidate_list] '''',3,1,10,1,1,2          
(          
@Flag bigint=0,          
@application_status varchar(500)='''',          
@counselor_Id bigint=0,          
@CurrentPage int=null,          
@pagesize bigint null,          
@organization_id bigint=0,           
@intake_id bigint=0,          
@Department_id bigint=0,          
@Searchkeyword VARCHAR(max)='''',          
@Status bigint=0          
          
)          
as          
begin          
if(@Flag=0)          
begin          
if(@application_status=''Verified'')          
begin          
          
SELECT DISTINCT CPD.Candidate_Id AS ID, SG.BloodGroup, CPD.IDMatrixNo, CPD.Candidate_Gender, CPD.IdentificationNo,          
       CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,           
                         CPD.Candidate_Fname, CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CC.Candidate_idNo AS IdentificationNumber,           
                         CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email, CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id,          
          
 Case when CPD.ApplicationStatus=''approved'' then ''Approved'' when          
  CPD.ApplicationStatus=''Verified''  then ''Verified''when  CPD.ApplicationStatus=''Conditional_Admission'' then ''Conditional Admission''           
when  CPD.ApplicationStatus=''Preactivated'' then    ''Preactivated''  when  CPD.ApplicationStatus=''Completed'' then ''Student''          
 else ''Verified'' end as CurrentStatus,                         
                
       CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE          
                             (SELECT        cbd.Batch_Code          
                               FROM            Tbl_Course_Batch_Duration cbd          
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END) AS UserName, NA.Course_Level_Id AS LevelID,           
                         CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID, CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID,           
                         CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE          
                             (SELECT        D .Department_Name          
                               FROM            Tbl_Department D          
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department_Name,    
         -- dbo.tbl_approval_log.Offerletter_status as offerletter,    
          DEL.Remarks as AdmissionRemark,DEL.Reject_remark AS CounsellorRemark          
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD     
   --LEFT JOIN   dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id     
   LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN          
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Employee AS E ON E.Employee_Id =          
                             (SELECT        Employee_Id          
                               FROM            dbo.Tbl_Employee_User          
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN          
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id left Outer Join          
       Dbo.Tbl_Delete_Request AS DEL on DEL.Candidate_id=CPD.Candidate_Id              
                     
              
                                                          
where  (CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' )           
--and  tbl_approval_log.delete_status=0 and tbl_approval_log.Offerletter_status=1           
and (CPD.Campus= @organization_id or @organization_id=''0'')          
and (NA.Department_Id= @Department_id  or @Department_id=''0'')          
and (NA.Batch_Id= @intake_id or @intake_id=''0'')          
and (CPD.CounselorEmployee_id=@counselor_Id or @counselor_Id=0)          
and (CPD.ApplicationStatus=''approved'' or CPD.ApplicationStatus=''Verified''            
or  CPD.ApplicationStatus=''Conditional_Admission'' or  CPD.ApplicationStatus=''Preactivated'') and CPD.Candidate_DelStatus=0          
and CPD.ApplicationStatus is not null          
and (@Status=0 or CPD.active=@Status)          
AND (IDMatrixNo LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Gender LIKE  ''%''+@Searchkeyword+''%'' OR          
 CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE  ''%''+@Searchkeyword+''%'' OR
 CPD.Candidate_Fname LIKE ''%''+@Searchkeyword+''%'' or
 AdharNumber LIKE  ''%''+@Searchkeyword+''%'' OR          
TypeOfStudent LIKE  ''%''+@Searchkeyword+''%'' OR          
Status LIKE  ''%''+@Searchkeyword+''%''OR          
Candidate_Dob LIKE  ''%''+@Searchkeyword+''%'' OR          
ApplicationStatus LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_idNo  LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_Mob1 LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_Email LIKE  ''%''+@Searchkeyword+''%'' OR          
Batch_Code LIKE  ''%''+@Searchkeyword+''%'' OR          
                
 CCat.Course_Category_Name LIKE  ''%''+@Searchkeyword+''%'' OR          
 Department_Name LIKE  ''%''+@Searchkeyword+''%'' OR          
 --Offerletter_status LIKE  ''%''+@Searchkeyword+''%'' OR           
Reject_remark LIKE  ''%''+@Searchkeyword+''%'' OR @Searchkeyword='''')          
          
          
 order by ID desc             
 OFFSET @pagesize * (@CurrentPage - 1) ROWS          
      FETCH NEXT @pagesize ROWS ONLY          
          
   end          
else          
if(@application_status=''Rejected'')          
begin          
                              
          
          
          
          
      SELECT DISTINCT           
                         CPD.Candidate_Id AS ID, SG.BloodGroup, CPD.IDMatrixNo, CPD.Candidate_Gender, CPD.IdentificationNo,          
       CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,           
                         CPD.Candidate_Fname, CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CC.Candidate_idNo AS IdentificationNumber,           
                         CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email, CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id,           
                       ''Rejected''as   CurrentStatus,          
          CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE          
                             (SELECT        cbd.Batch_Code          
                               FROM            Tbl_Course_Batch_Duration cbd          
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END) AS UserName, NA.Course_Level_Id AS LevelID,           
                         CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID, CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID,           
                         CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE          
                             (SELECT        D .Department_Name          
      FROM            Tbl_Department D          
    WHERE        D .Department_Id = NA.Department_Id) END AS Department_Name --, dbo.tbl_approval_log.Offerletter_status as offerletter          
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD    
 --LEFT JOIN      dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id     
LEFT OUTER JOIN          
            dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN          
                dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN          
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Employee AS E ON E.Employee_Id =          
                             (SELECT        Employee_Id          
                               FROM            dbo.Tbl_Employee_User          
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN          
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id                
                     
                          
                                                          
where          
        
 (CPD.ApplicationStatus=@application_status or @application_status is null)           
 --and  tbl_approval_log.delete_status=0 and tbl_approval_log.Offerletter_status=1         
and (CPD.Campus= @organization_id or @organization_id=''0'')          
and (NA.Department_Id= @Department_id  or @Department_id=''0'')          
and (NA.Batch_Id= @intake_id or @intake_id=''0'')          
and (CounselorEmployee_id=@counselor_Id or @counselor_Id=0)          
and (@Status=0 or CPD.active=@Status)          
AND (IDMatrixNo LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Gender LIKE  ''%''+@Searchkeyword+''%'' OR          
 CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%''+@Searchkeyword+''%'' OR          
 AdharNumber LIKE ''%''+@Searchkeyword+''%'' OR          
TypeOfStudent LIKE ''%''+@Searchkeyword+''%'' OR          
Status LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Dob LIKE ''%''+@Searchkeyword+''%'' OR          
ApplicationStatus LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_idNo  LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Mob1 LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Email LIKE ''%''+@Searchkeyword+''%'' OR          
Batch_Code LIKE ''%''+@Searchkeyword+''%'' OR          
                
 CCat.Course_Category_Name LIKE ''%''+@Searchkeyword+''%'' OR          
 Department_Name LIKE ''%''+@Searchkeyword+''%''     
 --OR Offerletter_status LIKE ''%''+@Searchkeyword+''%''      
 OR @Searchkeyword=''''    
 )          
 --select * from #TEMP2 where RowNumber >  CONVERT(VARCHAR,@LowerBand1)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand1)           
 order by ID desc             
 OFFSET @pagesize * (@CurrentPage - 1) ROWS          
      FETCH NEXT @pagesize ROWS ONLY          
      end          
          
else          
          
begin          
          
          
          
          
SELECT DISTINCT           
                         CPD.Candidate_Id AS ID, SG.BloodGroup, CPD.IDMatrixNo, CPD.Candidate_Gender, CPD.IdentificationNo,          
       CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,           
                         CPD.Candidate_Fname, CPD.AdharNumber, CPD.TypeOfStudent, CPD.Status, CPD.Candidate_Dob AS DOB, CPD.New_Admission_Id AS AdmnID, CPD.ApplicationStatus, CC.Candidate_idNo AS IdentificationNumber,           
                         CC.Candidate_ContAddress AS Address, CC.Candidate_Mob1 AS MobileNumber, CC.Candidate_Email, CCat.Course_Category_Id, cbd.Batch_Id AS BatchID, cbd.Batch_Code AS Batch, NA.Batch_Id,          
          
 concat(S.name,'' - '',    
Case When ApplicationStatus=''pending''Then ''Enquiry List''    
When ApplicationStatus=''Pending''Then ''Enquiry List''    
When ApplicationStatus=''submited''Then ''Enquiry List''    
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''    
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''    
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''    
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''    
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''    
Else ''Student List(Admissions)'' end) as  CurrentStatus,                         
                
       CASE WHEN NA.Batch_Id = 0 THEN ''Unspecified'' ELSE          
                             (SELECT        cbd.Batch_Code          
                               FROM            Tbl_Course_Batch_Duration cbd          
                               WHERE        cbd.Batch_Id = NA.Batch_Id) END AS Batch_Code, (CASE WHEN SR.UserId IS NULL THEN '''' ELSE Isnull(E.Employee_FName, ''Admin'') END) AS UserName, NA.Course_Level_Id AS LevelID,           
                         CL.Course_Level_Name AS LevelName, NA.Course_Category_Id AS CategoryID, CCat.Course_Category_Name AS Category, NA.Department_Id AS DepartmentID,           
                         CASE WHEN NA.Department_Id = 0 THEN ''Unspecified'' ELSE          
                             (SELECT        D .Department_Name          
                               FROM            Tbl_Department D          
                               WHERE        D .Department_Id = NA.Department_Id) END AS Department_Name,     
         -- dbo.tbl_approval_log.Offerletter_status as offerletter,    
          DEL.Remarks as AdmissionRemark,DEL.Reject_remark AS CounsellorRemark          
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD     
                 --LEFT JOIN      dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id    
       LEFT OUTER JOIN          
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN          
              dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN          
       dbo.Tbl_Student_Status S on S.id=CPD.active LEFT OUTER JOIN          
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Employee AS E ON E.Employee_Id =          
                             (SELECT  Employee_Id          
                               FROM            dbo.Tbl_Employee_User          
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN          
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id left Outer Join          
       Dbo.Tbl_Delete_Request AS DEL on DEL.Candidate_id=CPD.Candidate_Id              
                     
              
            
where   (CPD.Campus= @organization_id or @organization_id=''0'')         
--and  tbl_approval_log.delete_status=0       
--and tbl_approval_log.Offerletter_status=1         
and (NA.Department_Id= @Department_id  or @Department_id=''0'')          
and (NA.Batch_Id= @intake_id or @intake_id=''0'')          
and (CounselorEmployee_id=@counselor_Id  or @counselor_Id=0)          
          
and (@Status=0 or CPD.active=@Status)          
AND (IDMatrixNo LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Gender LIKE  ''%''+@Searchkeyword+''%'' OR          
 CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE  ''%''+@Searchkeyword+''%'' OR          
 AdharNumber LIKE  ''%''+@Searchkeyword+''%'' OR          
TypeOfStudent LIKE  ''%''+@Searchkeyword+''%'' OR          
Status LIKE  ''%''+@Searchkeyword+''%''OR          
Candidate_Dob LIKE  ''%''+@Searchkeyword+''%'' OR          
ApplicationStatus LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_idNo  LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_Mob1 LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_Email LIKE  ''%''+@Searchkeyword+''%'' OR          
Batch_Code LIKE  ''%''+@Searchkeyword+''%'' OR          
                
 CCat.Course_Category_Name LIKE  ''%''+@Searchkeyword+''%'' OR          
 Department_Name LIKE  ''%''+@Searchkeyword+''%'' OR          
 --Offerletter_status LIKE  ''%''+@Searchkeyword+''%'' OR           
Reject_remark LIKE  ''%''+@Searchkeyword+''%'' OR @Searchkeyword='''')          
          
 order by ID desc             
 OFFSET @pagesize * (@CurrentPage - 1) ROWS          
      FETCH NEXT @pagesize ROWS ONLY          
          
end          
end          
if(@Flag=1)          
begin          
if(@application_status=''Verified'')          
begin          
          
          
          
SELECT DISTINCT count(CPD.Candidate_Id ) as counts FROM            dbo.Tbl_Candidate_Personal_Det AS CPD     
--LEFT JOIN   dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id     
    LEFT OUTER JOIN          
                         dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN          
             dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN          
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Employee AS E ON E.Employee_Id =          
                             (SELECT        Employee_Id          
                               FROM            dbo.Tbl_Employee_User          
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN          
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id left Outer Join          
       Dbo.Tbl_Delete_Request AS DEL on DEL.Candidate_id=CPD.Candidate_Id              
                     
              
                                                          
where  (CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' or CPD.Active_Status=''Inactive'' )          
--and  tbl_approval_log.delete_status=0       
--and tbl_approval_log.Offerletter_status=1         
and (@Status=0 or CPD.active=@Status)          
and (CPD.Campus= @organization_id or @organization_id=''0'')          
and (NA.Department_Id= @Department_id  or @Department_id=''0'')          
and (NA.Batch_Id= @intake_id or @intake_id=''0'')          
and (CounselorEmployee_id=@counselor_Id or @counselor_Id=0)          
and (CPD.ApplicationStatus=''approved'' or CPD.ApplicationStatus=''Verified''            
or  CPD.ApplicationStatus=''Conditional_Admission'' or  CPD.ApplicationStatus=''Preactivated'') and CPD.Candidate_DelStatus=0          
and CPD.ApplicationStatus is not null          
AND (IDMatrixNo LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Gender LIKE ''%''+@Searchkeyword+''%'' OR          
 CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%''+@Searchkeyword+''%'' OR          
 AdharNumber LIKE ''%''+@Searchkeyword+''%'' OR          
TypeOfStudent LIKE ''%''+@Searchkeyword+''%'' OR          
Status LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Dob LIKE ''%''+@Searchkeyword+''%'' OR          
ApplicationStatus LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_idNo  LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Mob1 LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Email LIKE ''%''+@Searchkeyword+''%'' OR          
Batch_Code LIKE ''%''+@Searchkeyword+''%'' OR          
                
 CCat.Course_Category_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')OR          
 Department_Name LIKE CONCAT(''%'',@Searchkeyword,''%'')OR          
--Offerletter_status LIKE CONCAT(''%'',@Searchkeyword,''%'')OR          
Reject_remark LIKE CONCAT(''%'',@Searchkeyword,''%'') OR @Searchkeyword='''')          
          
   end          
else          
if(@application_status=''Rejected'')          
begin          
                              
          
          
          
          
      SELECT DISTINCT count(CPD.Candidate_Id ) as counts           
FROM            dbo.Tbl_Candidate_Personal_Det AS CPD     
 --LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id     
 LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN          
                dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN          
               dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN          
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Employee AS E ON E.Employee_Id =          
                             (SELECT        Employee_Id          
                               FROM            dbo.Tbl_Employee_User          
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN          
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id                
                     
                          
                                                          
where --(CPD.Active_Status=''Active''or CPD.Active_Status=''ACTIVE'' ) and          
 (CPD.ApplicationStatus=@application_status or @application_status is null)           
-- and  tbl_approval_log.delete_status=0 and tbl_approval_log.Offerletter_status=1         
and (CPD.Campus= @organization_id or @organization_id=''0'')          
and (NA.Department_Id= @Department_id  or @Department_id=''0'')          
and (NA.Batch_Id= @intake_id or @intake_id=''0'')          
and (CounselorEmployee_id=@counselor_Id or @counselor_Id=0)          
          
and (@Status=0 or CPD.active=@Status)          
AND (IDMatrixNo LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Gender LIKE ''%''+@Searchkeyword+''%'' OR          
 CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%''+@Searchkeyword+''%'' OR          
 AdharNumber LIKE ''%''+@Searchkeyword+''%'' OR          
TypeOfStudent LIKE ''%''+@Searchkeyword+''%'' OR          
Status LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Dob LIKE ''%''+@Searchkeyword+''%'' OR          
ApplicationStatus LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_idNo  LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Mob1 LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Email LIKE ''%''+@Searchkeyword+''%'' OR          
Batch_Code LIKE ''%''+@Searchkeyword+''%'' OR          
                
 CCat.Course_Category_Name LIKE ''%''+@Searchkeyword+''%'' OR          
 Department_Name LIKE ''%''+@Searchkeyword+''%''     
 --OR Offerletter_status LIKE ''%''+@Searchkeyword+''%''     
 OR @Searchkeyword=''''    
 )          
end          
          
else          
begin          
          
          
          
SELECT DISTINCT count(CPD.Candidate_Id ) as counts FROM            dbo.Tbl_Candidate_Personal_Det AS CPD     
--LEFT JOIN dbo.tbl_approval_log ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id    
LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC ON CPD.Candidate_Id = CC.Candidate_Id LEFT OUTER JOIN          
             dbo.Tbl_Student_Semester AS SS ON SS.Candidate_Id = CPD.Candidate_Id AND SS.Student_Semester_Delete_Status = 0 AND SS.Student_Semester_Current_Status = 1 LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_Mapping AS cdm ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Duration_PeriodDetails AS cdp ON cdm.Duration_Period_Id = cdp.Duration_Period_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Batch_Duration AS cbd ON cbd.Batch_Id = cdp.Batch_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cdp.Semester_Id LEFT OUTER JOIN          
                         dbo.tbl_New_Admission AS NA ON NA.New_Admission_Id = CPD.New_Admission_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Level AS CL ON CL.Course_Level_Id = NA.Course_Level_Id LEFT OUTER JOIN          
                         dbo.Tbl_Course_Category AS CCat ON CCat.Course_Category_Id = NA.Course_Category_Id LEFT OUTER JOIN          
                         dbo.Tbl_Department AS D ON NA.Department_Id = D.Department_Id LEFT OUTER JOIN          
       dbo.Tbl_Student_Status S on S.id=CPD.active LEFT OUTER JOIN          
                         dbo.Tbl_Student_Registration AS SR ON CPD.Candidate_Id = SR.Candidate_Id LEFT OUTER JOIN          
                         dbo.Tbl_Employee AS E ON E.Employee_Id =          
                             (SELECT        Employee_Id          
                               FROM            dbo.Tbl_Employee_User          
                               WHERE        (User_Id = SR.UserId)) LEFT OUTER JOIN          
                         dbo.Tbl_Student_Health_General AS SG ON SG.StudentId = CPD.Candidate_Id left Outer Join          
       Dbo.Tbl_Delete_Request AS DEL on DEL.Candidate_id=CPD.Candidate_Id              
                     
              
                                                          
where   (CPD.Campus= @organization_id or @organization_id=''0'')          
--and  tbl_approval_log.delete_status=0 and tbl_approval_log.Offerletter_status=1         
and (NA.Department_Id= @Department_id  or @Department_id=''0'')          
and (NA.Batch_Id= @intake_id or @intake_id=''0'')          
and (CounselorEmployee_id=@counselor_Id  or @counselor_Id=0)          
          
and (@Status=0 or CPD.active=@Status)          
AND (IDMatrixNo LIKE ''%''+@Searchkeyword+''%'' OR          
Candidate_Gender LIKE  ''%''+@Searchkeyword+''%'' OR          
 CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE  ''%''+@Searchkeyword+''%'' OR          
 AdharNumber LIKE  ''%''+@Searchkeyword+''%'' OR          
TypeOfStudent LIKE  ''%''+@Searchkeyword+''%'' OR          
Status LIKE  ''%''+@Searchkeyword+''%''OR          
Candidate_Dob LIKE  ''%''+@Searchkeyword+''%'' OR          
ApplicationStatus LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_idNo  LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_Mob1 LIKE  ''%''+@Searchkeyword+''%'' OR          
Candidate_Email LIKE  ''%''+@Searchkeyword+''%'' OR          
Batch_Code LIKE  ''%''+@Searchkeyword+''%'' OR          
                
 CCat.Course_Category_Name LIKE  ''%''+@Searchkeyword+''%'' OR          
 Department_Name LIKE  ''%''+@Searchkeyword+''%'' OR          
 --Offerletter_status LIKE  ''%''+@Searchkeyword+''%'' OR           
Reject_remark LIKE  ''%''+@Searchkeyword+''%'' OR @Searchkeyword='''')          
          
          
          
   end          
end          
          
end 
    ')
END
