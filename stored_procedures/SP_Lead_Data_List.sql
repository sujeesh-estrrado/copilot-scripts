IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Lead_Data_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Lead_Data_List]-- 1,100,'''',''0'',''9'',''True''                          
(                                                      
@CurrentPage int=null ,                                                                     
@PageSize int=null   ,                                                                  
@SearchTerm varchar(100)='''',                   
@counselorid bigint=0,                                            
@ActiveStatus varchar(50)='''',                                    
@allocated varchar(100)='''',            
@Startdate datetime ='''',            
@Enddate datetime = '''',
@SourceName Bigint = 0,
@SourceType varchar(100) = ''0'',
@FollowUpStatus varchar(200) = ''All'',
@NextFollowupDate date = null,
@flag int=0 ,
@FacultyId NVARCHAR(MAX)='''', 
@ProgrammeId NVARCHAR(MAX)='''', 
@IntakeId NVARCHAR(MAX)='''' ,
@templateid bigint = 0,
@leadcounsellorid nvarchar(50)='''',
@leadcreatedby bigint=0,
@leadsourceid nvarchar(50)='''',
@leadnationalityid nvarchar(50)='''',
@leadstatusid nvarchar(50)='''',
@interestid nvarchar(50)='''',
@createddatefrom nvarchar(50)=null,
@createddateto nvarchar(50)=null,
@followupdatefrom nvarchar(50)=null,
@followupdateto nvarchar(50)=null
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
    Declare @TotalCount INT                                                                     
    SET @LowerBand  = (@CurrentPage -                                                        
     1) * @PageSize                                                                            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                                           
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                                    
  DROP TABLE #TEMP1;                                              
    IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                                    
  DROP TABLE #TEMP2; 
  if @flag=0
  begin
    if @allocated=''True''                                  
 begin 
(SELECT distinct   CPD.Candidate_Id as ID, CPD.CounselorEmployee_id,                                              
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                        
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                                                                                          
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,     
N.Nationality as Nationality,
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                  
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,         
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                     
                                                  
CC.Candidate_ContAddress as Address,                                                             
CC.Candidate_Mob1 as MobileNumber,                                                        
CC.Candidate_Email as EmailID  ,         
SUBSTRING((SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) )),      
CHARINDEX(''Course Opted :'', (SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))),       
CHARINDEX('', Nationality:'',(SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))))as optedProgramme,      
      
      
CPD.Scolorship_Remark as Remark    ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,                                                                
                                                              
                                                                
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department                                 
       ,il.Interest_level_Name                                                                      
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                   
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id   
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
 --left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
 -- left join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= ILM.InterestLevel_ID
 LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id              
                                      
 where 


 (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                       
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                                       
                                          
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))        
 
and                                  
CPD.CounselorEmployee_id is not null and                               
((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  
and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0)              
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
    --AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
    --       AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
    --       AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  
  --      AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
  --      AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        --AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id asc,RegDatetime desc                                      
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                      
end                                             
          else    
          if @allocated=''False''                            
    begin        

--    (SELECT distinct   CPD.Candidate_Id as ID,                                               
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
--(convert(date,RegDate,105)) as RegDate,                                       
--RegDate as RegDatetime,                                                       
--CPD.CounselorCampus,                                                        
--CPD.TypeOfStudent,CPD.Active,                              
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
--CPD.Candidate_Dob as DOB,   
--N.Nationality as Nationality,
--   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
--CPD.New_Admission_Id as AdmnID,                                            
--CPD.ApplicationStage as Stage,                                           
--case when                                 
--CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
--case when                                 
--CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
--CC.Candidate_idNo as IdentificationNumber ,                                                                                
--SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
--CC.Candidate_ContAddress as Address,                                                                                              
--CC.Candidate_Mob1 as MobileNumber,                          
--CC.Candidate_Email as EmailID  ,                      
--CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
--,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
--case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--D.Department_Id=NA.Department_Id)  end  as Department                                                                                  
                                                                            
                                                                 
--FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id 

--left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
--left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
--left Join (                              
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
-- where  
-- (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
-- or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))               
--and                                  
--(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')             
--and (              
--  (@Startdate='''' and @Enddate ='''')              
--  or              
--  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
--  or              
--  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
--  or              
--  (RegDate between @Startdate and @Enddate )              
-- )
-- And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
-- And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
-- And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
-- AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
--)                                  
                         
-- ORDER BY  CPD.Candidate_Id asc,RegDatetime desc  
 SELECT DISTINCT  
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                   
    CONVERT(DATE, RegDate, 105) AS RegDate,                                       
    RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                              
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,   
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                           
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,     
    CASE 
        WHEN ISNULL(CPD.Page_Id, 0) = 0 THEN ''Landing'' 
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,  




    CC.Candidate_idNo AS IdentificationNumber,                                                                                
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,                                                                                           
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                          
    CC.Candidate_Email AS EmailID,                       
    CPD.Scolorship_Remark AS Remark,
    CPD.Source_name,     
    CPD.SourceofInformation AS SourceofInformation,                
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department                                                                                  
         ,il.Interest_level_Name 
FROM Tbl_Lead_Personal_Det CPD                                                                           
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
LEFT JOIN Tbl_FollowUpLead_Detail FD ON FD.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT)
 -- LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
--LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT Tbl_Interest_level_Mapping.InterestLevel_ID FROM Tbl_Interest_level_Mapping 
left join Tbl_Interest_level_Master on Tbl_Interest_level_Master.InterestLevel_ID = Tbl_Interest_level_Mapping.InterestLevel_ID WHERE Lead_Status_Id = CPD.LeadStatus_Id and Interest_level_DelStatus=0)

WHERE 
                 
