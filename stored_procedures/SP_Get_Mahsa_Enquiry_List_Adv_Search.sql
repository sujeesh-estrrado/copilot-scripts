IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Mahsa_Enquiry_List_Adv_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     
CREATE PROCEDURE [dbo].[SP_Get_Mahsa_Enquiry_List_Adv_Search] --1,100,'''',''--Select--'',''--Select--'',''--Select--'','''','''',''1'',''--Select--'',''--Select--'',''--Select--'',''--Select--'','''',''19''
( @CurrentPage    INT=NULL ,
@PageSize         INT=NULL ,
@SearchTerm       VARCHAR(100)='''',
@CounselorCampus1 VARCHAR(50)='''' ,
@EmployeeName     VARCHAR(50)='''',
@Type1            VARCHAR(50)='''',
@from             VARCHAR(50)='''',
@to               VARCHAR(50)='''',
@ActiveStatus     VARCHAR(50)='''',
@Hostel_Req       VARCHAR(50)='''',
@Scholarship      VARCHAR(50)='''',
@Program          VARCHAR(50)='''',
@feespaid         VARCHAR(50)='''',
@createdby        VARCHAR(100)='''',
@Marketing_Status VARCHAR(100)='''',
@CouncellorEmpId  BIGINT = 0,
@flag             INT=0 ,
@employeeId    int=0,
@FacultyId NVARCHAR(MAX), 
@ProgrammeId NVARCHAR(MAX), 
@IntakeId NVARCHAR(MAX) 
)                                                                             
AS                                                                            
BEGIN                                       
SET NOCOUNT ON 
DECLARE @FacultyTable TABLE (FacultyId INT);
DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
DECLARE @IntakeTable TABLE (IntakeId INT);
 
IF @FacultyId <> ''0'' AND @FacultyId <> ''''
BEGIN
    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');
END
ELSE
BEGIN
    INSERT INTO @FacultyTable (FacultyId)
    SELECT DISTINCT Course_Level_Id FROM Tbl_Course_Level;
END
 
IF @ProgrammeId <> ''0'' AND @ProgrammeId <> ''''
BEGIN
    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');
END
ELSE
BEGIN 
    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT DISTINCT Department_Id FROM Tbl_Department;  
END
 
IF @IntakeId <> ''0'' AND @IntakeId <> ''''
BEGIN
    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');
END
ELSE
BEGIN

    INSERT INTO @IntakeTable (IntakeId)
    SELECT DISTINCT Duration_Period_Id FROM Tbl_Course_Duration_PeriodDetails; 
    END                
               
    DECLARE @Unspecified  nvarchar(max) set  @Unspecified=''Unspecified''
    DECLARE @Admin  nvarchar(max) set  @Admin=''Admin''
    DECLARE @SqlString nvarchar(max)                                                      
    Declare @SqlStringWithout nvarchar(max)
    Declare @UpperBand int                                                          
    Declare @LowerBand int                    
                                                       
    SET @LowerBand  = (@CurrentPage -                                      
     1) * @PageSize                                                          
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                         
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP1;                            
  IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP2;
  if @flag=0
  begin
  print ''flag 0''
  if(@from=@to)                              
  begin     
  print ''@from=@to''
 select * from (     
(SELECT distinct   CPD.Candidate_Id as ID,
--SG.BloodGroup,                                      
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,   
--(convert(date,RegDate,105)) as RegDate,            
 --FORMAT (CPD.RegDate, ''dd/MM/yyyy hh:mm:ss tt'') as RegDatetime, 
 CONVERT(varchar(10), RegDate, 105) as RegDate,

CPD.CounselorEmployee_id,                                                                     
CPD.CounselorCampus,                                      
CPD.TypeOfStudent,CPD.Active,                                                                        
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,   
CPD.Candidate_Fname,
CPD.AdharNumber,                                                                                 
CPD.Candidate_Dob as DOB,                                                                         
CPD.New_Admission_Id as AdmnID,                          
CPD.ApplicationStage as Stage,                         
CPD.ApplicationStatus as ApplicationStatus,                                                      
CC.Candidate_idNo as IdentificationNumber ,                                      
CC.Candidate_ContAddress as Address,                                                        
CC.Candidate_Mob1 as MobileNumber,                                                
CC.Candidate_Email as EmailID ,                         
CCat.Course_Category_Id,                    
CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda,                    
cbd.Batch_Id as BatchID,                                          
case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus,               
cbd.Batch_Code as Batch,                    
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,
NA.Batch_Id,                                                                                        
case when  NA.Batch_Id=0 then ''Unspecified'' 
    else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where        
            cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                                           
            (Case when SR.UserId IS NULL  Then '' ''
            Else Isnull(E. Employee_FName,''Admin'') END) as UserName,       
 NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],  
 NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],
 NA.Department_Id as DepartmentID,                                                                
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where
D.Department_Id=NA.Department_Id)  end  as Department ,            
CPD.Scolorship_Remark
,CASE (CPD.SourceofInformation)
    WHEN ''--Select--'' THEN ''''
    WHEN ''0'' THEN ''''
    ELSE CPD.SourceofInformation
    END AS SourceofInformation
