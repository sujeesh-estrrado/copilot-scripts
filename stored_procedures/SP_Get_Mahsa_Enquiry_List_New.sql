IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Mahsa_Enquiry_List_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
     CREATE procedure [dbo].[SP_Get_Mahsa_Enquiry_List_New] --1,100,'''',''--Select--'',''--Select--'',''--Select--'','''','''',''1'',''--Select--'',''--Select--'',''--Select--'',''--Select--'','''',''19''                               
  --SP_Get_Mahsa_Enquiry_List_New 1,100,'''',1445              
(                                      
@CurrentPage int=1 ,                                                     
@PageSize int=10   ,                                                  
@SearchTerm varchar(100)='''',     

@CounselorCampus1 varchar(50),                                

@CounselorEmp bigint=0  ,  
@Emp bigint=0, 
@Type1 varchar(50)='''',                              
@from   varchar(50)='''',                              
@to varchar(50)='''',                        
@ActiveStatus varchar(50)='''',                     
@Program varchar(50)='''',
@IsReverted bit = 0,
@flag int=0,
@FacultyId NVARCHAR(MAX), 
@ProgrammeId NVARCHAR(MAX), 
@IntakeId NVARCHAR(MAX)  
    


--@CounselorCampus1 varchar(50),                                
--@Type1 varchar(50)='''',                              
--@from   varchar(50)='''',                              
--@to varchar(50)='''',                        
--@ActiveStatus varchar(50)='''',                     
--@Program varchar(50)='''' 
--@EmployeeName varchar(50)=''''                                 
--@Type1 varchar(50)='''',                              
--@from   varchar(50)='''',                              
--@to varchar(50)='''',                        
--@ActiveStatus varchar(50)='''',                    
--@Hostel_Req  varchar(50)='''',                    
--@Scholarship varchar(50)='''',                    
--@Program varchar(50)='''',                    
--@feespaid  varchar(50)='''',                    
--@createdby  varchar(100)='''',                    
--@Marketing_Status varchar(100)=''''                    
)                                                                               
AS                                                                            
BEGIN                                      
               
  SET NOCOUNT ON    
  
DECLARE @FacultyTable TABLE (FacultyId INT);
    DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
    DECLARE @IntakeTable TABLE (IntakeId INT);

    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');

    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');

    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');
               


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
      select * from      
(                                
  (SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(date,RegDate,105)) as RegDate,                     
  RegDate as RegDatetime,     CounselorEmployee_id,                                
  CPD.CounselorCampus,                                      
  CPD.TypeOfStudent,CPD.Active,                                                                        
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
  CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
  cbd.Batch_Id as BatchID,                                                            
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
  cbd.Batch_Code as Batch,                    
 -- ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type,      
  NA.Batch_Id,                                         
                                                                
  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                                                   
                                                                       
  NA.Department_Id as DepartmentID,                                                                
                                 '''' AS DocUploaded,                             
                                                                
  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
  D.Department_Id=NA.Department_Id)  end  as Department ,            
  CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent   
                                          
                                                           
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
                                                  
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                        
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                               
                                                                      
  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
  left join Tbl_Student_status RR on RR.id=CPD.Active                    
                                                      
           
  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                 
  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                    
  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                              
  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or 
  Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
  where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                        
  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
  --and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
  --and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
  --and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
  and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
  --and(@createdby=''--Select--'' or EnrollBy=@createdby)                
  and (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')              
  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)     
    

  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))               
  )              
                    
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate,                     
--  CPD.RegDate as RegDatetime, CPD.CounselorEmployee_id ,                               
--  CPD.CounselorCampus,                                      
--  PD.TypeOfStudent,CPD.Active,                                                                        
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName,                                                                  
--  PD.Candidate_Fname,PD.AdharNumber,                                                                                    
--  PD.Candidate_Dob as DOB,                                                                    
--  CPD.New_Admission_Id as AdmnID,                          
--  CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus,                                                      
--  CC.Candidate_idNo as IdentificationNumber ,                                                    
                                                                        
