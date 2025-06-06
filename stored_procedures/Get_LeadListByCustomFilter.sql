IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_LeadListByCustomFilter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_LeadListByCustomFilter] 
    
    @templateid bigint = 0,
    @CurrentPage bigint=0,
    @PageSize bigint=0,
    @SearchTerm varchar(100)='''',                                                  
             
@flag int=0 ,                                   
@counselorid bigint=0,                                            
@ActiveStatus varchar(50)='''',                                    
@allocated varchar(100)='''',            
@Startdate datetime ='''',            
@Enddate datetime = '''',
@SourceName Bigint = 0,
@SourceType varchar(100) = ''0'',
@FollowUpStatus varchar(200) = ''All'',
@NextFollowupDate date = null,
@leadcounsellorid nvarchar(50)='''',
@leadcreatedby bigint=0,
@leadsourceid nvarchar(50)='''',
@leadnationalityid nvarchar(50)='''',
@leadstatusid nvarchar(50)='''',
@interestid nvarchar(50)='''',
@createddatefrom nvarchar(50)=null,
@createddateto nvarchar(50)=null,
@followupdatefrom nvarchar(50)=null,
@followupdateto nvarchar(50)=null,

@FacultyId NVARCHAR(MAX), 
@ProgrammeId NVARCHAR(MAX), 
@IntakeId NVARCHAR(MAX) 