--m.status=''Hold''
 ((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 

 and (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')    
AND (ISNULL(CPD.LeadStatus_Id,0) = @ActiveStatus OR @ActiveStatus = 0)      
                       
--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))    
  
and (      
(@Startdate='''' and @Enddate ='''')      
or      
(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
or      
(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
or      
(RegDate between @Startdate and @Enddate ) 
AND ((TRIM(CPD.Source_name) = (SELECT TRIM(SourceName) from Tbl_SourceInfo where SourceID = @SourceName)) OR (@SourceName = 0))
--And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))

And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))

And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
) 
   --AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
   --        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
   --        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  ORDER BY CPD.Candidate_Id ASC, RegDatetime DESC

       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                   
                                  
                                  
    end                                  
                                    
                              
    else                          
         if(@ActiveStatus=0)                  
      begin      
         print ''allocated flse''
--    (SELECT distinct   CPD.Candidate_Id as ID,                                               
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                        
--(convert(date,RegDate,105)) as RegDate,                                       
--RegDate as RegDatetime,                                                       
--CPD.CounselorCampus,                                                        
--CPD.TypeOfStudent,CPD.Active,                                                                                          
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
--CPD.Candidate_Dob as DOB,       
--N.Nationality as Nationality,
--   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
--CPD.New_Admission_Id as AdmnID,                                            
--CPD.ApplicationStage as Stage,                                           
--case when                                 
--CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,                                                                        
--case when                                 
--CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing''  when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
--CC.Candidate_idNo as IdentificationNumber ,                 
                                                                                          
--CC.Candidate_ContAddress as Address,                                                                                              
--CC.Candidate_Mob1 as MobileNumber,                                                                                            
--CC.Candidate_Email as EmailID     ,           
--SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,          
--CPD.Scolorship_Remark as Remark   ,                  
--CPD.Source_name, CPD.SourceofInformation as  SourceofInformation              
--,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type    ,
--case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--D.Department_Id=NA.Department_Id)  end  as Department  ,LM.Lead_Status_Name as LeadStatus ,LM.Lead_Status_Id 
                                                                                
                                                                            
                                               
--FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                            
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
--left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id 
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id     
--left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
--LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
--left join Tbl_Lead_Status_Master LM on LM.Lead_Status_Id=CPD.LeadStatus_Id

--left Join (                              
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
          
                                      
-- where 
     
--  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                       
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
-- or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                                       
                                      
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                              
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')) and (                          
--CPD.CounselorEmployee_id=@counselorid or @counselorid=0)              
--and (              
--  (@Startdate='''' and @Enddate ='''')              
--  or              
--  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
--  or              
--  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
--  or              
--  (RegDate between @Startdate and @Enddate )              
-- )
-- And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
-- And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
-- And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
--  AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
--  (SELECT distinct   CPD.Candidate_Id as ID,                                               
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
--(convert(date,RegDate,105)) as RegDate,                                       
--RegDate as RegDatetime,                                                       
--CPD.CounselorCampus,                                                        
--CPD.TypeOfStudent,CPD.Active,                              
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
--CPD.Candidate_Dob as DOB,   
--   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
--N.Nationality as Nationality,
--CPD.New_Admission_Id as AdmnID,                                            
--CPD.ApplicationStage as Stage,                                           
--case when                                 
--CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
--case when                                 
--CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
--CC.Candidate_idNo as IdentificationNumber ,                                                                                
--SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
--CC.Candidate_ContAddress as Address,                                                                                              
--CC.Candidate_Mob1 as MobileNumber,                          
--CC.Candidate_Email as EmailID  ,                      
--CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
--,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
--case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
--D.Department_Id=NA.Department_Id)  end  as Department                                                                                  
                                                                            
                                                                 
--FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id 

--left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
--left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
--left Join (                              
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
-- where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
-- or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))  
--and                                  
--(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')             
--and (              
--  (@Startdate='''' and @Enddate ='''')              
--  or              
--  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
--  or              
--  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
--  or              
--  (RegDate between @Startdate and @Enddate )              
-- )
-- And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
-- And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
-- And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
-- AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') 
--  AND (NA.Course_Level_Id = @FacultyId OR @FacultyId = 0)
-- AND (NA.Department_Id = @ProgrammeId OR @ProgrammeId = 0)
-- AND (NA.Batch_Id = @IntakeId OR @IntakeId = 0)
--)                                  
        
--)                                  
                                      
                                  
                                      
                                        
-- ORDER BY  RegDatetime desc   

SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    --CASE 

    ----    WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
    ----    ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    ----END AS PageName,    
     CPD.Enquiry_From AS PageName,


    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
left join Tbl_Lead_Status_Master LM on LM.Lead_Status_Id=CPD.LeadStatus_Id
 --left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
 -- left join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= ILM.InterestLevel_ID
  LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=LM.Lead_Status_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 Tbl_Interest_level_Mapping.InterestLevel_ID FROM Tbl_Interest_level_Mapping 
