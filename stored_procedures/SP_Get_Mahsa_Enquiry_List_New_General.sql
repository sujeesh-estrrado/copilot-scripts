IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Mahsa_Enquiry_List_New_General]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE procedure [dbo].[SP_Get_Mahsa_Enquiry_List_New_General] --1,100,'''',''--Select--'',''--Select--'',''--Select--'','''','''',''1'',''--Select--'',''--Select--'',''--Select--'',''--Select--'','''',''19''                               
  --SP_Get_Mahsa_Enquiry_List_New 1,100,'''',1445              
(                                      
@CurrentPage int=1 ,                                                     
@PageSize int=10 ,
@CounselorEmp bigint =0,
@Flag int=0,
@f int=0,

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


  declare @roleid bigint=0;
   declare @userid bigint=0;
     

   select @userid =  user_id from Tbl_Employee_User where employee_id=@CounselorEmp
   
   select @roleid =  role_id from tbl_user where user_id=@userid
  
   --if(@roleid=14)
   --begin
   --set @CounselorEmp=0
   --end
   if(@f=0)
   begin
    if(@Flag=0)  
    begin
                    
                                                       
  SET @LowerBand  = (@CurrentPage -                                      
  1) * @PageSize                                                          
  SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                         
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP1;                            
  IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP2;                                 
--      select * from      
--(                                
--  (SELECT distinct CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
--  CPD.TypeOfStudent,                                                          
--  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
--  CPD.ApplicationStage as Stage, 
--  CPD.ApplicationStatus as ApplicationStatus,
--   --PR.result as ApplicationStatus,
--   -- (select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
--   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,   
--  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
--  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
--  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
--   NA.Department_Id as DepartmentID
                                                                                                
--  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id 
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id                                        
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
-- -- left join Tbl_Placement_Log PR On CPD.Candidate_Id=PR.Candidate_id 
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                  
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id ) 
--left join Tbl_Status_change_by_Marketing M on M.Candidate_Id=CPD.candidate_Id
  
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
--  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
--  and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 ) 
  
--        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
--        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
--      AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
--  )              
                    
----  Union all                    
                    
----(SELECT distinct   CPD.Candidate_Id as ID,                                      
----  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
----  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
----  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
----  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
----  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
----  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
----  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
----  FROM Tbl_Candidate_Personal_Det PD                                   
----  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
----  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
----  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
----  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
----  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
----  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
----  left Join (                    
----  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
----  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
----  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
----  )          
                    
--  --Lead integration with enquiry                
--  --Union all                    
                    
--  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
--  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
--  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
--  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
--  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
--  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
--  -- NA.Department_Id as DepartmentID
                                                        
--  --FROM Tbl_Lead_Personal_Det CPD                   
--  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
--  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
--  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
--  --left Join (                    
--  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
--  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
--  --)    
--  )as TRes         
                      
--  ORDER BY   
--  TRes.RDate desc     
    SELECT * FROM      
(
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
        --AND Follow_Up_Detail_Id IN ( 
        --    SELECT MAX(Follow_Up_Detail_Id)  
        --    FROM Tbl_FollowUp_Detail 
        --    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
        --    GROUP BY Candidate_Id
        --) 
        AND Action_Taken = 0
    ) AS FD 
    ON FD.Candidate_Id = CPD.Candidate_Id                                     
    WHERE  
     
    (CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited'')) 
    AND (CPD.CounselorEmployee_id = @CounselorEmp OR ISNULL(@CounselorEmp, ''0'') = ''0'') 
   


) AS TRes         
ORDER BY RDate DESC
 OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
                             
  end
  if(@Flag=1)
  begin
                           
                                                       
  SET @LowerBand  = (@CurrentPage -                                      
  1) * @PageSize                                                          
  SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                         
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP1;                            
  IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP2;                                 
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
    --(select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
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
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
 -- and (FD.Next_Date is null or FD.Next_Date<=  convert(date,getdate())) 
  and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )   
     AND (
        (EXISTS (SELECT 1 FROM @FacultyTable) AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)) 
        OR ISNULL(@FacultyId, '''') = '''' OR @FacultyId = ''0''
    )
    AND (
        (EXISTS (SELECT 1 FROM @ProgrammeTable) AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)) 
        OR ISNULL(@ProgrammeId, '''') = '''' OR @ProgrammeId = ''0''
    )
    AND (
        (EXISTS (SELECT 1 FROM @IntakeTable) AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)) 
        OR ISNULL(@IntakeId, '''') = '''' OR @IntakeId = ''0''
    )
  )              
                    
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
  end
  end
  --if(@f=1)
  --begin
  -- if(@Flag=0)

--  select * from      
--(                                
--  SELECT DISTINCT 
--    CPD.Candidate_Id AS ID,
--    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
--    (CONVERT(NVARCHAR(10), RegDate, 105)) AS RegDate,
--    RegDate AS RDate,
--    CPD.TypeOfStudent,
--    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
--    CPD.AdharNumber,
--    CPD.ApplicationStage AS Stage,
--    CPD.ApplicationStatus AS ApplicationStatus,
--    CC.Candidate_Mob1 AS MobileNumber,
--    CC.Candidate_Email AS EmailID,
--    CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
--    (CONVERT(NVARCHAR(10), FD.Max_Next_Date, 105)) AS nextDate,
--    FD.Respond_Type,
--    cbd.Batch_Code,
--    D.Department_Name AS Department,
--    CPD.Scolorship_Remark,
--    REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
--    '''' AS ReadStatus,
--    '''' AS RevertStatus,
--    '''' AS MMUOldStudent,
--    '''' AS DocUploaded,
--    NA.Department_Id AS DepartmentID
--FROM 
--    Tbl_Candidate_Personal_Det CPD
--LEFT JOIN 
--    Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
--LEFT JOIN 
--    tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
--LEFT JOIN 
--    Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
--LEFT JOIN 
--    Tbl_Department D ON NA.Department_Id = D.Department_Id
--LEFT JOIN 
--    Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
--LEFT JOIN 
--    (
--        SELECT 
--            Candidate_Id, 
--            MAX(Next_Date) AS Max_Next_Date, 
--            Respond_Type
--        FROM 
--            Tbl_FollowUp_Detail
--        WHERE 
--            (Delete_Status = 0 OR Delete_Status IS NULL)
--            AND (Action_Taken = 0)
--        GROUP BY 
--            Candidate_Id, Respond_Type
--    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
--WHERE 
--    (CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited''))
--    AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0)
--    AND (FD.Max_Next_Date IS NULL OR FD.Max_Next_Date <= CONVERT(DATE, GETDATE()))
                  
----  Union all                    
                    
----(SELECT distinct   CPD.Candidate_Id as ID,                                      
----  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
----  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
----  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
----  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
----  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
----  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
----  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
----  FROM Tbl_Candidate_Personal_Det PD                                   
----  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
----  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
----  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
----  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
----  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
----  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
----  left Join (                    
----  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
----  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
----  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
----  )          
                    
--  --Lead integration with enquiry                
--  --Union all                    
                    
--  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
--  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
--  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
--  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
--  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
--  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
--  -- NA.Department_Id as DepartmentID
                                                        
--  --FROM Tbl_Lead_Personal_Det CPD                   
--  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
--  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
--  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
--  --left Join (                    
--  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
--  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
--  --)    
--  )as TRes         
                      
--  ORDER BY   
--  TRes.RDate desc     
    
--  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
--  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
    
--SELECT * FROM      
--(                                 
--    SELECT DISTINCT 
--        CPD.Candidate_Id AS ID,
--        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
--        CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate,
--        CPD.RegDate AS RDate,
--        CPD.TypeOfStudent,
--        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
--        CPD.AdharNumber,
--        CPD.ApplicationStage AS Stage,
--        CPD.ApplicationStatus AS ApplicationStatus,
--        CC.Candidate_Mob1 AS MobileNumber,
--        CC.Candidate_Email AS EmailID,
--        CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
--        CONVERT(NVARCHAR(10), FD.Max_Next_Date, 105) AS nextDate,
--        FD.Respond_Type,
--        cbd.Batch_Code,
--        D.Department_Name AS Department,
--        CPD.Scolorship_Remark,
--        REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
--        '''' AS ReadStatus,
--        '''' AS RevertStatus,
--        '''' AS MMUOldStudent,
--        '''' AS DocUploaded,
--        NA.Department_Id AS DepartmentID
--    FROM Tbl_Candidate_Personal_Det CPD
--    LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
--    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
--    LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
--    LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id
--    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
--    LEFT JOIN 
--    (
--        SELECT 
--            Candidate_Id, 
--            MAX(Next_Date) AS Max_Next_Date,
--            MAX(Respond_Type) AS Respond_Type 
--        FROM Tbl_FollowUp_Detail
--        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
--            AND (Action_Taken = 0)
--        GROUP BY Candidate_Id
--    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
--    WHERE  
--        CPD.ApplicationStatus IN (''pending'', ''Pending'', ''submited'') 
        
--        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
--        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
--      AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
--    AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0)
--        AND (FD.Max_Next_Date IS NULL OR FD.Max_Next_Date <= CONVERT(DATE, GETDATE()))  
--        AND (EC.Employee_Status = 0 OR CPD.CounselorEmployee_id = 0)
--       AND (
--        (EXISTS (SELECT 1 FROM @FacultyTable) AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)) 
--        OR ISNULL(@FacultyId, '''') = '''' OR @FacultyId = ''0''
--    )
--    AND (
--        (EXISTS (SELECT 1 FROM @ProgrammeTable) AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)) 
--        OR ISNULL(@ProgrammeId, '''') = '''' OR @ProgrammeId = ''0''
--    )
--    AND (
--        (EXISTS (SELECT 1 FROM @IntakeTable) AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)) 
--        OR ISNULL(@IntakeId, '''') = '''' OR @IntakeId = ''0''
--    )
         
--) AS TRes         
--ORDER BY TRes.RDate DESC;
--              SELECT * FROM      
--(                                 
--    SELECT DISTINCT 
--        CPD.Candidate_Id AS ID,
--        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
--        CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate,
--        CPD.RegDate AS RDate,
--        CPD.TypeOfStudent,
--        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
--        CPD.AdharNumber,
--        CPD.ApplicationStage AS Stage,
--        CPD.ApplicationStatus AS ApplicationStatus,
--        CC.Candidate_Mob1 AS MobileNumber,
--        CC.Candidate_Email AS EmailID,
--        CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
--        CONVERT(NVARCHAR(10), FD.Max_Next_Date, 105) AS nextDate,
--        FD.Respond_Type,
--        cbd.Batch_Code,
--        D.Department_Name AS Department,
--        CPD.Scolorship_Remark,
--        REPLACE(CPD.SourceofInformation, ''0'', '''') AS SourceofInformation,
--        '''' AS ReadStatus,
--        '''' AS RevertStatus,
--        '''' AS MMUOldStudent,
--        '''' AS DocUploaded,
--        NA.Department_Id AS DepartmentID
--    FROM Tbl_Candidate_Personal_Det CPD
--    LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
--    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
--LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
--    LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
--    LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id
--    LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
--    LEFT JOIN 
--    (
--        SELECT 
--            Candidate_Id, 
--            MAX(Next_Date) AS Max_Next_Date,
--            MAX(Respond_Type) AS Respond_Type 
--        FROM Tbl_FollowUp_Detail
--        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
--            AND (Action_Taken = 0)
--        GROUP BY Candidate_Id
--    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
--    WHERE  
--        CPD.ApplicationStatus IN (''pending'', ''Pending'', ''submited'') 
        
--        AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
--        AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
--      AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
--    AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0)
--        AND (FD.Max_Next_Date IS NULL OR FD.Max_Next_Date <= CONVERT(DATE, GETDATE()))  
--        AND (EC.Employee_Status = 0 OR CPD.CounselorEmployee_id = 0)
--       AND (
--        (EXISTS (SELECT 1 FROM @FacultyTable) AND NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)) 
--        OR ISNULL(@FacultyId, '''') = '''' OR @FacultyId = ''0''
--    )
--    AND (
--        (EXISTS (SELECT 1 FROM @ProgrammeTable) AND NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)) 
--        OR ISNULL(@ProgrammeId, '''') = '''' OR @ProgrammeId = ''0''
--    )
--    AND (
--        (EXISTS (SELECT 1 FROM @IntakeTable) AND CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)) 
--        OR ISNULL(@IntakeId, '''') = '''' OR @IntakeId = ''0''
--    )
         
