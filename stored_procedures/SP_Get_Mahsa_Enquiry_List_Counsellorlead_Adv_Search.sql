IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Mahsa_Enquiry_List_Counsellorlead_Adv_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      create procedure [dbo].[SP_Get_Mahsa_Enquiry_List_Counsellorlead_Adv_Search] --1,100,'''',''--Select--'',''--Select--'',''--Select--'','''','''',''1'',''--Select--'',''--Select--'',''--Select--'',''--Select--'','''','''',''@Employee_Id      ''               
(                      
@CurrentPage int=null ,                                     
@PageSize int=null   ,                                  
@SearchTerm varchar(100)='''',                  
@CounselorCampus1 varchar(50)='''' ,                  
@EmployeeName varchar(50)='''',                  
@Type1 varchar(50)='''',              
@from   varchar(50)='''',              
@to varchar(50)='''',        
@ActiveStatus varchar(50)='''',    
@Hostel_Req  varchar(50)='''',    
@Scholarship varchar(50)='''',    
@Program varchar(50)='''',    
@feespaid  varchar(50)='''',    
@createdby  varchar(100)='''',    
@Marketing_Status varchar(100)='''' ,  
@Employee_Id varchar(100)=''''  
)                                                               
AS                                                            
BEGIN                       
SET NOCOUNT ON                                          
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
    if(@from=@to)              
       begin                         
(SELECT distinct   CPD.Candidate_Id as ID,SG.BloodGroup,                      
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                      
(convert(date,RegDate,105)) as RegDate,     
RegDate as RegDatetime,                     
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
ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,                          
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
                                  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                   
                                                       
 left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                 
                                                      
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id     
 left join Tbl_Student_status RR on RR.id=CPD.Active    
                                      
                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id    
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                                        
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                               
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                       
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0    
 left Join (    
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id    
    
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''     
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''   
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')     
        
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')          
 and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')    
   
  
 and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id ))  
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')          
 and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )      
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')      
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')    
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))    
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')      
  and(@createdby=''--Select--'' or EnrollBy=@createdby)       
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')     
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or     
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))    
    
Union all    
    
 (SELECT distinct   CPD.Candidate_Id as ID,SG.BloodGroup,                      
 CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                      
 (convert(date,CPD.RegDate,105)) as RegDate,     
 CPD.RegDate as RegDatetime,                     
 CPD.CounselorCampus,                      
 PD.TypeOfStudent,CPD.Active,                                                        
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
 PD.Hostel_Required as Hostel_Required,RR.name as statusinbarracuda  ,    
                                                 
 cbd.Batch_Id as BatchID,                                                  
   case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                     
 cbd.Batch_Code as Batch,    
 ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,                          
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
 left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                                        
                                  
 left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                   
                                                       
  left join Tbl_Sponsorship_candidate_mapping SM on CPD.Candidate_Id=SM.candidate_id                                                 
                                                      
 left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id     
 left join Tbl_Student_status RR on RR.id=CPD.Active    
    
                                      
                                                       
 left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                           
 left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                        
 LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                         
 LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                               
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                       
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )--and EC.Employee_Status=0    
 left Join (    
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in    
 (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id    
    
 where  (concat(LTRIM(RTRIM((PD.Candidate_Fname))),'' '',LTRIM(RTRIM((PD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )     
 or D.Department_Name like ''''+LTRIM(RTRIM(@SearchTerm))+''%''     
 or LTRIM(RTRIM(PD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''    
 or (PD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))  
 or LTRIM(RTRIM(CCat.Course_Category_Name)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''     
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''     
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')     
        
 and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'' or @CounselorCampus1=''0'')          
 and(PD.TypeOfStudent=@Type1 or @Type1=''--Select--'')          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')          
 and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,120)or @from='''' )      
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')      
  and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id ))  
 and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')    
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))    
 and (D.Course_Code= @Program or D.Department_Name=@Program or @Program =''--Select--'')      
  and(@createdby=''--Select--'' or CPD.EnrollBy=@createdby)       
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')     
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))    
 or  (@ActiveStatus = ''3'' and HS.Status=''HOLD'') or     
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data'')))    
    
    
      
 ORDER BY  nextDate asc,RegDatetime desc    
       OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);    
end           
else          
begin          
                                                  
 (SELECT distinct  top 100  CPD.Candidate_Id as ID,SG.BloodGroup,                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                      
 (convert(date,RegDate,103)) as RegDate,       
 RegDate as RegDatetime,                     
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
 ISNULL(FD.Next_Date,DATEADD(year, 100, ''5555-01-01'')) as nextDate,                          
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
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id                       
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0    
 left Join (    
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in    
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
  and(@createdby=''--Select--'' or EnrollBy=@createdby)          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')       
 and (CPD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')     
  and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id))  
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))    
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
 (@ActiveStatus=''4'' and CPD.ApplicationStatus=''Old Data''))    
  and(CPD.Active= @Marketing_Status or @Marketing_Status=''0'') )         
    
    
 Union all    
    
  (SELECT distinct top 100  CPD.Candidate_Id as ID,SG.BloodGroup,                      
 Concat(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                      
 (convert(date,CPD.RegDate,103)) as RegDate,       
 CPD.RegDate as RegDatetime,                     
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
 ISNULL(FD.Next_Date,DATEADD(year, 100, ''5555-01-01'')) as nextDate,                          
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
    left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id      
     left join Tbl_Status_change_by_Marketing HS on CPD.Candidate_Id= HS.Candidate_id                     
 left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)-- and EC.Employee_Status=0    
 left Join (    
 select Candidate_Id, Next_Date from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in    
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
  and(@createdby=''--Select--'' or PD.EnrollBy=@createdby)          
 and (concat(EC.Employee_FName,'' '',EC.Employee_LName)=@EmployeeName or @EmployeeName=''--Select--'')    
 and (SM.Sponsorship_Name = @Scholarship or @Scholarship =''--Select--'')       
 and (PD.Hostel_Required = @Hostel_Req or @Hostel_Req =''--Select--'' or @Hostel_Req =''0'')     
 and (CPD.FeeStatus = @feespaid or @feespaid =''--Select--'' or(CPD.FeeStatus is null and @feespaid=''Not Paid''))   
  and (CPD.CounselorEmployee_id in (select TeamMembers  from Tbl_Counsellor_Teamforming TCT where  TeamLead=@Employee_Id))  
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
  and(CPD.Active= @Marketing_Status or @Marketing_Status=''0'') )         
    
    
 ORDER BY  nextDate asc,RegDatetime desc    
                
                                                                
        OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);    
end                          
                   
               
       End     
    ')
END