--  CC.Candidate_ContAddress as Address,                                                                            
--  CC.Candidate_Mob1 as MobileNumber,                                                                          
--  CC.Candidate_Email as EmailID ,                                                                  
--  CCat.Course_Category_Id,                    
--  PD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--  cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  cbd.Batch_Code as Batch,                    
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,                                       
--  NA.Batch_Id,                                         
                                                        
--  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                  
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                               
                        
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--  D.Department_Id=NA.Department_Id)  end  as Department   ,            
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent     
                                          
                           
--  FROM Tbl_Student_NewApplication CPD                    
                    
--  Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                                   
                                                           
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                           
--  left join                                                
--  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
--  and   ss.student_semester_current_status=1                                                  
--  left JOIN                           
--  Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                       
--  left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
--  left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                       
--  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                                        
                                                  
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                 
                                                                      
--  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
--  left join Tbl_Student_status RR on RR.id=CPD.Active                    
                    
                                                      
                                                                       
--  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                          
--  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
--  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
--  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
--  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
--  or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
--  or (PD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
--  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                        
--  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
--  --and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
--  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
--  --and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
--  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
--  --and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
--  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
--  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
--  --and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                     
--  and (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')              
--  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)              
--  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
--  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
--  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
--  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')or (@ActiveStatus=''9'' and (CPD.ApplicationStatus=''Lead'' ))) )               
--  )              
                    
--  --Lead integration with enquiry                
--  Union all                    
                    
--  (SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,RegDate,105)) as RegDate,                     
--  RegDate as RegDatetime,CounselorEmployee_id  ,                                   
--  CPD.CounselorCampus,                                      
--  CPD.TypeOfStudent,CPD.Active,                                    
--  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                  
--  CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
--  CPD.Candidate_Dob as DOB,                                                                         
--  CPD.New_Admission_Id as AdmnID,                          
--  CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus,                                                      
--  CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                                        
--  CC.Candidate_ContAddress as Address,                                                                            
--  CC.Candidate_Mob1 as MobileNumber,                                                                          
--  CC.Candidate_Email as EmailID ,                                                                  
--  CCat.Course_Category_Id,                    
--  CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--  cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
--  cbd.Batch_Code as Batch,                    
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
--  NA.Batch_Id,                                         
                                                                
--  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                                                        
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                          
                                                                       
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--  D.Department_Id=NA.Department_Id)  end  as Department ,            
--  CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent   
                                                                 
                                  
                                                           
--  FROM Tbl_Lead_Personal_Det CPD                    
                    
                                                                   
                             
--  left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  left join                                                
--  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
--  and   ss.student_semester_current_status=1                                                  
--  left JOIN                                                   
--  Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                 
--  left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
--  left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
--  left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                     
--  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
--  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                          
--  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
--  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
--  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
--  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
--  where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                 
--  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
--  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
--  or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
--  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                    
--  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
--  --and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
--  --and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                          
--  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
--  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
--  --and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
--  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
--  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                    
--  --and                    
--  --(((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
--  --OR (@from IS NULL AND @to IS NULL)                    
--  --OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
--  --OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
--  --or @from='''' or @to='''')                         
--        and CPD.ApplicationStatus=''Lead''              
--  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)              
--  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
--  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' ))                    
--  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
--  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'') or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))                    
--  --and(CPD.Active= @Marketing_Status or @Marketing_Status=''0'' )              
--  )     
  )as TRes         
                      
  ORDER BY    
  TRes.RegDatetime desc    
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
                             
         end
         if @flag=1
         begin 
         select * from      