--) AS TRes         
--ORDER BY TRes.RDate DESC;               
--  end

IF (@f = 2)
BEGIN
    SELECT * FROM (
        -- First Query
        SELECT DISTINCT 
            CPD.Candidate_Id AS ID,
            CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
            TRY_CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate, -- Use TRY_CONVERT
            RegDate AS RDate,
            CPD.TypeOfStudent,
            CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
            CPD.AdharNumber,
            CPD.ApplicationStage AS Stage,
            CPD.ApplicationStatus AS ApplicationStatus,
            CC.Candidate_Mob1 AS MobileNumber,
            CC.Candidate_Email AS EmailID,
            CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
            TRY_CONVERT(NVARCHAR(10), FD.Next_Date, 105) AS nextDate, -- Use TRY_CONVERT
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
        LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
        LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id
        LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
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
        ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
        WHERE 
            (CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited''))
            AND (CPD.CounselorEmployee_id = 0 OR CPD.CounselorEmployee_id IS NULL)
            --AND TRY_CONVERT(DATETIME, RegDate, 105) IS NOT NULL -- Exclude invalid RegDate
            --AND TRY_CONVERT(DATETIME, FD.Next_Date, 105) IS NOT NULL -- Exclude invalid Next_Date

        --UNION ALL

        ---- Second Query
        --SELECT DISTINCT 
        --    CPD.Candidate_Id AS ID,
        --    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        --    TRY_CONVERT(NVARCHAR(10), CPD.RegDate, 105) AS RegDate, -- Use TRY_CONVERT
        --    CPD.RegDate AS RDate,
        --    PD.TypeOfStudent,
        --    CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)), '' '', LTRIM(RTRIM(PD.Candidate_Lname))) AS CandidateName,
        --    PD.AdharNumber,
        --    CPD.ApplicationStage AS Stage,
        --    CPD.ApplicationStatus AS ApplicationStatus,
        --    CC.Candidate_Mob1 AS MobileNumber,
        --    CC.Candidate_Email AS EmailID,
        --    CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
        --    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        --    FD.Respond_Type,
        --    cbd.Batch_Code,
        --    D.Department_Name AS Department,
        --    CPD.Scolorship_Remark,
        --    ''Enquiry'' AS SourceofInformation,
        --    '''' AS ReadStatus,
        --    '''' AS RevertStatus,
        --    '''' AS MMUOldStudent,
        --    '''' AS DocUploaded,
        --    NA.Department_Id AS DepartmentID
        --FROM Tbl_Candidate_Personal_Det PD
        --INNER JOIN Tbl_Student_NewApplication CPD ON PD.Candidate_Id = CPD.Candidate_Id
        --LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
        --LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
        --LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
        --LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id
        --LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
        --LEFT JOIN (
        --    SELECT Candidate_Id, Next_Date, Respond_Type
        --    FROM Tbl_FollowUp_Detail
        --    WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        --    AND Follow_Up_Detail_Id IN (
        --        SELECT MAX(Follow_Up_Detail_Id)
        --        FROM Tbl_FollowUp_Detail
        --        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        --        GROUP BY Candidate_Id
        --    )
        --    AND Action_Taken = 0
        --) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
        --WHERE 
        --    CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited'')
        --    AND TRY_CONVERT(DATETIME, CPD.RegDate, 105) IS NOT NULL -- Exclude invalid RegDate
        --    AND TRY_CONVERT(DATETIME, FD.Next_Date, 105) IS NOT NULL -- Exclude invalid Next_Date

        --UNION ALL

        ---- Third Query (Lead Integration)
        --SELECT DISTINCT 
        --    CPD.Candidate_Id AS ID,
        --    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
        --    TRY_CONVERT(NVARCHAR(10), RegDate, 105) AS RegDate, -- Use TRY_CONVERT
        --    RegDate AS RDate,
        --    CPD.TypeOfStudent,
        --    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        --    CPD.AdharNumber,
        --    CPD.ApplicationStage AS Stage,
        --    CPD.ApplicationStatus AS ApplicationStatus,
        --    CC.Candidate_Mob1 AS MobileNumber,
        --    CC.Candidate_Email AS EmailID,
        --    CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
        --    ISNULL(FD.Next_Date, DATEADD(YEAR, 100, ''5555-01-01'')) AS nextDate,
        --    FD.Respond_Type,
        --    cbd.Batch_Code,
        --    D.Department_Name AS Department,
        --    CPD.Scolorship_Remark,
        --    CPD.SourceofInformation,
        --    '''' AS ReadStatus,
        --    '''' AS RevertStatus,
        --    '''' AS MMUOldStudent,
        --    '''' AS DocUploaded,
        --    NA.Department_Id AS DepartmentID
        --FROM Tbl_Lead_Personal_Det CPD
        --LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
        --LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
        --LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
        --LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id
        --LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
        --LEFT JOIN (
        --    SELECT Candidate_Id, Next_Date, Respond_Type
        --    FROM Tbl_FollowUpLead_Detail
        --    WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        --    AND Follow_Up_Detail_Id IN (
        --        SELECT MAX(Follow_Up_Detail_Id)
        --        FROM Tbl_FollowUpLead_Detail
        --        WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
        --        GROUP BY Candidate_Id
        --    )
        --    AND Action_Taken = 0
        --) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
        --WHERE 
        --    CPD.ApplicationStatus = ''Lead''
        --    AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0)
        --    AND TRY_CONVERT(DATETIME, RegDate, 105) IS NOT NULL -- Exclude invalid RegDate
        --    AND TRY_CONVERT(DATETIME, FD.Next_Date, 105) IS NOT NULL -- Exclude invalid Next_Date
    ) AS TRes
    ORDER BY TRes.RDate DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END
  IF @f = 1 
