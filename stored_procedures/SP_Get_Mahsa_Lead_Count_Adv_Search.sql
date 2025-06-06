IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Mahsa_Lead_Count_Adv_Search]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Get_Mahsa_Lead_Count_Adv_Search] --1,100,'''',''0'',''1'',''False'','''',''''           
--[SP_Get_Mahsa_Lead_Count_Adv_Search] 0,0,'''',0,''9'',''All'',NULL,null          
(
--Declare
@CurrentPage int=null ,                                                     
@PageSize int=null   ,                                                  
@SearchTerm varchar(100)='''',   
@counselorid bigint=0,                            
@ActiveStatus varchar(50)='''',                    
@allocated varchar(100)='''' ,      
@Startdate datetime ='''',      
@Enddate datetime = '''',
@SourceName Bigint = 0,
@SourceType varchar(100) = ''0'',
@FollowUpStatus varchar(200) = ''All'',
@NextFollowupDate date null,
@flag int=null,
@FacultyId NVARCHAR(255) ,  
@ProgrammeId NVARCHAR(255)  , 
@IntakeId NVARCHAR(255)   

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
    

if @Startdate is null  
 set @Startdate=''''  
if @Enddate is null  
 set @Enddate=''''  
               if @flag=0
               begin
   if @allocated=''True''                
begin                
SELECT SUM(counts) as counts--SUM(counts)as counts                 
from                 
(SELECT count(distinct  CPD.Candidate_Id)as counts                                                            
                                                              
                                                          
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                                                           
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                        

                    
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                       
 and    
((CPD.ApplicationStatus=''rejected'')                       
or( CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'')                    
or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))

--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))     
and                  
CPD.CounselorEmployee_id is not null     
and               
((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 
 AND (NA.Course_Level_Id = ISNULL(@FacultyId, 0) OR ISNULL(@FacultyId, 0) = 0)
AND (NA.Department_Id = ISNULL(@ProgrammeId, 0) OR ISNULL(@ProgrammeId, 0) = 0)
AND (NA.Batch_Id = ISNULL(@IntakeId, 0) OR ISNULL(@IntakeId, 0) = 0)
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
   AND (convert(date,FD.Next_Date) = @NextFollowupDate or @NextFollowupDate is null or @NextFollowupDate ='''' )
                  
)as counts               
                    
                      
                
end                           
else   if @allocated=''False''               
begin           
print ''@allocated - '' + @allocated
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   

where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')            
  AND (NA.Course_Level_Id = ISNULL(@FacultyId, 0) OR ISNULL(@FacultyId, 0) = 0)
AND (NA.Department_Id = ISNULL(@ProgrammeId, 0) OR ISNULL(@ProgrammeId, 0) = 0)
AND (NA.Batch_Id = ISNULL(@IntakeId, 0) OR ISNULL(@IntakeId, 0) = 0)                        
and CPD.ApplicationStatus=''Lead''   
and                  
(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')    
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
)            
              
                    
                
                    
)as counts               
end          
else          
   if(@ActiveStatus=0)       
begin          
SELECT       
--case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                                          
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                                                           
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id 
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
                    
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                       
                          
--AND (CPD.LeadStatus_Id = @ActiveStatus OR @ActiveStatus = 0)
AND (CPD.LeadStatus_Id = @ActiveStatus OR CPD.ApplicationStatus NOT IN (''rejected'',''Pending''))
--AND (CPD.LeadStatus_Id =@ActiveStatus or @ActiveStatus=0)
--AND ((CPD.LeadStatus_Id NOT IN (SELECT LSM.Lead_Status_Id FROM Tbl_Lead_Status_Master LSM WHERE LSM.Lead_Status_Name IN (''Move to Application'',''Rejected'') AND LSM.Lead_Status_DelStatus = 0)))

--AND (CPD.ApplicationStatus  IN (''Lead''))