FROM Tbl_Candidate_Personal_Det  CPD                          
left join Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id       
left join dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1   
left JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id    
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id    
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id               
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id 
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id              
left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id   
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
left join Tbl_Student_status RR on RR.id=CPD.Active                    
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id     
left join Tbl_Department D on NA.Department_Id=D.Department_Id                        
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                    
left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                               
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)   
 --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id          
left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0  
left Join (select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail 
            where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
            (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id
WHERE (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' 
 or LTRIM(RTRIM(@SearchTerm))='''') 
 
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
 and (CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'') 
  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

 and (trim(concat(EC.Employee_FName,'' '',EC.Employee_LName))=@EmployeeName or @EmployeeName=''--Select--'')                          
 and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))       
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
 and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''--Select--'')
 -- and(@createdby=''--Select--'' or EnrollBy=@createdby)                       
 and ((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'') or (@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))
                    
--Union all                    
                    
-- (SELECT distinct   CPD.Candidate_Id as ID,
-- --SG.BloodGroup,                                      
-- CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,     
-- --(convert(date,CPD.RegDate,105)) as RegDate,     
-- --FORMAT (CPD.RegDate, ''dd/MM/yyyy hh:mm:ss tt'') as RegDatetime, 
--  CONVERT(varchar(10), CPD.RegDate, 105) as RegDate,


-- CPD.CounselorEmployee_id,  
-- CPD.CounselorCampus,                                      
-- PD.TypeOfStudent,CPD.Active,         
-- CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName,                
-- PD.Candidate_Fname,PD.AdharNumber,                                                                                    
-- PD.Candidate_Dob as DOB,                                  
-- CPD.New_Admission_Id as AdmnID,                          
-- CPD.ApplicationStage as Stage,                         
-- CPD.ApplicationStatus as ApplicationStatus,                                                      
-- CC.Candidate_idNo as IdentificationNumber ,                        
-- CC.Candidate_ContAddress as Address,                                                                            
-- CC.Candidate_Mob1 as MobileNumber,                                                                          
-- CC.Candidate_Email as EmailID ,                                                                  
-- CCat.Course_Category_Id,                    
-- PD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
-- cbd.Batch_Id as BatchID,                          
--   case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
-- cbd.Batch_Code as Batch,                
----ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
--FD.Next_Date   as nextDate, 
--FD.Respond_Type,                                                                                                            
--NA.Batch_Id,                                            
                                                        
-- case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
-- cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                  
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                               
                        
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
-- case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
-- D.Department_Id=NA.Department_Id)  end  as Department ,            
-- CPD.Scolorship_Remark,
-- ''Enquiry'' as SourceofInformation                                   
-- FROM Tbl_Student_NewApplication CPD                    
                    
--Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                                   
                                                           
-- left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
-- left join                                                
-- dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
-- and   ss.student_semester_current_status=1                                                  
-- left JOIN                                        
-- Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                       
-- left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id          
-- left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
-- left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                       
-- left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                                        
                                                  
-- left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                 
                                                                      
-- left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
-- left join Tbl_Student_status RR on RR.id=CPD.Active                    
                    
                                                      
                                                                       
-- left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
-- left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                  
-- LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
-- LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
-- --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
-- left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
-- left Join (                    
-- select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
-- (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
-- where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
-- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
-- or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
-- or (PD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
-- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
--  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
--        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
--      AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

-- and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
-- and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
-- and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
-- and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
-- and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
-- and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
---- and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))            
-- and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
-- -- and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)       
--  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''--Select--'')
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
-- or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
-- (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')or (@ActiveStatus=''9'' and (CPD.ApplicationStatus=''Lead'' ))) )                   
                    
--     --Lead integration with enquiry                
-- Union all                    
                    
--  ((SELECT distinct   CPD.Candidate_Id as ID,
--  --SG.BloodGroup,                            
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--(convert(date,RegDate,105)) as RegDate,                     
-- FORMAT (CPD.RegDate, ''dd/MM/yyyy hh:mm:ss tt'') as RegDatetime,
-- CPD.CounselorEmployee_id,                                  
--CPD.CounselorCampus,                                      
--CPD.TypeOfStudent,CPD.Active,                                                                        
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                  
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
--CPD.Candidate_Dob as DOB,                                                                         
--CPD.New_Admission_Id as AdmnID,                          
--CPD.ApplicationStage as Stage,                         
--CPD.ApplicationStatus as ApplicationStatus,                                                      
--CC.Candidate_idNo as IdentificationNumber ,                                    
                                                                        
--CC.Candidate_ContAddress as Address,                                                                            
--CC.Candidate_Mob1 as MobileNumber,                                                                          
--CC.Candidate_Email as EmailID ,                                                                  
--CCat.Course_Category_Id,                    
--CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--cbd.Batch_Code as Batch,                    
----ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
--FD.Next_Date   as nextDate, 
--FD.Respond_Type,                                                                                                            
--NA.Batch_Id,                                             
                                                                
--case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
-- (Case when SR.UserId IS NULL  Then '' ''                                          
-- Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
-- NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
-- NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                                                   
             
-- NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--D.Department_Id=NA.Department_Id)  end  as Department,            
--CPD.Scolorship_Remark   
--,CASE (CPD.SourceofInformation)
--  WHEN ''--Select--'' THEN ''''
--  WHEN ''0'' THEN ''''
--  ELSE CPD.SourceofInformation
--  END AS SourceofInformation                                              
-- FROM Tbl_Lead_Personal_Det CPD    
-- left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
-- left join                                                
-- dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
-- and   ss.student_semester_current_status=1                                                  
-- left JOIN                                                   
-- Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                 
-- left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
-- left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
-- left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                    
-- left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
-- left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                                      
-- left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                   
                                                                       
-- left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
-- left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
-- LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
-- LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
-- left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
-- left Join (                    
-- select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
-- (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id   
-- where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                 
-- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
-- or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
-- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')             
-- and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
-- and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
-- -- and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                          
-- and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
-- and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
-- and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
-- --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))             
-- and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')  
--  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
--        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
--      AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

-- and                    
-- (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
-- OR (@from IS NULL AND @to IS NULL)                    
-- OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
-- OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
-- or @from='''' or @to='''')                         
                      
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' ))            
-- or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
-- (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'') or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))                    
--  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''--Select--'')))
)  
  as Tres  
                      
 ORDER BY   
 Tres.ID DESC , Tres.RegDate desc            
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
end                           
else                          
begin                          
 select * from   
(                                                                 
 (SELECT distinct  top 100  CPD.Candidate_Id as ID,
 --SG.BloodGroup,                                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,    
 (convert(date,RegDate,103)) as RegDate,                       
 FORMAT (CPD.RegDate, ''dd/MM/yyyy hh:mm:ss tt'') as RegDatetime, 
 CPD.CounselorEmployee_id,                                    
 CPD.CounselorCampus,                                      
 CPD.TypeOfStudent,                       
 CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                    
 CPD.Candidate_Fname,CPD.AdharNumber,        
 CPD.Candidate_Dob as DOB,               
 CPD.New_Admission_Id as AdmnID,                       
 CPD.ApplicationStage as Stage,  
 CPD.ApplicationStatus as ApplicationStatus,   
 CC.Candidate_idNo as IdentificationNumber ,                                 
 CC.Candidate_ContAddress as Address,         
 CC.Candidate_Mob1 as MobileNumber,           
 CC.Candidate_Email as EmailID ,                            
 CCat.Course_Category_Id,                    
 CPD.Hostel_Required as Hostel_Required,   
 cbd.Batch_Id as BatchID,               
 case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,  
 cbd.Batch_Code as Batch,                     
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,                  
NA.Batch_Id,                                            
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                                          
                                        
                                                                        
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                   
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                       
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                       
                           
  NA.Department_Id as DepartmentID,                                                      
                                      
                                            
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
 D.Department_Id=NA.Department_Id)  end  as Department,                                           
 CPD.Scolorship_Remark   
,CASE (CPD.SourceofInformation)
    WHEN ''--Select--'' THEN ''''
    WHEN ''0'' THEN ''''
    ELSE CPD.SourceofInformation
    END AS SourceofInformation             
                        
 FROM Tbl_Candidate_Personal_Det  CPD                                                
                             
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
 left join                                                
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
 and   ss.student_semester_current_status=1                                                  
 left JOIN                                                       
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                       
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                     
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                           
 left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                                      
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
   -- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
 left Join (                    
 select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
--  and(@createdby=''--Select--'' or EnrollBy=@createdby)                          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'') 
  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

 and                    
 (((CONVERT(date,RegDate)) >= @from and (CONVERT(date,RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
                      
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'') or (@ActiveStatus=''9'' and (CPD.ApplicationStatus=''Lead'' )))                    
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''--Select--'') )                         
                    
                    
 Union all                    
                    
  (SELECT distinct top 100  CPD.Candidate_Id as ID,
  --SG.BloodGroup,                                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,     
(convert(date,CPD.RegDate,103)) as RegDate,                       
 FORMAT (CPD.RegDate, ''dd/MM/yyyy hh:mm:ss tt'') as RegDatetime, 
 CPD.CounselorEmployee_id,                                                                   
 CPD.CounselorCampus,                                      
 PD.TypeOfStudent,                       
 CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName,                                                                    
 PD.Candidate_Fname,PD.AdharNumber,    
 PD.Candidate_Dob as DOB,                                      
 CPD.New_Admission_Id as AdmnID,                       
 CPD.ApplicationStage as Stage,  
 CPD.ApplicationStatus as ApplicationStatus,   
 CC.Candidate_idNo as IdentificationNumber ,                     
 CC.Candidate_ContAddress as Address,          
 CC.Candidate_Mob1 as MobileNumber,            
 CC.Candidate_Email as EmailID ,                            
 CCat.Course_Category_Id,                    
 PD.Hostel_Required as Hostel_Required,                    
                       
 cbd.Batch_Id as BatchID,                                                               
    case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                           
 cbd.Batch_Code as Batch,                     
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,                                                                                                            
NA.Batch_Id,                                           
                                                                
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                          
                                        
                                                                        
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                       
                           
  NA.Department_Id as DepartmentID,                      
                                      
                                   
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                
 D.Department_Id=NA.Department_Id)  end  as Department,
 CPD.Scolorship_Remark,
 PD.SourceofInformation
                                  
                                                           
 FROM Tbl_Student_NewApplication CPD                    
                    
Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                                      
                             
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
 left join                                                
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
 and   ss.student_semester_current_status=1                                                  
 left JOIN                                                   
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                            
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
 left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                                      
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                          
                                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
   -- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
     left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
 left Join (                    
 select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
 where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
 or (pd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')   
  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

  --and(@createdby=''--Select--'' or PD.EnrollBy=@createdby)                          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
 and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                    
 and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
                      
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data''))                    
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''--Select--'') )                       
                 
                
                
 --Lead integration with enquiry                
 Union all                    
                    
  (SELECT distinct top 100  CPD.Candidate_Id as ID,
  --SG.BloodGroup,                                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
 (convert(date,CPD.RegDate,103)) as RegDate,                       
 FORMAT (CPD.RegDate, ''dd/MM/yyyy hh:mm:ss tt'') as RegDatetime, 
 CPD.CounselorEmployee_id,                                                                    
 CPD.CounselorCampus,                                      
 CPD.TypeOfStudent,                       
 CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                    
 CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
 CPD.Candidate_Dob as DOB,                                                                         
 CPD.New_Admission_Id as AdmnID,                       
 CPD.ApplicationStage as Stage,        
 CPD.ApplicationStatus as ApplicationStatus,   
 CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                                        
 CC.Candidate_ContAddress as Address,                                                                            
 CC.Candidate_Mob1 as MobileNumber,                                                                          
 CC.Candidate_Email as EmailID ,                            
 CCat.Course_Category_Id,                    
 CPD.Hostel_Required as Hostel_Required,                    
                       
 cbd.Batch_Id as BatchID,                                                               
    case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                         
 cbd.Batch_Code as Batch,                     
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,                                                                                                            
NA.Batch_Id,                                            
                                                                
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                                          
                                        
                                                                        
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                          
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                       
                           
  NA.Department_Id as DepartmentID,                      
                                      
                                            
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
 D.Department_Id=NA.Department_Id)  end  as Department,
 CPD.Scolorship_Remark,
CASE (CPD.SourceofInformation)
    WHEN ''--Select--'' THEN ''''
    WHEN ''0'' THEN ''''
    ELSE CPD.SourceofInformation
    END AS SourceofInformation                               
                                                           
 FROM Tbl_Lead_Personal_Det CPD                    
                    
                                                                   
                             
 inner join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id  and        CPD.ApplicationStatus!=''Pending''                                         
 left join                                                
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                             
 and   ss.student_semester_current_status=1                                                  
 left JOIN                               
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                 
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
 left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                       
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
   -- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
     left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
 left Join (                    
 select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
 or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'') 
  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

 -- and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))          
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                   
 and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
                 
 and(                    
@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' )                   
 --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')   )                
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''--Select--'') )                    
            ) as TRes  
                    
                    
                    
 ORDER BY CASE WHEN TRes.CounselorEmployee_id = @CouncellorEmpId THEN 0 ELSE 1 END,  
 TRes.RegDate desc ,TRes.CounselorEmployee_id                                    
        OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
end                                          
     end
     if @flag=1
     begin
     select * from   
(                                                                 
 (SELECT distinct  top 100  CPD.Candidate_Id as ID,
 --SG.BloodGroup,                                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
 (convert(date,RegDate,103)) as RegDate,                       
 RegDate as RegDatetime, CPD.CounselorEmployee_id,                                    
 CPD.CounselorCampus,                                      
 CPD.TypeOfStudent,                       
 CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                    
 CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
 CPD.Candidate_Dob as DOB,                                                                         
 CPD.New_Admission_Id as AdmnID,                       
 CPD.ApplicationStage as Stage,                                                       
 CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                                        
 CC.Candidate_ContAddress as Address,                                                                            
 CC.Candidate_Mob1 as MobileNumber,                                                                          
 CC.Candidate_Email as EmailID ,                            
 CCat.Course_Category_Id,                    
 CPD.Hostel_Required as Hostel_Required,                    
                       
 cbd.Batch_Id as BatchID,                                                               
    case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                           
 cbd.Batch_Code as Batch,                     
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,                                                                                                            
NA.Batch_Id,                                        
                                                       
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                                          
                                        
                                                                        
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                   
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                       
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                       
                           
  NA.Department_Id as DepartmentID,                                                      
                                      
                                            
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
 D.Department_Id=NA.Department_Id)  end  as Department                                           
                                          
                        
 FROM Tbl_Candidate_Personal_Det  CPD                                                
                             
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
 left join                                                
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
 and   ss.student_semester_current_status=1                                                  
 left JOIN                                                       
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                       
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                     
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                           
 left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                                      
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
   -- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
 left Join (                    
 select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')      
  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')


--  and(@createdby=''--Select--'' or EnrollBy=@createdby)                          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')      
 and  (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate()))
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                    
 and                    
 (((CONVERT(date,RegDate)) >= @from and (CONVERT(date,RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
                      
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'') or (@ActiveStatus=''9'' and (CPD.ApplicationStatus=''Lead'' )))                    
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'') )                         
                    
                    
 Union all                    
                    
  (SELECT distinct top 100  CPD.Candidate_Id as ID,
  --SG.BloodGroup,                                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
(convert(date,CPD.RegDate,103)) as RegDate,                       
 CPD.RegDate as RegDatetime,  CPD.CounselorEmployee_id,                                                                   
 CPD.CounselorCampus,                                      
 PD.TypeOfStudent,                       
 CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName,                                                                    
 PD.Candidate_Fname,PD.AdharNumber,                                                                                    
 PD.Candidate_Dob as DOB,                                      
 CPD.New_Admission_Id as AdmnID,                       
 CPD.ApplicationStage as Stage,                                                       
 CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                            
 CC.Candidate_ContAddress as Address,                                                                            
 CC.Candidate_Mob1 as MobileNumber,                                                                          
 CC.Candidate_Email as EmailID ,                            
 CCat.Course_Category_Id,                    
 PD.Hostel_Required as Hostel_Required,                    
                       
 cbd.Batch_Id as BatchID,                                                               
    case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                           
 cbd.Batch_Code as Batch,                     
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,                                                                                                            
NA.Batch_Id,                                           
                                                                
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                          
                                        
                                                                        
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                       
                           
  NA.Department_Id as DepartmentID,                      
                                      
                                   
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                
 D.Department_Id=NA.Department_Id)  end  as Department                                           
                                  
                                                           
 FROM Tbl_Student_NewApplication CPD                    
                    
Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                                      
                             
 left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
 left join                                                
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
 and   ss.student_semester_current_status=1                                                  
 left JOIN                                                   
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                            
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
 left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                                      
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                          
                                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
   -- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
     left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
 left Join (                    
 select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
 where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
 or (pd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')  
   AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')


 and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
  --and(@createdby=''--Select--'' or PD.EnrollBy=@createdby)                          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
 and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                    
 and   
 (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate())) and
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
                      
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data''))                    
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'') )                       
                 
                
                
 --Lead integration with enquiry                
 Union all                    
                    
  (SELECT distinct top 100  CPD.Candidate_Id as ID,
  --SG.BloodGroup,                                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
 (convert(date,CPD.RegDate,103)) as RegDate,                       
 CPD.RegDate as RegDatetime, CPD.CounselorEmployee_id,                                                                    
 CPD.CounselorCampus,                                      
 CPD.TypeOfStudent,                       
 CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                    
 CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
 CPD.Candidate_Dob as DOB,                                                                         
 CPD.New_Admission_Id as AdmnID,                       
 CPD.ApplicationStage as Stage,                                                       
 CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                                        
 CC.Candidate_ContAddress as Address,                                                                            
 CC.Candidate_Mob1 as MobileNumber,                                                                          
 CC.Candidate_Email as EmailID ,                            
 CCat.Course_Category_Id,                    
 CPD.Hostel_Required as Hostel_Required,                    
                       
 cbd.Batch_Id as BatchID,                                                               
    case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                         
 cbd.Batch_Code as Batch,                     
--ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
FD.Next_Date   as nextDate, 
FD.Respond_Type,                                                                                                            
NA.Batch_Id,                                            
                                                                
 case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                          
 cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                                          
                                        
                                                                        
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                          
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                       
                           
  NA.Department_Id as DepartmentID,                      
                                      
                                            
 case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
 D.Department_Id=NA.Department_Id)  end  as Department                                           
                                  
                                                           
 FROM Tbl_Lead_Personal_Det CPD                    
                    
                                                                   
                             
 inner join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id  and        CPD.ApplicationStatus!=''Pending''                                         
 left join                                                
 dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                             
 and   ss.student_semester_current_status=1                                                  
 left JOIN                               
 Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                 
 left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
 left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
 left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
 left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                                       
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
   -- left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
     left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                    
 left Join (                    
 select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
 or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
 -- and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
 --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))          
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')  
    AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')

 and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
                 
 and(                    
@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' )                   
 --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')   )                
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'') )                    
            ) as TRes  
                    
                    
                    
 ORDER BY CASE WHEN TRes.CounselorEmployee_id = @CouncellorEmpId THEN 0 ELSE 1 END,  
 TRes.RegDatetime desc ,TRes.CounselorEmployee_id                   
                                
                                                                                
        OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
     end

    IF @flag = 200
BEGIN
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,                                     
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                       
        CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate,  
        RegDate AS RDate,                                        
        CPD.TypeOfStudent,                                                          
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
        CPD.AdharNumber, 
        CPD.ApplicationStage AS Stage, 
        CPD.ApplicationStatus AS ApplicationStatus,
        CC.Candidate_Mob1 AS MobileNumber, 
        CC.Candidate_Email AS EmailID,                                                       
        CASE 
            WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
            ELSE ''Not Paid'' 
        END AS FeeStatus, 
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        FD.Respond_Type, 
        cbd.Batch_Code, 
        D.Department_Name AS Department,
        CPD.Scolorship_Remark,  
        REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
        '''' AS ReadStatus,
        '''' AS RevertStatus,
        '''' AS MMUOldStudent,
        '''' AS DocUploaded,
        NA.Department_Id AS DepartmentID
    FROM Tbl_Candidate_Personal_Det CPD                                                                                                                                     
    LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                   
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                        
    LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id 
    LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                                                  
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id                   
    LEFT JOIN Tbl_FollowUp_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
    WHERE CPD.counseloremployee_id = @employeeId
    AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE)
    AND (CPD.applicationstatus = ''pending'' OR CPD.applicationstatus = ''submitted'')
    AND (
        LOWER(LTRIM(RTRIM(CPD.Candidate_Fname))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CPD.AdharNumber))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CC.Candidate_Mob1))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CC.Candidate_Email))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(D.Department_Name))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%''
    ) and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
    
 and(                    
@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' )                   
 --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')   )                
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'')
    ORDER BY CPD.Candidate_Id
    OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
     if @flag=201
     begin
    SELECT DISTINCT 
    CPD.Candidate_Id as ID,                                     
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                       
    (CONVERT(NVARCHAR(10), RegDate, 105)) as RegDate,  
    RegDate AS RDate,                                        
    CPD.TypeOfStudent,                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
    CPD.AdharNumber, 
    CPD.ApplicationStage AS Stage, 
    CPD.ApplicationStatus AS ApplicationStatus,
    CC.Candidate_Mob1 AS MobileNumber, 
    CC.Candidate_Email AS EmailID,                                                       
    CASE 
        WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
        ELSE ''Not Paid'' 
    END AS FeeStatus, 
    (CONVERT(NVARCHAR(10), FD.Next_Date, 105)) AS nextDate,
    FD.Respond_Type, 
    cbd.Batch_Code, 
    D.Department_Name AS Department,
    CPD.Scolorship_Remark,  
    REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
    '''' AS ReadStatus,
    '''' AS RevertStatus,
    '''' AS MMUOldStudent,
    '''' AS DocUploaded,
    NA.Department_Id AS DepartmentID
FROM Tbl_Candidate_Personal_Det CPD                                                                                                                                     
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                   
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                        
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id 
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                                                  
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id                   
LEFT JOIN Tbl_FollowUp_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
WHERE CPD.counseloremployee_id= @employeeId
    AND (CPD.ApplicationStatus = ''Pending'' OR CPD.ApplicationStatus = ''pending'' OR CPD.ApplicationStatus = ''submited'')
 AND  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
 or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')    
 and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                         
   
 and(                    
@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' )                   
 --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')   )                
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'')
ORDER BY CPD.Candidate_Id
                         
        OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
    end
  
   if @flag=202
     begin
    SELECT DISTINCT 
    CPD.Candidate_Id as ID,                                     
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                       
    (CONVERT(NVARCHAR(10), RegDate, 105)) as RegDate,  
    RegDate AS RDate,                                        
    CPD.TypeOfStudent,                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
    CPD.AdharNumber, 
    CPD.ApplicationStage AS Stage, 
    CPD.ApplicationStatus AS ApplicationStatus,
    CC.Candidate_Mob1 AS MobileNumber, 
    CC.Candidate_Email AS EmailID,                                                       
    CASE 
        WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
        ELSE ''Not Paid'' 
    END AS FeeStatus, 
    (CONVERT(NVARCHAR(10), FD.Next_Date, 105)) AS nextDate,
    FD.Respond_Type, 
    cbd.Batch_Code, 
    D.Department_Name AS Department,
    CPD.Scolorship_Remark,  
    REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
    '''' AS ReadStatus,
    '''' AS RevertStatus,
    '''' AS MMUOldStudent,
    '''' AS DocUploaded,
    NA.Department_Id AS DepartmentID
FROM Tbl_Candidate_Personal_Det CPD                                                                                                                                     
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                   
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id     
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                     
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id 
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                                                  
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id                   
LEFT JOIN Tbl_FollowUp_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
WHERE CPD.counseloremployee_id = @employeeId
AND (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate()))
    AND (CPD.ApplicationStatus=''pending''
    or CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''submited'')
    AND (
        CPD.Candidate_Fname LIKE ''%'' + @SearchTerm + ''%'' OR
        CPD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%'' OR
        CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%'' OR
        CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%'' OR
        CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%'' OR
        D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
    )
     
ORDER BY CPD.Candidate_Id
OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
FETCH NEXT @PageSize ROWS ONLY;

    end

      IF(@flag=325)
     BEGIN             
  SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate,  
        RegDate AS RDate,  
        CPD.TypeOfStudent,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
        CPD.AdharNumber, 
        CPD.ApplicationStage AS Stage, 
        CPD.ApplicationStatus AS ApplicationStatus,
        CC.Candidate_Mob1 AS MobileNumber, 
        CC.Candidate_Email AS EmailID,                                                       
        CASE 
            WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
            ELSE ''Not Paid'' 
        END AS FeeStatus,   
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        FD.Respond_Type, 
        cbd.Batch_Code, 
        D.Department_Name AS Department,
        CPD.Scolorship_Remark,  
        REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
        '''' AS ReadStatus,
        '''' AS RevertStatus,
        '''' AS MMUOldStudent,
        '''' AS DocUploaded,
        NA.Department_Id AS DepartmentID
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN Tbl_Candidate_ContactDetails CC 
        ON CPD.Candidate_Id = CC.Candidate_Id                                                   
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id 
    LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP 
        ON NA.Batch_Id = CDP.Batch_Id                                        
    LEFT JOIN Tbl_Course_Batch_Duration cbd 
        ON cbd.Batch_Id = NA.Batch_Id 
    LEFT JOIN Tbl_Department D 
        ON NA.Department_Id = D.Department_Id                                                                  
    LEFT JOIN Tbl_Employee EC 
        ON EC.Employee_Id = CPD.CounselorEmployee_id 
    LEFT JOIN Tbl_Status_change_by_Marketing M 
        ON M.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUp_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN ( 
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUp_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD 
    ON FD.Candidate_Id = CPD.Candidate_Id                                     
   WHERE  
            (CPD.ApplicationStatus IN (''Pending'', ''submited''))
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )

         AND
         (
        LOWER(LTRIM(RTRIM(CPD.Candidate_Fname))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CPD.AdharNumber))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CC.Candidate_Mob1))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CC.Candidate_Email))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(D.Department_Name))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%''
    ) 
         ORDER BY CPD.Candidate_Id
    OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
    FETCH NEXT @PageSize ROWS ONLY;
           END  

    IF @flag = 400
BEGIN
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,                                     
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                       
        CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate,  
        RegDate AS RDate,                                        
        CPD.TypeOfStudent,                                                          
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
        CPD.AdharNumber, 
        CPD.ApplicationStage AS Stage, 
        CPD.ApplicationStatus AS ApplicationStatus,
        CC.Candidate_Mob1 AS MobileNumber, 
        CC.Candidate_Email AS EmailID,                                                       
        CASE 
            WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
            ELSE ''Not Paid'' 
        END AS FeeStatus, 
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        FD.Respond_Type, 
        cbd.Batch_Code, 
        D.Department_Name AS Department,
        CPD.Scolorship_Remark,  
        REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
        '''' AS ReadStatus,
        '''' AS RevertStatus,
        '''' AS MMUOldStudent,
        '''' AS DocUploaded,
        NA.Department_Id AS DepartmentID
    FROM Tbl_Candidate_Personal_Det CPD                                                                                                                                     
    LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                   
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                        
    LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id 
    LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                                                  
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id                   
    LEFT JOIN Tbl_FollowUp_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
    WHERE CPD.counseloremployee_id = @employeeId
    AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE)
    AND (CPD.applicationstatus = ''pending'' OR CPD.applicationstatus = ''submitted'')
    AND (
        LOWER(LTRIM(RTRIM(CPD.Candidate_Fname))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CPD.AdharNumber))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CC.Candidate_Mob1))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(CC.Candidate_Email))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%'' OR
        LOWER(LTRIM(RTRIM(D.Department_Name))) LIKE ''%'' + LOWER(LTRIM(RTRIM(@SearchTerm))) + ''%''
    ) and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                          
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) and(                    
@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' )                   
 --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')   )                
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'')
    ORDER BY CPD.Candidate_Id
    OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END


if @flag=401
     begin
    SELECT DISTINCT 
    CPD.Candidate_Id as ID,                                     
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                       
    (CONVERT(NVARCHAR(10), RegDate, 105)) as RegDate,  
    RegDate AS RDate,                                        
    CPD.TypeOfStudent,                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
    CPD.AdharNumber, 
    CPD.ApplicationStage AS Stage, 
    CPD.ApplicationStatus AS ApplicationStatus,
    CC.Candidate_Mob1 AS MobileNumber, 
    CC.Candidate_Email AS EmailID,                                                       
    CASE 
        WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
        ELSE ''Not Paid'' 
    END AS FeeStatus, 
    (CONVERT(NVARCHAR(10), FD.Next_Date, 105)) AS nextDate,
    FD.Respond_Type, 
    cbd.Batch_Code, 
    D.Department_Name AS Department,
    CPD.Scolorship_Remark,  
    REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
    '''' AS ReadStatus,
    '''' AS RevertStatus,
    '''' AS MMUOldStudent,
    '''' AS DocUploaded,
    NA.Department_Id AS DepartmentID
FROM Tbl_Candidate_Personal_Det CPD                                                                                                                                     
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                   
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                        
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id 
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                                                  
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id                   
LEFT JOIN Tbl_FollowUp_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
WHERE CPD.counseloremployee_id= @employeeId
    AND (CPD.ApplicationStatus = ''Pending'' OR CPD.ApplicationStatus = ''pending'' OR CPD.ApplicationStatus = ''submited'')
 AND  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
 or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                         
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')    
 and                    
 (((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@from IS NULL AND @to IS NULL)                    
 OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
 OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
 or @from='''' or @to='''')                          
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) and(                    
@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' )                   
 --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
 or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')   )                
  and(FD.Respond_Type= @Marketing_Status or @Marketing_Status=''0'')
ORDER BY CPD.Candidate_Id
                         
        OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
    end
  
   if @flag=402
     begin
    SELECT DISTINCT 
    CPD.Candidate_Id as ID,                                     
    CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                       
    (CONVERT(NVARCHAR(10), RegDate, 105)) as RegDate,  
    RegDate AS RDate,                                        
    CPD.TypeOfStudent,                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
    CPD.AdharNumber, 
    CPD.ApplicationStage AS Stage, 
    CPD.ApplicationStatus AS ApplicationStatus,
    CC.Candidate_Mob1 AS MobileNumber, 
    CC.Candidate_Email AS EmailID,                                                       
    CASE 
        WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
        ELSE ''Not Paid'' 
    END AS FeeStatus, 
    (CONVERT(NVARCHAR(10), FD.Next_Date, 105)) AS nextDate,
    FD.Respond_Type, 
    cbd.Batch_Code, 
    D.Department_Name AS Department,
    CPD.Scolorship_Remark,  
    REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
    '''' AS ReadStatus,
    '''' AS RevertStatus,
    '''' AS MMUOldStudent,
    '''' AS DocUploaded,
    NA.Department_Id AS DepartmentID
FROM Tbl_Candidate_Personal_Det CPD                                                                                                                                     
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                   
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id     
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                     
LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id 
LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id                                                                  
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id                   
LEFT JOIN Tbl_FollowUp_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
WHERE CPD.counseloremployee_id = @employeeId
AND (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate()))
    AND (CPD.ApplicationStatus=''pending''
    or CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''submited'')
    AND (
        CPD.Candidate_Fname LIKE ''%'' + @SearchTerm + ''%'' OR
        CPD.Candidate_Lname LIKE ''%'' + @SearchTerm + ''%'' OR
        CPD.AdharNumber LIKE ''%'' + @SearchTerm + ''%'' OR
        CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%'' OR
        CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%'' OR
        D.Department_Name LIKE ''%'' + @SearchTerm + ''%''
    )
     
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )ORDER BY CPD.Candidate_Id
OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
FETCH NEXT @PageSize ROWS ONLY;

    end


      End
    ')
END