left join Tbl_Interest_level_Master on Tbl_Interest_level_Master.InterestLevel_ID = Tbl_Interest_level_Mapping.InterestLevel_ID WHERE Lead_Status_Id = CPD.LeadStatus_Id and Interest_level_DelStatus=0)
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE 
    (CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%'' 
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''                                     
    OR CPD.AdharNumber LIKE REPLACE(''%'' + @SearchTerm + ''%'', ''-'', '''')                                    
    OR LTRIM(RTRIM(CC.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''                                       
    OR LTRIM(RTRIM(CC.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%'' 
    OR LTRIM(RTRIM(@SearchTerm)) = '''')       
    AND (CPD.LeadStatus_Id = @ActiveStatus OR CPD.ApplicationStatus NOT IN (''rejected'',''Pending''))
    --AND (CPD.LeadStatus_Id =@ActiveStatus or @ActiveStatus=0)

        --AND (CPD.LeadStatus_Id = @ActiveStatus)

    --AND (CPD.ApplicationStatus NOT IN (''rejected'',''Pending''))
    --AND ((ISNULL(CPD.LeadStatus_Id,0) NOT IN (SELECT LSM.Lead_Status_Id FROM Tbl_Lead_Status_Master LSM WHERE LSM.Lead_Status_Name IN (''Move to Application'',''Rejected'') AND LSM.Lead_Status_DelStatus = 0)))
    --AND (CPD.ApplicationStatus  IN (''Lead''))
    --or(CPD.ApplicationStatus!=''Pending'')  
    -- or CPD.ApplicationStatus!=''submited''
    --or (CPD.ApplicationStatus!=''Lead'')
--AND (
--    (@ActiveStatus = ''2'' AND CPD.ApplicationStatus = ''rejected'')                              
--    OR (@ActiveStatus = ''1'' AND (CPD.ApplicationStatus = ''Pending'' OR CPD.ApplicationStatus = ''pending'' OR CPD.ApplicationStatus = ''submited''))                                       
--    OR (@ActiveStatus = ''9'' AND CPD.ApplicationStatus = ''Lead'')
--) 
AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)              
AND (
    (@Startdate = '''' AND @Enddate = '''')              
    OR (@Startdate = '''' AND @Enddate <> '''' AND RegDate < @Enddate)              
    OR (@Startdate <> '''' AND @Enddate = '''' AND RegDate > @Startdate)              
    OR (RegDate BETWEEN @Startdate AND @Enddate)              
)
AND ((TRIM(CPD.Source_name) = (SELECT TRIM(SourceName) from Tbl_SourceInfo where SourceID = @SourceName)) OR (@SourceName = 0))
--AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
   --AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
   --        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
   --        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                   
                                  
                                  
    end     
    
    -----for lead status filter else start
    else
     begin      
         print ''allocated flse''


SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
left join Tbl_Lead_Status_Master LM on LM.Lead_Status_Id=CPD.LeadStatus_Id
 --left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
 -- left join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= ILM.InterestLevel_ID
  LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=LM.Lead_Status_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 Tbl_Interest_level_Mapping.InterestLevel_ID FROM Tbl_Interest_level_Mapping 
left join Tbl_Interest_level_Master on Tbl_Interest_level_Master.InterestLevel_ID = Tbl_Interest_level_Mapping.InterestLevel_ID WHERE Lead_Status_Id = CPD.LeadStatus_Id and Interest_level_DelStatus=0)
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE 
    (CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%'' 
    OR LTRIM(RTRIM(CPD.AdharNumber)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''                                     
    OR CPD.AdharNumber LIKE REPLACE(''%'' + @SearchTerm + ''%'', ''-'', '''')                                    
    OR LTRIM(RTRIM(CC.Candidate_Mob1)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%''                                       
    OR LTRIM(RTRIM(CC.Candidate_Email)) LIKE ''%'' + LTRIM(RTRIM(@SearchTerm)) + ''%'' 
    OR LTRIM(RTRIM(@SearchTerm)) = '''')       
    --AND (CPD.LeadStatus_Id = @ActiveStatus OR CPD.ApplicationStatus NOT IN (''rejected'',''Pending''))
    AND (CPD.LeadStatus_Id =@ActiveStatus or @ActiveStatus=0)

        --AND (CPD.LeadStatus_Id = @ActiveStatus)

    --AND (CPD.ApplicationStatus NOT IN (''rejected'',''Pending''))
    --AND ((ISNULL(CPD.LeadStatus_Id,0) NOT IN (SELECT LSM.Lead_Status_Id FROM Tbl_Lead_Status_Master LSM WHERE LSM.Lead_Status_Name IN (''Move to Application'',''Rejected'') AND LSM.Lead_Status_DelStatus = 0)))
    --AND (CPD.ApplicationStatus  IN (''Lead''))
    --or(CPD.ApplicationStatus!=''Pending'')  
    -- or CPD.ApplicationStatus!=''submited''
    --or (CPD.ApplicationStatus!=''Lead'')
--AND (
--    (@ActiveStatus = ''2'' AND CPD.ApplicationStatus = ''rejected'')                              
--    OR (@ActiveStatus = ''1'' AND (CPD.ApplicationStatus = ''Pending'' OR CPD.ApplicationStatus = ''pending'' OR CPD.ApplicationStatus = ''submited''))                                       
--    OR (@ActiveStatus = ''9'' AND CPD.ApplicationStatus = ''Lead'')
--) 
AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)              
AND (
    (@Startdate = '''' AND @Enddate = '''')              
    OR (@Startdate = '''' AND @Enddate <> '''' AND RegDate < @Enddate)              
    OR (@Startdate <> '''' AND @Enddate = '''' AND RegDate > @Startdate)              
    OR (RegDate BETWEEN @Startdate AND @Enddate)              
)
AND ((TRIM(CPD.Source_name) = (SELECT TRIM(SourceName) from Tbl_SourceInfo where SourceID = @SourceName)) OR (@SourceName = 0))
--AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
   --AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
   --        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
   --        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                   
                                  
                                  
    end    
    -------------------for lead status filter else end
    end
    if @flag =1
    begin

    (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,   
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
N.Nationality as Nationality,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department   ,                                                                               
  LM.Lead_Status_Id   ,
    il.Interest_level_Name
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id 

left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
 and ( CPD.ApplicationStatus=''Lead'')                                        
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))  
and                                  
(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')   

   --AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
   --        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
   --        AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') 
 )
)                                  
                   
 ORDER BY  CPD.Candidate_Id asc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 

    end
     
                                                    
        if @flag=2
        begin
        (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,   
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
N.Nationality as Nationality,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department   ,                                                                               
                    LM.Lead_Status_Id     ,
                        il.Interest_level_Name
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id 

left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id 
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
and ( CPD.ApplicationStatus=''Lead'')               
and                                  
(FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate())) 
and ((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 ) 
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
        end
                                      
                                      
                                      
                                      
                                     
                                      
                                      
                                      
    end                                
        if @flag=3
        begin
        (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,    
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
CPD.New_Admission_Id as AdmnID,
N.Nationality as Nationality,
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department ,
      LM.Lead_Status_Id     ,
                        il.Interest_level_Name
                                                                            
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as 
  FD on FD.Candidate_Id=CPD.Candidate_Id 
  LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id

 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
             and ( CPD.ApplicationStatus=''Lead'') 
and                                  
   m.status=''Hold''  
   and ((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 ) 
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 --And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND (@FollowUpStatus = ''All'' OR FD.Respond_Type = @FollowUpStatus OR FD.Respond_Type IS NULL) 
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
        end
                                            
             if @flag=4
             begin
             (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,    
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
N.Nationality as Nationality,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department  ,
      LM.Lead_Status_Id     ,
                        il.Interest_level_Name
                                                                            
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
  LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                             
and                                  
  CPD.ApplicationStatus=''rejected'' 
   and ((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
             end
            if @flag=5
  begin
                                      
(SELECT distinct   CPD.Candidate_Id as ID, CPD.CounselorEmployee_id,                                              
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                        
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                                                                                          
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,     
N.Nationality as Nationality,
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                  
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,         
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                     
                                                  
CC.Candidate_ContAddress as Address,                                                             
CC.Candidate_Mob1 as MobileNumber,                                                        
CC.Candidate_Email as EmailID  ,         
SUBSTRING((SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) )),      
CHARINDEX(''Course Opted :'', (SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))),       
CHARINDEX('', Nationality:'',(SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))))as optedProgramme,      
      
      
CPD.Scolorship_Remark as Remark    ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,                                                                
                                                              
                                                                
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department                                 
                                                                             
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                   
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id   
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id              
                                      
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                       
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                                       
                                         
and CPD.ApplicationStatus=''Lead''            
and                                  
CPD.Agent_ID is not null and                               
((CPD.Agent_ID=@counselorid  and CPD.Agent_ID!=''''  and CPD.Agent_ID!=''0'' ) or  @counselorid=0)              
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
   AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
           AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id asc,RegDatetime desc                                      
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                      
end                                             
       if @flag=6
        begin
        (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,   
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
N.Nationality as Nationality,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department                                                                                  
                                                                            
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id 

left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id 
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                      
and CPD.ApplicationStatus=''Lead''              
and                                  
(FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate())) 
and ((CPD.Agent_ID=@counselorid  and CPD.Agent_ID!=''''  and CPD.Agent_ID!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
        end                                
               if @flag=7
        begin
        (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,    
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
CPD.New_Admission_Id as AdmnID,
N.Nationality as Nationality,
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department                                                                                  
                                                                            
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
and CPD.ApplicationStatus=''Lead''   
and                                  
   m.status=''Hold''  
   and ((CPD.Agent_ID=@counselorid  and CPD.Agent_ID!=''''  and CPD.Agent_ID!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
        end                     
              if @flag=8
             begin
             (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,    
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
N.Nationality as Nationality,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department                                                                                  
                                                                            
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
             
and                                  
  CPD.ApplicationStatus=''rejected'' 
   and ((CPD.Agent_ID=@counselorid  and CPD.Agent_ID!=''''  and CPD.Agent_ID!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 ) 
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
             end     
                if @flag=10
        begin
        (SELECT distinct   CPD.Candidate_Id as ID,                                               
CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
(convert(date,RegDate,105)) as RegDate,                                       
RegDate as RegDatetime,                                                       
CPD.CounselorCampus,                                                        
CPD.TypeOfStudent,CPD.Active,                              
CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
CPD.Candidate_Dob as DOB,   
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
N.Nationality as Nationality,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                                                                                
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                          
CC.Candidate_Email as EmailID  ,                      
CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type  ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department                                                                                  
                                                                            
                                                                 
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id 

left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id  
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id 
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
 where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
and CPD.ApplicationStatus=''Lead'' 
 
and                                  
CPD.RegDate=GETDATE() 
and ((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 
and (              
  (@Startdate='''' and @Enddate ='''')              
  or              
  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
  or              
  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
  or              
  (RegDate between @Startdate and @Enddate )              
 )
 And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )
)                                  
              
                                      
                                  
                                      
                                        
 ORDER BY  CPD.Candidate_Id desc,RegDatetime desc                         
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
        end    
                            

------Individual count click--------------------
IF @flag = 200
BEGIN
    -- Get the total count before pagination
    SELECT @TotalCount = COUNT(DISTINCT CPD.Candidate_Id)
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
    LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
    EC.Employee_Id = @counselorid
    AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE) and CPD.ApplicationStatus!=''Pending'' and CPD.ApplicationStatus!=''rejected''
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
    
    AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
;

    -- Get paginated data with total count
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(DATE, RegDate, 105) AS RegDate,
        RegDate AS RegDatetime,
        CPD.CounselorCampus,
        CPD.TypeOfStudent,
        CPD.Active,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.Candidate_Fname,
        CPD.AdharNumber,
        CPD.Candidate_Dob AS DOB,
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,
        CPD.ApplicationStage AS Stage,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id)
        END AS PageName,
        CC.Candidate_idNo AS IdentificationNumber,
        CC.Candidate_ContAddress AS Address,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,
        CPD.Scolorship_Remark AS Remark,
        CPD.Source_name,
        CPD.Source_name AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified''
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)
        END AS Department,
        il.Interest_level_Name,
        LM.Lead_Status_Name AS LeadStatus, 
        LM.Lead_Status_Id ,
        @TotalCount AS TotalRecords
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
    LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type
        FROM Tbl_FollowUpLead_Detail
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)
            FROM Tbl_FollowUpLead_Detail
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
    EC.Employee_Id = @counselorid
    AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE) and CPD.ApplicationStatus!=''Pending'' and CPD.ApplicationStatus!=''rejected''
   
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )

        AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))

    ORDER BY RegDatetime DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END

 IF @flag = 201
BEGIN
    -- Get the total count before pagination
    SELECT @TotalCount = COUNT(DISTINCT CPD.Candidate_Id)
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
    CPD.CounselorEmployee_id = @counselorid
    AND CPD.ApplicationStatus NOT IN (''Pending'', ''rejected'') 
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
   AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
;

    -- Get paginated data with total count
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(DATE, RegDate, 105) AS RegDate,
        RegDate AS RegDatetime,
        CPD.CounselorCampus,
        CPD.TypeOfStudent,
        CPD.Active,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.Candidate_Fname,
        CPD.AdharNumber,
        CPD.Candidate_Dob AS DOB,
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,
        CPD.ApplicationStage AS Stage,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id)
        END AS PageName,
        CC.Candidate_idNo AS IdentificationNumber,
        CC.Candidate_ContAddress AS Address,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,
        CPD.Scolorship_Remark AS Remark,
        CPD.Source_name,
        CPD.Source_name AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified''
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)
        END AS Department,
        il.Interest_level_Name,
        LM.Lead_Status_Name AS LeadStatus, 
        LM.Lead_Status_Id ,
        @TotalCount AS TotalRecords
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
     LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
   
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type
        FROM Tbl_FollowUpLead_Detail
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)
            FROM Tbl_FollowUpLead_Detail
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
    CPD.CounselorEmployee_id = @counselorid
    AND CPD.ApplicationStatus NOT IN (''Pending'', ''rejected'') 
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
    AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
    
      AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
           AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
   ORDER BY RegDatetime DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END

                       IF @flag = 202
BEGIN
    -- Get the total count before pagination
    SELECT @TotalCount = COUNT(DISTINCT CPD.Candidate_Id)
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
     LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
   
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
    CPD.CounselorEmployee_id = @counselorid
    AND CPD.ApplicationStatus NOT IN (''Pending'', ''rejected'')
     AND (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate())) and (CPD.ApplicationStatus=''Lead'')
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )

      AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
           AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
   AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
;

    -- Get paginated data with total count
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(DATE, RegDate, 105) AS RegDate,
        RegDate AS RegDatetime,
        CPD.CounselorCampus,
        CPD.TypeOfStudent,
        CPD.Active,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.Candidate_Fname,
        CPD.AdharNumber,
        CPD.Candidate_Dob AS DOB,
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,
        CPD.ApplicationStage AS Stage,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id)
        END AS PageName,
        CC.Candidate_idNo AS IdentificationNumber,
        CC.Candidate_ContAddress AS Address,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,
        CPD.Scolorship_Remark AS Remark,
        CPD.Source_name,
        CPD.Source_name AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified''
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)
        END AS Department,
         il.Interest_level_Name,
        LM.Lead_Status_Name AS LeadStatus, 
        LM.Lead_Status_Id ,
        @TotalCount AS TotalRecords
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
     LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
   
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type
        FROM Tbl_FollowUpLead_Detail
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)
            FROM Tbl_FollowUpLead_Detail
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
    EC.Employee_Id = @counselorid
    AND (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate())) and (cpd.ApplicationStatus=''Lead'')
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    
          AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
           AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
    AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))

    ORDER BY RegDatetime DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END