BEGIN
    SELECT * FROM      
    (
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
            CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
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
        LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id = CDP.Batch_Id
        LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_Department D ON NA.Department_Id = D.Department_Id
        LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
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
        ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
        WHERE 
            (CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited''))
            AND (FD.Next_Date IS NULL OR FD.Next_Date <= CONVERT(DATE, GETDATE()))
            AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0)
            AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
            AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
            --AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
    ) AS TRes         
    ORDER BY TRes.RDate DESC
    OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END
  if @f=3
  begin
--    select * from      
--(                                
--  (SELECT distinct CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(nvarchar(10),RegDate,105)) as RegDate,  RegDate RDate ,                                       
--  CPD.TypeOfStudent,                                                          
--  CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber, 
--  CPD.ApplicationStage as Stage, 
--  CPD.ApplicationStatus as ApplicationStatus,
--   --PR.result as ApplicationStatus,
--   -- (select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
--   CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                       
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,   
--  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,
--  (convert(nvarchar(10),FD.Next_Date,105)) as nextDate,
--  FD.Respond_Type, cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  , Replace(CPD.SourceofInformation,''0'','''') SourceofInformation,''''as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
--   NA.Department_Id as DepartmentID
                                                                                                
--  FROM Tbl_Candidate_Personal_Det  CPD                                                                                                                                     
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                        
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id 
-- -- left join Tbl_Placement_Log PR On CPD.Candidate_Id=PR.Candidate_id 
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id  
--  left join Tbl_Status_change_by_Marketing scm on scm.Candidate_id=CPD.Candidate_Id
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
--  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
--  and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )   and scm.status=''Hold''    
--  )                   
----  Union all                    
                    
----(SELECT distinct   CPD.Candidate_Id as ID,                                      
----  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
----  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
----  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
----  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
----  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
----  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
----  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
----  FROM Tbl_Candidate_Personal_Det PD                                   
----  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
----  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
----  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
----  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
----  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
----  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
----  left Join (                    
----  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
----  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
----  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
----  )          
                    
--  --Lead integration with enquiry                
--  --Union all                    
                    
--  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
--  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
--  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
--  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
--  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
--  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
--  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
--  -- NA.Department_Id as DepartmentID
                                                        
--  --FROM Tbl_Lead_Personal_Det CPD                   
--  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
--  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
--  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
--  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
--  --left Join (                    
--  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
--  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
--  --)    
--  )as TRes         
                      
--  ORDER BY   
--  TRes.RDate desc     
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
     and scm.status=''Hold''    
  )
  
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    

  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
  end
  if @f=4
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
    and CPD.ApplicationStatus=''rejected''    
  )                   
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
  end
  else if(@f=5)
   begin
    if(@Flag=0)  
    begin
                    
                                                       
  SET @LowerBand  = (@CurrentPage -                                      
  1) * @PageSize                                                          
  SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                         
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP1;                            
  IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP2;                                 
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
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
                     
  )              
                    
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
                             
  end
  if(@Flag=1)
  begin
                           
                                                       
  SET @LowerBand  = (@CurrentPage -                                      
  1) * @PageSize                                                          
  SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                         
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP1;                            
  IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL                                  
  DROP TABLE #TEMP2;                                 
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
    --(select top 1 result from Tbl_Placement_Log where Candidate_id =CPD.Candidate_Id order by result desc )as ApplicationStatus,
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
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join (                    
  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                                     
  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
  and (CPD.Agent_ID = @CounselorEmp or @CounselorEmp = 0 ) 
    
  )              
                    
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
  end
  end
  if(@f=6)
  begin
  select * from      