(                                
  (SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(date,RegDate,105)) as RegDate,                     
  RegDate as RegDatetime,     CounselorEmployee_id,                                
  CPD.CounselorCampus,                                      
  CPD.TypeOfStudent,CPD.Active,                                                                        
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                  
  CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
  CPD.Candidate_Dob as DOB,                                                                         
  CPD.New_Admission_Id as AdmnID,                          
  CPD.ApplicationStage as Stage,                         
  CPD.ApplicationStatus as ApplicationStatus,                                                      
  CC.Candidate_idNo as IdentificationNumber ,                               
                                                                        
  CC.Candidate_ContAddress as Address,                                                                        
  CC.Candidate_Mob1 as MobileNumber,                                                                
  ''email'' as EmailID ,                                         
  CCat.Course_Category_Id,                    
  CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
  cbd.Batch_Id as BatchID,                                                            
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
  cbd.Batch_Code as Batch,                    
 -- ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type,      
  NA.Batch_Id,                                         
                                                                
  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                                                   
                                                                       
  NA.Department_Id as DepartmentID,                                                                
                                                              
                     '''' AS DocUploaded,                                           
  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
  D.Department_Id=NA.Department_Id)  end  as Department ,            
  CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent   
                                          
                                                           
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
                                                  
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                        
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                               
                                                                      
  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
  left join Tbl_Student_status RR on RR.id=CPD.Active                    
                                                      
           
  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                 
  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                    
  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                              
  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
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
) AS FD  on FD.Candidate_Id=CPD.Candidate_Id                    
                    
  where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                        
  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
  --and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
  --and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
  --and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
  --and(@createdby=''--Select--'' or EnrollBy=@createdby)                
  and (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')              
  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)      
  and(FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate()))
  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))               
  )              
                    
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate,                     
--  CPD.RegDate as RegDatetime, CPD.CounselorEmployee_id ,                               
--  CPD.CounselorCampus,                                      
--  PD.TypeOfStudent,CPD.Active,                                                                        
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName,                                                                  
--  PD.Candidate_Fname,PD.AdharNumber,                                                                                    
--  PD.Candidate_Dob as DOB,                                                                    
--  CPD.New_Admission_Id as AdmnID,                          
--  CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus,                                                      
--  CC.Candidate_idNo as IdentificationNumber ,                                                    
                                                                        
--  CC.Candidate_ContAddress as Address,                                                                            
--  CC.Candidate_Mob1 as MobileNumber,                                                                          
--  CC.Candidate_Email as EmailID ,                                                                  
--  CCat.Course_Category_Id,                    
--  PD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--  cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  cbd.Batch_Code as Batch,                    
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,                                       
--  NA.Batch_Id,                                         
                                                        
--  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                  
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                               
                        
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--  D.Department_Id=NA.Department_Id)  end  as Department   ,            
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent     
                                          
                           
--  FROM Tbl_Student_NewApplication CPD                    
                    
--  Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                                   
                                                           
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                           
--  left join                                                
--  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
--  and   ss.student_semester_current_status=1                                                  
--  left JOIN                           
--  Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                       
--  left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
--  left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                       
--  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                                        
                                                  
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                 
                                                                      
--  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
--  left join Tbl_Student_status RR on RR.id=CPD.Active                    
                    
                                                      
                                                                       
--  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                          
--  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
--  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
--  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
--  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
--  or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
--  or (PD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
--  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                        
--  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
--  --and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
--  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
--  --and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
--  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
--  --and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
--  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
--  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
--  --and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                     
--  and (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')              
--  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)              
--  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
--  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
--  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
--  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')or (@ActiveStatus=''9'' and (CPD.ApplicationStatus=''Lead'' ))) )               
--  )              
                    
--  --Lead integration with enquiry                
--  Union all                    
                    
--  (SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,RegDate,105)) as RegDate,                     
--  RegDate as RegDatetime,CounselorEmployee_id  ,                                   
--  CPD.CounselorCampus,                                      
--  CPD.TypeOfStudent,CPD.Active,                                    
--  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                  
--  CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
--  CPD.Candidate_Dob as DOB,                                                                         
--  CPD.New_Admission_Id as AdmnID,                          
--  CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus,                                                      
--  CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                                        
--  CC.Candidate_ContAddress as Address,                                                                            
--  CC.Candidate_Mob1 as MobileNumber,                                                                          
--  CC.Candidate_Email as EmailID ,                                                                  
--  CCat.Course_Category_Id,                    
--  CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--  cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
--  cbd.Batch_Code as Batch,                    
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
--  NA.Batch_Id,                                         
                                                                
--  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                                                        
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                          
                                                                       
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--  D.Department_Id=NA.Department_Id)  end  as Department ,            
--  CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent   
                                                                 
                                  
                                                           
--  FROM Tbl_Lead_Personal_Det CPD                    
                    
                                                                   
                             
--  left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  left join                                                
--  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
--  and   ss.student_semester_current_status=1                                                  
--  left JOIN                                                   
--  Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                 
--  left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
--  left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
--  left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                     
--  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
--  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                          
--  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
--  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
--  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
--  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
--  where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                 
--  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
--  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
--  or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
--  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                    
--  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
--  --and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
--  --and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                          
--  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
--  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
--  --and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
--  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
--  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                    
--  --and                    
--  --(((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
--  --OR (@from IS NULL AND @to IS NULL)                    
--  --OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
--  --OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
--  --or @from='''' or @to='''')                         
--        and CPD.ApplicationStatus=''Lead''              
--  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)              
--  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
--  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' ))                    
--  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
--  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'') or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))                    
--  --and(CPD.Active= @Marketing_Status or @Marketing_Status=''0'' )              
--  )     
  )as TRes         
                      
  ORDER BY   CASE WHEN TRes.CounselorEmployee_id = @Emp THEN 0 ELSE 1 END,  
  TRes.RegDatetime desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
         end
         if @flag=2
         begin
         select * from      
(                                
  (SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(date,RegDate,105)) as RegDate,                     
  RegDate as RegDatetime,     CounselorEmployee_id,                                
  CPD.CounselorCampus,                                      
  CPD.TypeOfStudent,CPD.Active,                                                                        
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
  CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
  cbd.Batch_Id as BatchID,                                                            
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
  cbd.Batch_Code as Batch,                    
 -- ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type,      
  NA.Batch_Id,                                         
            '''' AS DocUploaded,                                                    
  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
  (Case when SR.UserId IS NULL  Then '' ''                                                                        
  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                                                   
                                                                       
  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
  D.Department_Id=NA.Department_Id)  end  as Department ,            
  CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent   
                                          
                                                           
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
                                                  
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                        
                                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                               
                                                                      
  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
  left join Tbl_Student_status RR on RR.id=CPD.Active                    
                                                      
           
  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                 
  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                    
  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                              
  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
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
                        
  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
  --and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
  --and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
  --and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
  --and(@createdby=''--Select--'' or EnrollBy=@createdby)                
  and (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')              
  and (CPD.CounselorEmployee_id= 0 or CPD.CounselorEmployee_id=null)      
  and(FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate()))
  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))               
  )              
                    
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate,                     
--  CPD.RegDate as RegDatetime, CPD.CounselorEmployee_id ,                               
--  CPD.CounselorCampus,                                      
--  PD.TypeOfStudent,CPD.Active,                                                                        
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName,                                                                  
--  PD.Candidate_Fname,PD.AdharNumber,                                                                                    
--  PD.Candidate_Dob as DOB,                                                                    
--  CPD.New_Admission_Id as AdmnID,                          
--  CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus,                                                      
--  CC.Candidate_idNo as IdentificationNumber ,                                                    
                                                                        