---------------------------------------------   

IF @flag = 301
BEGIN
    -- Ensure @FacultyTable and @ProgrammeTable are populated
    -- Debugging: Check the contents of @FacultyTable and @ProgrammeTable
    -- SELECT * FROM @FacultyTable;
    -- SELECT * FROM @ProgrammeTable;

    SELECT DISTINCT
        CPD.Candidate_Id AS ID,                                               
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
        CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
        CPD.RegDate AS RegDatetime,                                                       
        CPD.CounselorCampus,                                                         
        CPD.TypeOfStudent,
        CPD.Active,                                                                                          
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
        CPD.Candidate_Fname,
        CPD.AdharNumber,                                                                                                      
        CPD.Candidate_Dob AS DOB,       
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,                                            
        CPD.ApplicationStage AS Stage,                                            
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
            ELSE ''Moved To Enquiry'' 
        END AS ApplicationStatus,                                                                        
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
        END AS PageName,    
        CC.Candidate_idNo AS IdentificationNumber,                                                                                         
        CC.Candidate_ContAddress AS Address,                                                                                               
        CC.Candidate_Mob1 AS MobileNumber,                                                                                            
        CC.Candidate_Email AS EmailID,           
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
        CPD.Scolorship_Remark AS Remark,                  
        CPD.Source_name, 
        CPD.SourceofInformation AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
        END AS Department,  
        il.Interest_level_Name,
        LM.Lead_Status_Name AS LeadStatus, 
        LM.Lead_Status_Id 
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
    LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id 
    LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
   -- LEFT JOIN Tbl_FollowUpLead_Detail F ON F.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
    WHERE (FD.Next_Date IS NULL OR FD.Next_Date <= CONVERT(DATE, GETDATE()))
        AND CPD.ApplicationStatus = ''Lead''
        AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable) 
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
            OR NA.Course_Level_Id = 0
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
            OR NA.Department_Id = 0
        )  AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    ORDER BY RegDatetime DESC 
    OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END