(                                
  SELECT DISTINCT 
    CPD.Candidate_Id AS ID,
   CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS Employee_Name,
    (CONVERT(NVARCHAR(10), RegDate, 105)) AS RegDate,
    RegDate AS RDate,
    CPD.TypeOfStudent,
    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
    CPD.AdharNumber,
    CPD.ApplicationStage AS Stage,
    CPD.ApplicationStatus AS ApplicationStatus,
    CC.Candidate_Mob1 AS MobileNumber,
    CC.Candidate_Email AS EmailID,
    CASE WHEN CPD.FeeStatus = ''Paid'' THEN ''Paid'' ELSE ''Not Paid'' END AS FeeStatus,
    (CONVERT(NVARCHAR(10), FD.Max_Next_Date, 105)) AS nextDate,
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
FROM 
    Tbl_Candidate_Personal_Det CPD
LEFT JOIN 
    Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
LEFT JOIN 
    tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
LEFT JOIN 
    Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id
LEFT JOIN 
    Tbl_Department D ON NA.Department_Id = D.Department_Id
LEFT JOIN 
    Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id
LEFT JOIN 
    (
        SELECT 
            Candidate_Id, 
            MAX(Next_Date) AS Max_Next_Date, 
            Respond_Type
        FROM 
            Tbl_FollowUp_Detail
        WHERE 
            (Delete_Status = 0 OR Delete_Status IS NULL)
            AND (Action_Taken = 0)
        GROUP BY 
            Candidate_Id, Respond_Type
    ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id
WHERE 
    (CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited''))
    AND (CPD.Agent_ID = @CounselorEmp OR @CounselorEmp = 0)
    AND (FD.Max_Next_Date IS NULL OR FD.Max_Next_Date <= CONVERT(DATE, GETDATE()))
               
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);                    
                                   
  end
   if @f=7
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
  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
  and (CPD.Agent_ID = @CounselorEmp or @CounselorEmp = 0 )   and scm.status=''Hold''    
  )                   
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
  end
  if @f=8
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
  where  (CPD.Agent_ID = @CounselorEmp or @CounselorEmp = 0 )   and CPD.ApplicationStatus=''rejected''    
  )                   
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
  end
   if(@f=10)
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
  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                   
  left Join Tbl_FollowUp_Detail FD on FD.Candidate_Id=CPD.Candidate_Id
  where  (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
  and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )    and CAST(RegDate AS DATE) = CAST(GETDATE() AS DATE) 
  )                 
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end




  ----------------------------------------INDIVIDUAL APPLICATION COUNT--
  if @f=8
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
  where  (CPD.Agent_ID = @CounselorEmp or @CounselorEmp = 0 )      and CPD.ApplicationStatus=''rejected''    
  )                   