--  CC.Candidate_ContAddress as Address,                                                                            
--  CC.Candidate_Mob1 as MobileNumber,                                                                          
--  CC.Candidate_Email as EmailID ,                                                                  
--  CCat.Course_Category_Id,                    
--  PD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--  cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  cbd.Batch_Code as Batch,                    
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,                                       
--  NA.Batch_Id,                                         
                                                        
--  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                  
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                               
                        
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--  D.Department_Id=NA.Department_Id)  end  as Department   ,            
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent     
                                          
                           
--  FROM Tbl_Student_NewApplication CPD                    
                    
--  Inner join Tbl_Candidate_Personal_Det  PD on PD.Candidate_Id=CPD.Candidate_Id                                                                   
                                                           
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                           
--  left join                                                
--  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
--  and   ss.student_semester_current_status=1                                                  
--  left JOIN                           
--  Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                       
--  left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
--  left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                       
--  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                                        
                                                  
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                 
                                                                      
--  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                     
--  left join Tbl_Student_status RR on RR.id=CPD.Active                    
                    
                                                      
                                                                       
--  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                          
--  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
--  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
--  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
--  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
--  or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
--  or (PD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
--  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                        
--  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')                          
--  --and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                          
--  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                          
--  --and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )                      
--  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                      
--  --and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                    
--  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
--  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                      
--  --and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                     
--  and (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')              
--  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)              
--  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
--  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                    
--  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
--  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')or (@ActiveStatus=''9'' and (CPD.ApplicationStatus=''Lead'' ))) )               
--  )              
                    