IF @flag = 302
BEGIN
   
    SELECT DISTINCT
        CPD.Candidate_Id AS ID,                                               
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
        CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
        CPD.RegDate AS RegDatetime,                                                       
        CPD.CounselorCampus,                                                         
        CPD.TypeOfStudent,
        CPD.Active,                                                                                          
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
        CPD.Candidate_Fname,
        CPD.AdharNumber,                                                                                                      
        CPD.Candidate_Dob AS DOB,       
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,                                            
        CPD.ApplicationStage AS Stage,                                            
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
            ELSE ''Moved To Enquiry'' 
        END AS ApplicationStatus,                                                                        
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
        END AS PageName,    
        CC.Candidate_idNo AS IdentificationNumber,                                                                                         
        CC.Candidate_ContAddress AS Address,                                                                                               
        CC.Candidate_Mob1 AS MobileNumber,                                                                                            
        CC.Candidate_Email AS EmailID,           
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
        CPD.Scolorship_Remark AS Remark,                  
        CPD.Source_name, 
        CPD.SourceofInformation AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
        END AS Department,  
        il.Interest_level_Name,
        LM.Lead_Status_Name AS LeadStatus, 
        LM.Lead_Status_Id 
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
    LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
    LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
    LEFT JOIN Tbl_FollowUpLead_Detail F ON F.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
    WHERE  (CPD.CounselorEmployee_id = '''' OR CPD.CounselorEmployee_id = 0)
            AND CPD.Moved_id IS NULL
           AND CPD.ApplicationStatus = ''Lead''
     
        AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable) 
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
            OR NA.Course_Level_Id = 0
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
            OR NA.Department_Id = 0
        )  AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    ORDER BY RegDatetime DESC 
    OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END



  IF @flag = 300

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE     CPD.ApplicationStatus NOT IN (''Pending'', ''Rejected'')
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END


  IF @flag = 303

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE    CPD.ApplicationStatus = ''Lead''
           AND m.status = ''Hold''
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END



 
  IF @flag = 304

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE    M.status = ''Hold''
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END

 IF @flag = 309

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE    CPD.ApplicationStatus = ''rejected''
           AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
   

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END


 IF @flag = 350

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE    CPD.ApplicationStatus=''Lead'' 
and  (CounselorEmployee_id=@counselorid or @counselorid=0)
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
   

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END


 IF @flag = 351

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE   (fd.Next_Date IS NULL OR fd.Next_Date <= CONVERT(DATE, GETDATE()))
           AND cpd.ApplicationStatus = ''Lead''
           AND (CounselorEmployee_id=@counselorid or @counselorid=0)
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END
  IF @flag = 352

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
 left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id  
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE     CPD.ApplicationStatus = ''Lead''
           AND m.status = ''Hold''
             AND (CounselorEmployee_id=@counselorid or @counselorid=0)
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
   

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END


 IF @flag = 353

  BEGIN                                
 
SELECT DISTINCT
    CPD.Candidate_Id AS ID,                                               
    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,                                                         
    CONVERT(DATE, CPD.RegDate, 105) AS RegDate,                                       
    CPD.RegDate AS RegDatetime,                                                       
    CPD.CounselorCampus,                                                         
    CPD.TypeOfStudent,
    CPD.Active,                                                                                          
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,                                                                                    
    CPD.Candidate_Fname,
    CPD.AdharNumber,                                                                                                      
    CPD.Candidate_Dob AS DOB,       
    N.Nationality AS Nationality,
    CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
    CPD.New_Admission_Id AS AdmnID,                                            
    CPD.ApplicationStage AS Stage,                                            
    CASE 
        WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead'' 
        WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark) 
        ELSE ''Moved To Enquiry'' 
    END AS ApplicationStatus,                                                                        
    CASE 
        WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''  
        ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
    END AS PageName,    
    CC.Candidate_idNo AS IdentificationNumber,                                                                                         
    CC.Candidate_ContAddress AS Address,                                                                                               
    CC.Candidate_Mob1 AS MobileNumber,                                                                                            
    CC.Candidate_Email AS EmailID,           
    SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,          
    CPD.Scolorship_Remark AS Remark,                  
    CPD.Source_name, 
    CPD.SourceofInformation AS SourceofInformation,
    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
    FD.Respond_Type,
    CASE 
        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)  
    END AS Department,  
    il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id 
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
 left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id  
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )
LEFT JOIN (
    SELECT Candidate_Id, Next_Date, Respond_Type 
    FROM Tbl_FollowUpLead_Detail 
    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
    AND Follow_Up_Detail_Id IN (
        SELECT MAX(Follow_Up_Detail_Id)  
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        GROUP BY Candidate_Id
    ) 
    AND Action_Taken = 0
) AS FD ON FD.Candidate_Id = CPD.Candidate_Id                              
WHERE    CPD.ApplicationStatus = ''rejected''
           
             AND (CounselorEmployee_id=@counselorid or @counselorid=0)
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )

  ORDER BY  RegDatetime desc 
       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)                                   
        
 

 END


 IF @flag = 400
BEGIN 
    SELECT @TotalCount = COUNT(DISTINCT CPD.Candidate_Id)
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE 
      CAST(RegDate AS DATE) = CAST(GETDATE() AS DATE)
         AND ApplicationStatus NOT IN (''Pending'', ''Rejected'')
         AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
    
    AND (CounselorEmployee_id=@counselorid or @counselorid=0)
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
;

    -- Get paginated data with total count
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(DATE, RegDate, 105) AS RegDate,
        RegDate AS RegDatetime,
        CPD.CounselorCampus,
        CPD.TypeOfStudent,
        CPD.Active,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.Candidate_Fname,
        CPD.AdharNumber,
        CPD.Candidate_Dob AS DOB,
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,
        CPD.ApplicationStage AS Stage,
        il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id ,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id)
        END AS PageName,
        CC.Candidate_idNo AS IdentificationNumber,
        CC.Candidate_ContAddress AS Address,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,
        CPD.Scolorship_Remark AS Remark,
        CPD.Source_name,
        CPD.Source_name AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified''
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)
        END AS Department,
        @TotalCount AS TotalRecords
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
 left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id  
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type
        FROM Tbl_FollowUpLead_Detail
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)
            FROM Tbl_FollowUpLead_Detail
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE  
      EC.Employee_Id = @counselorid
    AND CAST(CPD.RegDate AS DATE) = CAST(GETDATE() AS DATE) and CPD.ApplicationStatus!=''Pending'' and CPD.ApplicationStatus!=''rejected''
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
     AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )

     AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))

    ORDER BY RegDatetime DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END



IF @flag = 401
BEGIN 
    SELECT @TotalCount = COUNT(DISTINCT CPD.Candidate_Id)
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
    LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
 left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id  
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE   CPD.ApplicationStatus NOT IN (''Pending'', ''rejected'') 
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
     
    AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')

          AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
;

    -- Get paginated data with total count
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(DATE, RegDate, 105) AS RegDate,
        RegDate AS RegDatetime,
        CPD.CounselorCampus,
        CPD.TypeOfStudent,
        CPD.Active,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.Candidate_Fname,
        CPD.AdharNumber,
        CPD.Candidate_Dob AS DOB,
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,
        CPD.ApplicationStage AS Stage,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
         CPD.ApplicationStage AS Stage,
        il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id ,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id)
        END AS PageName,
        CC.Candidate_idNo AS IdentificationNumber,
        CC.Candidate_ContAddress AS Address,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,
        CPD.Scolorship_Remark AS Remark,
        CPD.Source_name,
        CPD.Source_name AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified''
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)
        END AS Department,
        @TotalCount AS TotalRecords
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
 left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id  
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type
        FROM Tbl_FollowUpLead_Detail
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)
            FROM Tbl_FollowUpLead_Detail
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE  

       CPD.ApplicationStatus NOT IN (''Pending'', ''rejected'') AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
   AND (CounselorEmployee_id=@counselorid or @counselorid=0)
        
    AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
    and CPD.ApplicationStatus=''Lead''
     AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )

     AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))

    ORDER BY RegDatetime DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END


IF @flag = 402
BEGIN 
    SELECT @TotalCount = COUNT(DISTINCT CPD.Candidate_Id)
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type 
        FROM Tbl_FollowUpLead_Detail 
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)  
            FROM Tbl_FollowUpLead_Detail 
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE ApplicationStatus NOT IN (''Pending'', ''Rejected'')
   AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
   and CPD.ApplicationStatus=''Lead''
    AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
    AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )
    
    AND (CounselorEmployee_id=@counselorid or @counselorid=0)
          AND (
        NOT EXISTS (SELECT 1 FROM @FacultyTable) 
        OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) 
        OR NA.Course_Level_Id = 0
    )
    AND (
        NOT EXISTS (SELECT 1 FROM @ProgrammeTable) 
        OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) 
        OR NA.Department_Id = 0
    ) AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
;

    -- Get paginated data with total count
    SELECT DISTINCT 
        CPD.Candidate_Id AS ID,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        CONVERT(DATE, RegDate, 105) AS RegDate,
        RegDate AS RegDatetime,
        CPD.CounselorCampus,
        CPD.TypeOfStudent,
        CPD.Active,
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.Candidate_Fname,
        CPD.AdharNumber,
        CPD.Candidate_Dob AS DOB,
        N.Nationality AS Nationality,
        CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate,
        CPD.New_Admission_Id AS AdmnID,
        CPD.ApplicationStage AS Stage,
         CPD.ApplicationStage AS Stage,
        il.Interest_level_Name,
    LM.Lead_Status_Name AS LeadStatus, 
    LM.Lead_Status_Id ,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id)
        END AS PageName,
        CC.Candidate_idNo AS IdentificationNumber,
        CC.Candidate_ContAddress AS Address,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        SUBSTRING(CPD.Scolorship_Remark, CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark)) AS optedProgramme,
        CPD.Scolorship_Remark AS Remark,
        CPD.Source_name,
        CPD.Source_name AS SourceofInformation,
        ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        FD.Respond_Type,
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified''
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id)
        END AS Department,
        @TotalCount AS TotalRecords
    FROM Tbl_Lead_Personal_Det CPD
    LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
    LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT)
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
 left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id  
LEFT join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= (SELECT TOP 1 InterestLevel_ID FROM Tbl_Interest_level_Mapping WHERE Lead_Status_Id = CPD.LeadStatus_Id )

    LEFT JOIN (
        SELECT Candidate_Id, Next_Date, Respond_Type
        FROM Tbl_FollowUpLead_Detail
        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        AND Follow_Up_Detail_Id IN (
            SELECT MAX(Follow_Up_Detail_Id)
            FROM Tbl_FollowUpLead_Detail
            WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
            GROUP BY Candidate_Id
        ) 
        AND Action_Taken = 0
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
   WHERE  
      ApplicationStatus NOT IN (''Pending'', ''Rejected'')
      AND (CounselorEmployee_id=@counselorid or @counselorid=0)
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
    AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
    and CPD.ApplicationStatus=''Lead''
     AND (
        (@Startdate IS NULL OR @Startdate = '''') 
        OR (@Enddate IS NULL OR @Enddate = '''') 
        OR (CAST(RegDate AS DATE) BETWEEN CAST(@Startdate AS DATE) AND CAST(@Enddate AS DATE))
    )

     AND ((@SourceName <> 0 AND CPD.Page_Id = @SourceName) OR (@SourceName = 0))
    AND ((@SourceType = ''1'' AND CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' AND CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
    AND ((@FollowUpStatus <> ''All'' AND FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
    AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))

    ORDER BY RegDatetime DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END
--ALTER procedure [dbo].[SP_Get_Mahsa_Lead_List_Adv_Search]-- 1,100,'''',''0'',''9'',''True''                            
--(                                                        
--@CurrentPage int=null ,                                                                       
--@PageSize int=null   ,                                                                    
--@SearchTerm varchar(100)='''',                                                    
                                                  
-- @counselorid bigint=0,                                              
--@ActiveStatus varchar(50)='''',                                      
--@allocated varchar(100)='''',              
--@Startdate datetime ='''',              
--@Enddate datetime = ''''              
--)                                                                                                 
--AS                                                                                              
--BEGIN                                                         
--SET NOCOUNT ON                                                                            
--    DECLARE @Unspecified  nvarchar(max) set  @Unspecified=''Unspecified''                                                         
--    DECLARE @Admin  nvarchar(max) set  @Admin=''Admin''                                                                 
--    DECLARE @SqlString nvarchar(max)                                                                        
--    Declare @SqlStringWithout nvarchar(max)                                                                            
--    Declare @UpperBand int                                                                            
--    Declare @LowerBand int                                      
                                                                         
--    SET @LowerBand  = (@CurrentPage -                                                        
--     1) * @PageSize                                                                            
--    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                                           
--  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                                    
--  DROP TABLE #TEMP1;                                              
--    IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                                    
--  DROP TABLE #TEMP2;                                                   
--    if @allocated=''True''                                  
-- begin                                  
--(SELECT distinct   CPD.Candidate_Id as ID, CPD.CounselorEmployee_id,                                              
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                        
--(convert(date,RegDate,105)) as RegDate,                                       
--RegDate as RegDatetime,                                                       
--CPD.CounselorCampus,                                                        
--CPD.TypeOfStudent,CPD.Active,                                                                                          
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
--CPD.Candidate_Dob as DOB,                                                                                           
--CPD.New_Admission_Id as AdmnID,                                            
--CPD.ApplicationStage as Stage,                                  
--case when                                 
--CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,         
--case when                                 
--CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
--CC.Candidate_idNo as IdentificationNumber ,                                                                     
                                                  
--CC.Candidate_ContAddress as Address,                                                             
--CC.Candidate_Mob1 as MobileNumber,                                                        
--CC.Candidate_Email as EmailID  ,         
--SUBSTRING((SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) )),      
--CHARINDEX(''Course Opted :'', (SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))),       
--CHARINDEX('', Nationality:'',(SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ))))as optedProgramme,      
      
      
--CPD.Scolorship_Remark as Remark    ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
--,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type          
                                                                                
                                              
                                                                             
--FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                   
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                     
--inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id            
--left Join (                              
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id              
                                      
-- where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                       
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
-- or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                                       
                                          
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))              
--and                                  
--CPD.CounselorEmployee_id is not null and                               
--((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0)              
--and (              
--  (@Startdate='''' and @Enddate ='''')              
--  or              
--  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
--  or              
--  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
--  or              
--  (RegDate between @Startdate and @Enddate )              
-- )              
--)                                  
                                      
                                  
                                      
                                        
-- ORDER BY  CPD.Candidate_Id asc,RegDatetime desc                                      
--       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
--    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                      
--end                                             
--          else            if @allocated=''False''                            
--    begin                                  
--    (SELECT distinct   CPD.Candidate_Id as ID,                                               
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                   
--(convert(date,RegDate,105)) as RegDate,                                       
--RegDate as RegDatetime,                                                       
--CPD.CounselorCampus,                                                        
--CPD.TypeOfStudent,CPD.Active,                              
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
--CPD.Candidate_Dob as DOB,                                                                                           
--CPD.New_Admission_Id as AdmnID,                                            
--CPD.ApplicationStage as Stage,                                           
--case when                                 
--CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,     
--case when                                 
--CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing'' when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
--CC.Candidate_idNo as IdentificationNumber ,                                                                                
--SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,                                                                                           
--CC.Candidate_ContAddress as Address,                                                                                              
--CC.Candidate_Mob1 as MobileNumber,                          
--CC.Candidate_Email as EmailID  ,                      
--CPD.Scolorship_Remark as Remark ,CPD.Source_name     ,CPD.Source_name as  SourceofInformation                
--,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type                                                                                
                                                                            
                                                                 
--FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                                                                             
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                     
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id    
--left Join (                              
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
-- where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                    
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
-- or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                            
                                          
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                                       
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))               
--and                                  
--(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')             
--and (              
--  (@Startdate='''' and @Enddate ='''')              
--  or              
--  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
--  or              
--  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
--  or              
--  (RegDate between @Startdate and @Enddate )              
-- )              
--)                                  
              
                                      
                                  
                                      
                                        
-- ORDER BY  CPD.Candidate_Id asc,RegDatetime desc                         
--       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
--    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                   
                                  
                                  
--    end                                  
                                    
                              
--    else                          
                           
--      begin                                  
--    (SELECT distinct   CPD.Candidate_Id as ID,                                               
--CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                                        
--(convert(date,RegDate,105)) as RegDate,                                       
--RegDate as RegDatetime,                                                       
--CPD.CounselorCampus,                                                        
--CPD.TypeOfStudent,CPD.Active,                                                                                          
--CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName,                                                                                    
--CPD.Candidate_Fname,CPD.AdharNumber,                                                                                                      
--CPD.Candidate_Dob as DOB,                                                                                    
--CPD.New_Admission_Id as AdmnID,                                            
--CPD.ApplicationStage as Stage,                                           
--case when                                 
--CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,                                                                        
--case when                                 
--CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing''  when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
--CC.Candidate_idNo as IdentificationNumber ,                 
                                                                                          
--CC.Candidate_ContAddress as Address,                                                                                              
--CC.Candidate_Mob1 as MobileNumber,                                                                                            
--CC.Candidate_Email as EmailID     ,           
--SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,          
--CPD.Scolorship_Remark as Remark   ,                  
--CPD.Source_name,CPD.Source_name as  SourceofInformation              
--,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type               
                                                                                
                                                                            
                                               
--FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                            
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                     
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id                
--left Join (                              
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
          
                                      
-- where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                       
-- or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
-- or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
-- or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
-- or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                                       
                                          
-- and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                              
-- or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')) and (                          
--CPD.CounselorEmployee_id=@counselorid or @counselorid=0)              
--and (              
--  (@Startdate='''' and @Enddate ='''')              
--  or              
--  (@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)              
--  or              
--  (@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)              
--  or              
--  (RegDate between @Startdate and @Enddate )              
-- )              
--)                                  
                                      
                                  
                                      
                                        
-- ORDER BY  RegDatetime desc                   
--       OFFSET @PageSize * (@CurrentPage - 1) ROWS                                      
--    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                                   
                                  
                                  
--    end                                
    
     
                                                    
                                      
                                      
                                      
                                      
                                      
                                     
                                      
                                      
                                      
--    end   

    ')
END