--  Union all                    
                    
--(SELECT distinct   CPD.Candidate_Id as ID,                                      
--  CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name,                                      
--  (convert(date,CPD.RegDate,105)) as RegDate, PD.TypeOfStudent,
--  CONCAT(LTRIM(RTRIM(PD.Candidate_Fname)),'' '',LTRIM(RTRIM(PD.Candidate_Lname)) )as CandidateName, PD.AdharNumber, CPD.ApplicationStage as Stage,                         
--  CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                      
--  case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                                                                     
--  ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,cbd.Batch_Code, D.Department_Name Department,
--  CPD.Scolorship_Remark  ,''Enquiry'' as SourceofInformation          
                                                              
--  FROM Tbl_Candidate_Personal_Det PD                                   
--  Inner join Tbl_Student_NewApplication  CPD on PD.Candidate_Id=CPD.Candidate_Id                                               
--  left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                                             
--  left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
--  left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                              
--  left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                                       
--  left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id )                    
--  left Join (                    
--  select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUp_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
--  (select max(Follow_Up_Detail_Id)  from Tbl_FollowUp_Detail where(Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
                    
--  where CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited''             
              
--  )          
                    
  --Lead integration with enquiry                
  --Union all                    
                    
  --(SELECT distinct   CPD.Candidate_Id as ID,--SG.BloodGroup,                                      
  --CONCAT(EC.Employee_FName,'' '',EC.Employee_LName) as Employee_Name, (convert(date,RegDate,105)) as RegDate,
  --CPD.TypeOfStudent, CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)),'' '',LTRIM(RTRIM(CPD.Candidate_Lname)) )as CandidateName, CPD.AdharNumber,                    
  --CPD.ApplicationStage as Stage, CPD.ApplicationStatus as ApplicationStatus, CC.Candidate_Mob1 as MobileNumber, CC.Candidate_Email as EmailID ,                                                                  
  --case when  CPD.FeeStatus=''Paid'' then ''Paid'' else ''Not Paid'' end as FeeStatus ,                 
  --ISNULL(FD.Next_Date,DATEADD(year, 100,''5555-01-01'')) as nextDate,FD.Respond_Type,      
  --cbd.Batch_Code, D.Department_Name Department, CPD.Scolorship_Remark  ,CPD.SourceofInformation,'''' as ReadStatus,'''' as RevertStatus,'''' as MMUOldStudent,'''' as DocUploaded,
  -- NA.Department_Id as DepartmentID
                                                        
  --FROM Tbl_Lead_Personal_Det CPD                   
  --left join  Tbl_Lead_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                                                   
  --left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                                                   
  --left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=NA.Batch_Id                                                                                                           
  --left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                       
  --left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id)               
  --left Join (                    
  --select Candidate_Id, Next_Date,Respond_Type from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) and Follow_Up_Detail_Id in                    
  --(select max(Follow_Up_Detail_Id)  from Tbl_FollowUpLead_Detail where (Delete_Status=0 or Delete_Status is null) group by Candidate_Id) and Action_Taken=0)as FD on FD.Candidate_Id=CPD.Candidate_Id                    
  --where   CPD.ApplicationStatus=''Lead'' and (CPD.CounselorEmployee_id = @CounselorEmp or @CounselorEmp = 0 )                    
  --)    
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
  end
   if(@f=200)
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
  
  ) 
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end

   if(@f=201)
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
  CPD.CounselorEmployee_id=@CounselorEmp
  AND (CPD.ApplicationStatus=''Pending'' or CPD.ApplicationStatus=''pending'' or CPD.ApplicationStatus=''submited'') 
  
  ) 
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end


  if(@f=202)
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
       
) AS TRes   
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end


   if(@f=400)
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
    )
  ) 
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end

   if(@f=401)
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
 CPD.CounselorEmployee_id=@CounselorEmp
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
  ) 
  )as TRes         
                      
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end


  if(@f=402)
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
    )
) AS TRes   
  ORDER BY   
  TRes.RDate desc     
    
  OFFSET @PageSize * (@CurrentPage - 1) ROWS                    
  FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
  end