--  --Lead integration with enquiry                
--  Union all                    
                    
--  (SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,RegDate,105)) as RegDate,                     
--  RegDate as RegDatetime,CounselorEmployee_id  ,                                   
--  CPD.CounselorCampus,                                      
--  CPD.TypeOfStudent,CPD.Active,                                    
--  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                  
--  CPD.Candidate_Fname,CPD.AdharNumber,                                                                                    
--  CPD.Candidate_Dob as DOB,                                                                         
--  CPD.New_Admission_Id as AdmnID,                          
--  CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus,                                                      
--  CC.Candidate_idNo as IdentificationNumber ,                                                              
                                                                        
--  CC.Candidate_ContAddress as Address,                                                                            
--  CC.Candidate_Mob1 as MobileNumber,                                                                          
--  CC.Candidate_Email as EmailID ,                                                                  
--  CCat.Course_Category_Id,                    
--  CPD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,                    
                                                                 
--  cbd.Batch_Id as BatchID,                                                                  
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
--  cbd.Batch_Code as Batch,                    
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
--  NA.Batch_Id,                                         
                                                                
--  case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                                       
--  cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                        
                     
                               
--  (Case when SR.UserId IS NULL  Then '' ''                                                                        
--  Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                                        
                                                                          
--  NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                                          
--  NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                          
                                                                       
--  NA.Department_Id as DepartmentID,                                                                
                                                              
                                                                
--  case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--  D.Department_Id=NA.Department_Id)  end  as Department ,            
--  CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent   
                                                                 
                                  
                                                           
--  FROM Tbl_Lead_Personal_Det CPD                    
                    
                                                                   
                             
--  left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  left join                                                
--  dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                                                 
--  and   ss.student_semester_current_status=1                                                  
--  left JOIN                                                   
--  Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                                                 
--  left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                                      
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                                           
--  left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                          
--  left join Tbl_Student_status RR on RR.id=CPD.Active                                                   
                                                  
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
                                                                       
--  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                                     
                                     
--  left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                                                       
                                                                       