--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')    
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending''     
--or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))     
and (          
CPD.CounselorEmployee_id=@counselorid or @counselorid=0)          
and (      
(@Startdate='''' and @Enddate ='''')      
or      
(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
or      
(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
or      
(RegDate between @Startdate and @Enddate )      
)
AND ((TRIM(CPD.Source_name) = (SELECT TRIM(SourceName) from Tbl_SourceInfo where SourceID = @SourceName)) OR (@SourceName = 0))
--And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
 AND (convert(date,FD.Next_Date) = @NextFollowupDate or @NextFollowupDate is null or @NextFollowupDate ='''' )
 AND (NA.Course_Level_Id = ISNULL(@FacultyId, 0) OR ISNULL(@FacultyId, 0) = 0)
AND (NA.Department_Id = ISNULL(@ProgrammeId, 0) OR ISNULL(@ProgrammeId, 0) = 0)
--AND (NA.Batch_Id = ISNULL(@IntakeId, 0) OR ISNULL(@IntakeId, 0) = 0)
)                   
                    
                
                    
)as counts              
          
          
          
                    
end 
else  -----------for lead status filter
begin    
print ''Adv search count''
SELECT       
--case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                                          
                                                           
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
left join Tbl_Lead_Status_Master LM on LM.Lead_Status_Id=CPD.LeadStatus_Id
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
                          
--AND (CPD.LeadStatus_Id = @ActiveStatus OR @ActiveStatus = 0)
AND (CPD.LeadStatus_Id = @ActiveStatus )--OR CPD.ApplicationStatus NOT IN (''rejected'',''Pending''))
--AND (CPD.LeadStatus_Id =@ActiveStatus or @ActiveStatus=0)
--AND ((CPD.LeadStatus_Id NOT IN (SELECT LSM.Lead_Status_Id FROM Tbl_Lead_Status_Master LSM WHERE LSM.Lead_Status_Name IN (''Move to Application'',''Rejected'') AND LSM.Lead_Status_DelStatus = 0)))

--AND (CPD.ApplicationStatus  IN (''Lead''))

--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')    
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending''     
--or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))     
and (          
CPD.CounselorEmployee_id=@counselorid or @counselorid=0)          
and (      
(@Startdate='''' and @Enddate ='''')      
or      
(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
or      
(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
or      
(RegDate between @Startdate and @Enddate )      
)
AND ((TRIM(CPD.Source_name) = (SELECT TRIM(SourceName) from Tbl_SourceInfo where SourceID = @SourceName)) OR (@SourceName = 0))
--And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
AND ((CONVERT(DATE, FD.Next_Date) = @NextFollowupDate) OR (@NextFollowupDate IS NULL) OR (@NextFollowupDate = ''''))
 AND (NA.Course_Level_Id = ISNULL(@FacultyId, 0) OR ISNULL(@FacultyId, 0) = 0)
AND (NA.Department_Id = ISNULL(@ProgrammeId, 0) OR ISNULL(@ProgrammeId, 0) = 0)
--AND (NA.Batch_Id = ISNULL(@IntakeId, 0) OR ISNULL(@IntakeId, 0) = 0)
)                   
                    
                
                    
)as counts              
          
          
          
                    
end 
-----------lead status filter end
end
if @flag=1
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
                    
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')            
  and ( CPD.ApplicationStatus=''Lead'')                          
--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))