AS
BEGIN

    DECLARE @FacultyTable TABLE (FacultyId INT);
    DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
    DECLARE @IntakeTable TABLE (IntakeId INT);

    INSERT INTO @FacultyTable (FacultyId)
    SELECT value FROM dbo.SplitStringFunction(@FacultyId, '','');

    INSERT INTO @ProgrammeTable (ProgrammeId)
    SELECT value FROM dbo.SplitStringFunction(@ProgrammeId, '','');

    INSERT INTO @IntakeTable (IntakeId)
    SELECT value FROM dbo.SplitStringFunction(@IntakeId, '','');


    if(@templateid=0)
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
N.Nationality as Nationality,
   (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
CPD.New_Admission_Id as AdmnID,                                            
CPD.ApplicationStage as Stage,                                           
case when                                 
CPD.ApplicationStatus=''Lead'' Then ''Lead'' when CPD.ApplicationStatus=''rejected'' Then CONCAT( ''Rejected due to :'',CPD.Reject_remark) else ''Moved To Enquiry'' end  as ApplicationStatus,                                                                        
case when                                 
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing''  when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                 
                                                                                          
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                                                                                            
CC.Candidate_Email as EmailID     ,           
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,          
CPD.Scolorship_Remark as Remark   ,                  
CPD.Source_name, CPD.SourceofInformation as  SourceofInformation              
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type    ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department  ,LM.Lead_Status_Name as LeadStatus ,LM.Lead_Status_Id,
IL.Interest_level_Name
                                                                                
                                                                            
                                               
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                            
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id 
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id     
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
left join Tbl_Lead_Status_Master LM on LM.Lead_Status_Id=CPD.LeadStatus_Id

left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
  left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
  left join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= ILM.InterestLevel_ID
  
     where 
     
  (concat(LTRIM(RTRIM((CPD.Candidate_Fname))),'' '',LTRIM(RTRIM((CPD.Candidate_Lname)))) like concat(''%'', LTRIM(RTRIM(@SearchTerm)) ,''%'' )                                       
 or LTRIM(RTRIM(CPD.AdharNumber)) like ''%''+ LTRIM(RTRIM(@SearchTerm))+''%''                                     
 or (CPD.AdharNumber like replace(CONCAT(''%'',@SearchTerm,''%''),''-'',''''))                                    
 or LTRIM(RTRIM(CC.Candidate_Mob1)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%''                                       
 or LTRIM(RTRIM(CC.Candidate_Email)) like  ''%''+ LTRIM(RTRIM(@SearchTerm)) +''%'' or LTRIM(RTRIM(@SearchTerm))='''')                                       
                                          
 and((@ActiveStatus = ''2'' and CPD.ApplicationStatus=''rejected'')                              
 or(@ActiveStatus = ''1'' and(CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''))                                      
or (@ActiveStatus=''9'' and CPD.ApplicationStatus=''Lead'')) and (                          
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
  And ((@SourceName <> 0 And CPD.Page_Id = @SourceName) OR (@SourceName = 0))
 And ((@SourceType = ''1'' And CPD.Source_name = ''Landing Page'') OR (@SourceType = ''2'' And CPD.Source_name = ''Online Application'') OR (@SourceType = ''0''))
 And ((@FollowUpStatus <> ''All'' And FD.Respond_Type = @FollowUpStatus) OR (@FollowUpStatus = ''All''))
  AND ((convert(date,FD.Next_Date) = @NextFollowupDate) or (@NextFollowupDate is null) or (@NextFollowupDate ='''') )

)                                  
                                      
                                  
                                      
                                        
ORDER BY RegDatetime DESC
OFFSET CASE WHEN @PageSize IS NULL OR @PageSize = 0 OR @CurrentPage IS NULL OR @CurrentPage = 0 THEN 0 
            ELSE @PageSize * (@CurrentPage - 1) 
       END ROWS
FETCH NEXT CASE WHEN @PageSize IS NULL OR @PageSize = 0 OR @CurrentPage IS NULL OR @CurrentPage = 0 THEN 1000000 
                ELSE @PageSize 
           END ROWS ONLY 
OPTION (RECOMPILE);
                                  
       end                            

    
     else
     begin 
    
           SELECT distinct   CPD.Candidate_Id as ID,                                               
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
CPD.Page_Id=0 Then ''Landing'' when CPD.Page_Id is null then ''Landing''  when CPD.Page_Id=0 then ''Landing'' else (select LandingiURL_Name from Tbl_LandingiURL where LandingiURL_Id=CPD.Page_Id) end  as PageName,    
CC.Candidate_idNo as IdentificationNumber ,                 
                                                                                          
CC.Candidate_ContAddress as Address,                                                                                              
CC.Candidate_Mob1 as MobileNumber,                                                                                            
CC.Candidate_Email as EmailID     ,           
SUBSTRING(CPD.Scolorship_Remark,charindex(''Course Opted :'',CPD.Scolorship_Remark) + LEN(''Course Opted :''), LEN(CPD.Scolorship_Remark) ) as optedProgramme,          
CPD.Scolorship_Remark as Remark   ,                  
CPD.Source_name, CPD.SourceofInformation as  SourceofInformation              
,ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type    ,
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                                          
D.Department_Id=NA.Department_Id)  end  as Department  ,LM.Lead_Status_Name as LeadStatus ,LM.Lead_Status_Id,
IL.Interest_level_Name
                                                                                
                                                                            
                                               
FROM Tbl_Lead_Personal_Det  CPD                                                                                            
                            
left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id 
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id

left join Tbl_Employee EC on EC.Employee_Id=CPD.CounselorEmployee_id     
left join Tbl_Nationality N on N.Nationality_Id=try_CAST(CPD.Candidate_Nationality AS BIGINT) 
LEFT JOIN Tbl_LeadStatus_Change_by_Marketing M ON M.Candidate_Id = CPD.Candidate_Id
left join Tbl_Lead_Status_Master LM on LM.Lead_Status_Id=CPD.LeadStatus_Id

left Join (                              
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                              
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                              
  left join Tbl_Interest_level_Mapping ILM on ILM.Lead_Status_Id=CPD.LeadStatus_Id 
  left join Tbl_Interest_level_Master IL on IL.InterestLevel_ID= ILM.InterestLevel_ID

 where 
 --(CPD.Candidate_nationality in (SELECT Item FROM dbo.SplitString(@leadnationalityid, '','')) or @leadnationalityid='''') 
 -- and CPD.CounselorEmployee_id in (SELECT cast(Item as bigint) FROM dbo.SplitString(@leadcounsellorid, '',''))or @leadcouncellorid=''''
    ( CPD.Candidate_nationality in (SELECT Item FROM dbo.SplitString(@leadnationalityid, '','')) or @leadnationalityid='''')
     and( CPD.CounselorEmployee_id in (SELECT cast(Item as bigint) FROM dbo.SplitString(@leadcounsellorid, '','')) or @leadcounsellorid='''')
    and( CPD.Source_name in (SELECT Item FROM dbo.SplitString(@leadsourceid, '','')) or @leadsourceid='''')
   and( IL.Interest_level_Name in (SELECT Item FROM dbo.SplitString(@interestid, '','')) or @interestid='''')
    and( CPD.LeadStatus_Id in (SELECT cast(Item as bigint) FROM dbo.SplitString(@leadstatusid, '','')) or @leadstatusid='''')
AND ((convert(date,CPD.create_date) = @createddatefrom) or (@createddatefrom is null) or (@createddatefrom ='''') )

AND ((convert(date,CPD.create_date) = @createddateto) or (@createddateto is null) or (@createddateto ='''') )
AND ((convert(date,CPD.create_date) = @followupdatefrom) or (@followupdatefrom is null) or (@followupdatefrom ='''') )
AND ((convert(date,CPD.create_date) = @followupdateto) or (@followupdateto is null) or (@followupdateto ='''') )
                              
                                        
 ORDER BY RegDatetime DESC
OFFSET CASE WHEN @PageSize IS NULL OR @PageSize = 0 OR @CurrentPage IS NULL OR @CurrentPage = 0 THEN 0 
            ELSE @PageSize * (@CurrentPage - 1) 
       END ROWS
FETCH NEXT CASE WHEN @PageSize IS NULL OR @PageSize = 0 OR @CurrentPage IS NULL OR @CurrentPage = 0 THEN 1000000 
                ELSE @PageSize 
           END ROWS ONLY 
OPTION (RECOMPILE);                                  
       end   END');
END
GO