--  left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                                           
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                          
--  LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                                         
--  LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                                               
--  --left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                      
--  left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                     
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0                
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
--  where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                 
--  or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
--  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                    
--  or (Cpd.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
--  or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
--  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                     
                    
--  --and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--''or @CounselorCampus1=''0'')                          
--  --and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')                       
--  --and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)                          
--  --and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')                    
--  --and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')                       
--  --and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')                     
--  --and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))                    
--  --and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')                    
--  --and                    
--  --(((CONVERT(date,CPD.RegDate)) >= @from and (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
--  --OR (@from IS NULL AND @to IS NULL)                    
--  --OR (@from IS NULL AND (CONVERT(date,CPD.RegDate)) < DATEADD(day,1,@to))                    
--  --OR (@to IS NULL AND (CONVERT(date,CPD.RegDate)) >= @from)                    
--  --or @from='''' or @to='''')                         
--        and CPD.ApplicationStatus=''Lead''              
--  and (CPD.CounselorEmployee_id= @CounselorEmp or @CounselorEmp=0)              
--  --and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                     
--  --or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Lead'' ))                    
--  --or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or                     
--  --(@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'') or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))                    
--  --and(CPD.Active= @Marketing_Status or @Marketing_Status=''0'' )              
--  )     
  )as TRes         
                      
  ORDER BY   CASE WHEN TRes.CounselorEmployee_id = @Emp THEN 0 ELSE 1 END,  
  TRes.RegDatetime desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
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
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
           END   
            IF(@flag=301)
     BEGIN             
            SELECT distinct CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   --PR.result as ApplicationStatus,
    --(select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                                     
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD    
         LEFT JOIN Tbl_FollowUp_Detail f ON f.candidate_id = cpd.candidate_id                                                                                                                                 
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                       
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
 -- left join Tbl_Placement_Log PR On CPD.Candidate_Id=PR.Candidate_id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
    WHERE  (f.Next_Date IS NULL OR f.Next_Date <= CONVERT(DATE, GETDATE()))
           AND (cpd.ApplicationStatus IN (''Pending'', ''submited''))
           AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
       
           END
           IF(@flag=302)
     BEGIN             
            SELECT distinct CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   --PR.result as ApplicationStatus,
    --(select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                                     
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD    
         LEFT JOIN Tbl_FollowUp_Detail f ON f.candidate_id = cpd.candidate_id                                                                                                                                 
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                       
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
 -- left join Tbl_Placement_Log PR On CPD.Candidate_Id=PR.Candidate_id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
    WHERE  (CPD.ApplicationStatus IN (''Pending'', ''submited''))
         AND (CPD.CounselorEmployee_id = 0 OR CPD.CounselorEmployee_id = '''')
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')
         
           END
          if(@flag=3)
          begin
                select * from      
(                                
  (SELECT distinct CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   --PR.result as ApplicationStatus,
   -- (select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,   
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                      
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
 -- left join Tbl_Placement_Log PR On CPD.Candidate_Id=PR.Candidate_id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id  
  left join Tbl_Status_change_by_Marketing scm on scm.Candidate_id=CPD.Candidate_Id
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
  where 
  --(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
    (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 ) 
     and scm.status=''Hold''    and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
  )
  
  )as TRes
          end
                    IF(@flag=306)
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
        CPD.ApplicationStatus = ''rejected''
         AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        ) and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
         
           END               
                    
      if(@flag=4)
      begin
       select * from      
(                                
  (SELECT distinct CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   --PR.result as ApplicationStatus,
   -- (select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,   
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                      
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
 -- left join Tbl_Placement_Log PR On CPD.Candidate_Id=PR.Candidate_id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id  
  left join Tbl_Status_change_by_Marketing scm on scm.Candidate_id=CPD.Candidate_Id
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
  where  (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )
    and CPD.ApplicationStatus=''rejected'' and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')    
  )     )as tres
      end
          IF(@flag=304)
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
        M.status = ''Hold'' AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
         
           END  
           if(@flag=200)
           begin
             select * from      
(                                
  (SELECT distinct CPD.Candidate_Id as ID,                                     
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus , 
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                      
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join Tbl_FollowUp_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
  where
  CPD.CounselorEmployee_id=@CounselorEmp
  AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE)
  AND (CPD.applicationstatus=''pending'' or CPD.applicationstatus=''submited'')
  and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
  ) 
  )as TRes
           end
           if(@flag=201)
           begin
             select * from      
(                                
  (SELECT distinct CPD.Candidate_Id as ID,                                     
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus , 
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                      
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id
  where
  EC.Employee_Id=@CounselorEmp
  AND (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')  and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
  
  ) 
  )as TRes         
           end
              if(@flag=401)
  begin
  select * from      
(                                
  (SELECT distinct CPD.Candidate_Id as ID,                                     
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus , 
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                      
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join Tbl_FollowUp_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
  where
  EC.Employee_Id=@CounselorEmp
  AND (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
    AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )
     and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
  ) 
  )as TRes   
  end
    if(@flag=402)
  begin
 WITH LatestFollowUp AS (
    SELECT 
        Candidate_Id, 
        Next_Date, 
        Respond_Type,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Next_Date DESC) AS RowNum
    FROM Tbl_FollowUp_Detail
)
SELECT * FROM      
(                                 
  SELECT DISTINCT 
      CPD.Candidate_Id as ID,                                     
      CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) as Employee_Name,                                      
      CONVERT(NVARCHAR(10), RegDate, 105) as RegDate,  
      RegDate AS RDate,                                        
      CPD.TypeOfStudent,                                                          
      CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
      CPD.AdharNumber, 
      CPD.ApplicationStage as Stage, 
      CPD.ApplicationStatus AS ApplicationStatus,
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email AS EmailID,                                                        
      CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
      ELSE ''Not Paid'' END AS FeeStatus, 
      CONVERT(NVARCHAR(10), LF.Next_Date, 105) AS nextDate,
      LF.Respond_Type, 
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
  LEFT JOIN LatestFollowUp LF ON LF.Candidate_Id = CPD.Candidate_Id AND LF.RowNum = 1 -- Select only latest follow-up record
  WHERE
      CPD.CounselorEmployee_id = @CounselorEmp
      AND (LF.Next_Date IS NULL OR LF.Next_Date <= CONVERT(DATE, GETDATE())) 
      AND (CPD.ApplicationStatus IN (''pending'', ''Pending'', ''submited''))
         AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')
  
) AS TRes   
  

End 
  if(@flag=400)
  begin
  select * from      
(                                
  (SELECT distinct CPD.Candidate_Id as ID,                                     
  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
  CPD.TypeOfStudent,                                                          
  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
  CPD.ApplicationStage as Stage, 
  CPD.ApplicationStatus as ApplicationStatus,
   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus , 
  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
   NA.Department_Id as DepartmentID
                                                                                                
  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                      
  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join Tbl_FollowUp_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
  where
  CPD.CounselorEmployee_id=@CounselorEmp
  AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE)
  AND (CPD.applicationstatus=''pending'' or CPD.applicationstatus=''submited'')
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')
  ) 
  )as TRes
  end
    if(@flag=202)
  begin
 WITH LatestFollowUp AS (
    SELECT 
        Candidate_Id, 
        Next_Date, 
        Respond_Type,
        ROW_NUMBER() OVER (PARTITION BY Candidate_Id ORDER BY Next_Date DESC) AS RowNum
    FROM Tbl_FollowUp_Detail
)
SELECT * FROM      
(                                 
  SELECT DISTINCT 
      CPD.Candidate_Id as ID,                                     
      CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) as Employee_Name,                                      
      CONVERT(NVARCHAR(10), RegDate, 105) as RegDate,  
      RegDate AS RDate,                                        
      CPD.TypeOfStudent,                                                          
      CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName, 
      CPD.AdharNumber, 
      CPD.ApplicationStage as Stage, 
      CPD.ApplicationStatus AS ApplicationStatus,
      CC.Candidate_Mob1 AS MobileNumber, 
      CC.Candidate_Email AS EmailID,                                                        
      CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' 
      ELSE ''Not Paid'' END AS FeeStatus, 
      CONVERT(NVARCHAR(10), LF.Next_Date, 105) AS nextDate,
      LF.Respond_Type, 
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
  LEFT JOIN LatestFollowUp LF ON LF.Candidate_Id = CPD.Candidate_Id AND LF.RowNum = 1 -- Select only latest follow-up record
  WHERE
      CPD.CounselorEmployee_id = @CounselorEmp
      AND (LF.Next_Date IS NULL OR LF.Next_Date <= CONVERT(DATE, GETDATE())) 
      AND (CPD.ApplicationStatus IN (''pending'', ''Pending'', ''submited''))and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')
       
) AS TRes   
end
 IF(@flag=332)
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
        M.status = ''Hold'' AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
         
           END 
                       IF(@flag=330)
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
    WHERE   (CPD.ApplicationStatus IN (''Pending'', ''submited''))
           AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0) 
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
         
           END   
                      IF(@flag=331)
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
    WHERE  (FD.Next_Date IS NULL OR FD.Next_Date <= CONVERT(DATE, GETDATE()))
           AND (cpd.ApplicationStatus IN (''Pending'', ''submited''))
           AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0) 
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''') 
         
           END 
                      IF(@flag=333)
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
    WHERE  CPD.ApplicationStatus = ''rejected''
           AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0) 
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )and
         (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                     
 -- or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''                     
  or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                   
  or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                  
 -- or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                     
  or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')
         
         
           END   
End                    
                        
           
    ')
END