and                  
(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')    
and (      
(@Startdate='''' and @Enddate ='''')      
or      
(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
or      
(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
or      
(RegDate between @Startdate and @Enddate ) 
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count                              
              
                                      
                                  
                                      

end
if @flag=2
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
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
) AS FD on FD.Candidate_Id=CPD.Candidate_Id
                    
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')            
     and ( CPD.ApplicationStatus=''Lead'')                         
--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))

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
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end   
if @flag=3
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')            
                          
and CPD.ApplicationStatus=''Lead''   
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
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end
if @flag=4
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')    
and cpd.ApplicationStatus=''rejected''
and ((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0) 
and (      
(@Startdate='''' and @Enddate ='''')      
or      
(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
or      
(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
or      
(RegDate between @Startdate and @Enddate ) 
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end
if @flag=5
               begin
                   
SELECT SUM(counts) as counts--SUM(counts)as counts                 
from                 
(SELECT count(distinct  CPD.Candidate_Id)as counts                                                            
                                                              
                                                          
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                                                           
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
                    
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                       
                          
and CPD.ApplicationStatus=''Lead''  
and                  
CPD.Agent_ID is not null     
and               
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
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))     
   AND (convert(date,FD.Next_Date) = @NextFollowupDate or @NextFollowupDate is null or @NextFollowupDate ='''' )
                  
)as counts               
                    
                      
                
end 
if @flag=6
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
                    
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
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end 
if @flag=7
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
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
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end
if @flag=8
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
left join Tbl_LeadStatus_Change_by_Marketing m on m.Candidate_Id=CPD.Candidate_Id
where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')    
and cpd.ApplicationStatus=''rejected''
and ((CPD.Agent_ID=@counselorid  and CPD.Agent_ID!=''''  and CPD.Agent_ID!=''0'' ) or  @counselorid=0) 
and (      
(@Startdate='''' and @Enddate ='''')      
or      
(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
or      
(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
or      
(RegDate between @Startdate and @Enddate ) 
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end
if @flag=10
begin
SELECT       
-- case when SUM(counts) >100 then 100                
--else SUM(counts) end as counts      
SUM(counts)as counts                 
from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id
left join Tbl_FollowUpLead_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
                    
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
And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
)
)            
              
                    
                
                    
)as count
end 
end
                    
                    
           IF(@flag=300)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id 
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = ILM.InterestLevel_ID
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
WHERE CPD.ApplicationStatus NOT IN (''Pending'', ''Rejected'')
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
    ;
           END
                    
                  
                  
                      IF(@flag=301)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
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
  --  LEFT JOIN Tbl_FollowUpLead_Detail F ON F.Candidate_Id = CPD.Candidate_Id
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
WHERE  (FD.Next_Date IS NULL OR FD.Next_Date <= CONVERT(DATE, GETDATE()))
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
    ) AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    );
           END
                
                

                          IF(@flag=302)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id 
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = ILM.InterestLevel_ID
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
WHERE (  CPD.CounselorEmployee_id=0 or CPD.CounselorEmployee_id='''') and
CPD.Moved_id IS NULL
           AND CPD.ApplicationStatus = ''Lead'' AND (
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
           END
                    

                    
                          IF(@flag=303)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id 
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = ILM.InterestLevel_ID
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
           AND m.status = ''Hold'' AND (
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
           END

                    
                          IF(@flag=309)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id 
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = ILM.InterestLevel_ID
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
    )  AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
           END

                              IF(@flag=351)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id 
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = ILM.InterestLevel_ID
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
WHERE     ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' 
AND (fd.Next_Date IS NULL OR fd.Next_Date <= CONVERT(DATE, GETDATE()))
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
    )  AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
           END
            IF(@flag=350)
           BEGIN
           SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id 
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = ILM.InterestLevel_ID
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
WHERE     ApplicationStatus!=''Pending'' and ApplicationStatus!=''rejected'' 
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
    )  AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
           END

            IF @flag = 352

  BEGIN                                
 
  
 SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
FROM Tbl_Lead_Personal_Det CPD
LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id     
LEFT JOIN Tbl_Nationality N ON N.Nationality_Id = TRY_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
LEFT JOIN Tbl_Interest_level_Mapping ILM ON ILM.Lead_Status_Id = CPD.LeadStatus_Id  
LEFT JOIN Tbl_Interest_level_Master IL ON IL.InterestLevel_ID = (
    SELECT TOP 1 InterestLevel_ID 
    FROM Tbl_Interest_level_Mapping 
    WHERE Lead_Status_Id = CPD.LeadStatus_Id 
)
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
WHERE CPD.ApplicationStatus = ''Lead''
  AND M.status = ''Hold''
  AND (CPD.CounselorEmployee_id = @counselorid OR @counselorid = 0)
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
     
     end
         IF @flag = 353

  BEGIN                                
 
  
SELECT COUNT(DISTINCT CPD.Candidate_Id) AS counts
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
    ) AND (
        @SearchTerm IS NULL OR 
        @SearchTerm = '''' OR 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) LIKE ''%'' + @SearchTerm + ''%'' COLLATE Latin1_General_CI_AI
        OR REPLACE(CPD.AdharNumber, ''-'', '''') LIKE ''%'' + REPLACE(@SearchTerm, ''-'', '''') + ''%''
        OR CC.Candidate_Mob1 LIKE ''%'' + @SearchTerm + ''%''
        OR CC.Candidate_Email LIKE ''%'' + @SearchTerm + ''%''
    )
   
   
--------------------------------------------- 






--ALTER procedure [dbo].[SP_Get_Mahsa_Lead_Count_Adv_Search] --1,100,'''',''0'',''1'',''False'','''',''''           
----[SP_Get_Mahsa_Lead_Count_Adv_Search] 0,0,'''',0,''9'',''All'',NULL,null          
--(                                      
--@CurrentPage int=null ,                                                     
--@PageSize int=null   ,                                                  
--@SearchTerm varchar(100)='''',                                  
                                
-- @counselorid bigint=0,                            
--@ActiveStatus varchar(50)='''',                    
--@allocated varchar(100)='''' ,      
--@Startdate datetime ='''',      
--@Enddate datetime = ''''                     
--)                                                                               
--AS                                                                            
--BEGIN                                      
--SET NOCOUNT ON                                                          
--if @Startdate is null  
-- set @Startdate=''''  
--if @Enddate is null  
-- set @Enddate=''''  
                              
--   if @allocated=''True''                
--begin                
--SELECT SUM(counts) as counts--SUM(counts)as counts                 
--from                 
--(SELECT count(distinct  CPD.Candidate_Id)as counts                                                            
                                                              
                                                          
                                                           
--FROM Tbl_Lead_Personal_Det  CPD                                                                          
                                                           
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--inner join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id                
                    
--where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
--or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
--or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
--or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
--or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                       
                          
--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))     
--and                  
--CPD.CounselorEmployee_id is not null     
--and               
--((CPD.CounselorEmployee_id=@counselorid  and CPD.CounselorEmployee_id!=''''  and CPD.CounselorEmployee_id!=''0'' ) or  @counselorid=0)                
--and (      
--(@Startdate='''' and @Enddate ='''')      
--or      
--(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
--or      
--(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
--or      
--(RegDate between @Startdate and @Enddate )      
--)     
     
                    
--)as counts               
                    
                      
                
--end                           
--else   if @allocated=''False''               
--begin                
--SELECT       
---- case when SUM(counts) >100 then 100                
----else SUM(counts) end as counts      
--SUM(counts)as counts                 
--from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                     
                                                           
--FROM Tbl_Lead_Personal_Det  CPD                                                                          
                  
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id                
                    
--where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
--or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
--or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
--or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
--or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')            
                          
--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))    
--and                  
--(CPD.CounselorEmployee_id is  null OR CPD.CounselorEmployee_id='''' or CPD.CounselorEmployee_id=''0'')    
--and (      
--(@Startdate='''' and @Enddate ='''')      
--or      
--(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
--or      
--(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
--or      
--(RegDate between @Startdate and @Enddate )      
--)    
--)            
              
                    
                
                    
--)as counts               
--end          
--else          
          
--begin          
--SELECT       
----case when SUM(counts) >100 then 100                
----else SUM(counts) end as counts      
      
--SUM(counts)as counts                 
--from (    (SELECT count(distinct  CPD.Candidate_Id)as counts                        
                                                          
                                                           
--FROM Tbl_Lead_Personal_Det  CPD                                                                          
                                                           
--left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id                
                    
--where  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                       
--or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                     
--or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                    
--or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                       
--or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                       
                          
--and    
--((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                       
--or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending''     
--or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                      
--or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead''))     
--and (          
--CPD.CounselorEmployee_id=@counselorid or @counselorid=0)          
--and (      
--(@Startdate='''' and @Enddate ='''')      
--or      
--(@Startdate='''' and @Enddate <>'''' and RegDate < @Enddate)      
--or      
--(@Startdate<>'''' and @Enddate ='''' and RegDate > @Startdate)      
--or      
--(RegDate between @Startdate and @Enddate )      
--)    
--)                   
                    
                
                    
--)as counts              
          
          
          
                    
--end      
--end  
                    
                    
                    
                    
               END   
    ')
END