End                    
                    
   IF(@f=300)
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
        CPD.ApplicationStatus IN (''Pending'', ''pending'', ''submited'') 
        AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @IntakeTable)
            OR CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable)
        )
END

                    
            IF(@f=301)
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
        -- LEFT JOIN Tbl_FollowUp_Detail f ON f.candidate_id = cpd.candidate_id                                                                                                                                 
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
    WHERE  (FD.Next_Date IS NULL OR FD.Next_Date <= CONVERT(DATE, GETDATE()))
           AND (cpd.ApplicationStatus IN (''Pending'', ''submited''))
           AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
       
           END
                    
                    
           IF(@f=302)
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
         AND  (CPD.CounselorEmployee_id = 0 OR CPD.CounselorEmployee_id = '''')
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
         
           END
                         
                    
                    
          IF(@f=304)
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
        )
         
           END               
                    
                    
                    
                    
          
          IF(@f=306)
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
        )
         
           END               
                    
                    
           
          IF(@f=332)
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
         M.status = ''Hold''
           AND (CPD.CounselorEmployee_id = @CounselorEmp OR @CounselorEmp = 0) 
          AND (
            NOT EXISTS (SELECT 1 FROM @FacultyTable)
            OR NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable)
        )
        AND (
            NOT EXISTS (SELECT 1 FROM @ProgrammeTable)
            OR NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable)
        )
         
           END       
              IF(@f=333)
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
        )
         
         
           END   
           
               IF(@f=330)
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
        )
         
           END   
              IF(@f=325)
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
         
           END  
              IF(@f=331)
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
        )
         
           END            
                    
                    
   
    ')
END
