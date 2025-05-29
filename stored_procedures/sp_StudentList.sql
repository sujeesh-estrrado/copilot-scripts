IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_StudentList]     
(        
@Flag int =0,        
@SearchTerm varchar(max) ='''',        
@CurrentPage bigint=0,        
@pagesize bigint=0,        
@organization_id bigint=0,         
@intake_id bigint=0,        
@Department_id bigint=0,        
@Status bigint=0  ,
@counselorid bigint=0,


@FacultyId NVARCHAR(MAX), 
@ProgrammeId NVARCHAR(MAX), 
@IntakeId NVARCHAR(MAX) 

)        
as        
begin       
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
	


 if @Flag=1        
 begin        
 Declare @UpperBand int        
   Declare @LowerBand int        
        
   SET @LowerBand  = (@CurrentPage - 1) * @PageSize        
   SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                           
--  SELECT * InTO #TEMP1 FROM        
--(SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS RowNumber,BK.*  FROM(           
      SELECT        distinct (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname)         
     AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img,S.name,CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport,         
     CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo,         
     CPD.ApplicationStatus, CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1,  im.Batch_Code as masterintake,        
      bd.Batch_Id,       
   --cs.Semester_Id, cs.Semester_Name,       
   bd.Batch_Code, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id ,CPD.active as status,    
   --S.name as statusinbarracuda    ,    
   concat(S.name,''-'',Case When ApplicationStatus=''pending''Then ''Enquiry List''      
When ApplicationStatus=''Pending''Then ''Enquiry List''      
When ApplicationStatus=''submited''Then ''Enquiry List''      
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''      
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''      
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''      
Else ''Student List(Admissions)'' end) as statusinbarracuda    
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id                                      
  LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON N.Batch_Id=CDP.Batch_Id              left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where         
  --ApplicationStatus is not null and ApplicationStatus=''Completed'' and         
          
  (CPD.Campus= @organization_id or @organization_id=''0'')        
  and (n.Department_Id= @Department_id  or @Department_id=''0'')        
  and (n.Batch_Id= @intake_id or @intake_id=''0'')         
  and (S.id= @Status  or @Status=''0'')        
  --and [Candidate_DelStatus] =0         
  --and(n.New_Admission_Id <>'''')         
  --and (n.New_Admission_Id<>0)      
  
        AND (N.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
        AND (N.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
		AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))        
        
        
 --select * from #TEMP1 where RowNumber >  CONVERT(VARCHAR,@LowerBand)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand)                      
                                                                
        
  order by [IDMatrixNo]        
   OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);        
 end        
 if @Flag=2        
 begin        
  SELECT count(distinct(CPD.Candidate_Id)) as StudentCount        
        
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id         
      left join Tbl_IntakeMaster im on im.id=bd.intakemasterid  LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
     -- LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where --ApplicationStatus is not null and ApplicationStatus=''Completed'' and         
   (CPD.Campus= @organization_id or @organization_id=''0'' or @organization_id=0)        
  and (n.Department_Id= @Department_id  or @Department_id=''0''or @Department_id=0)        
  and (n.Batch_Id= @intake_id or @intake_id=''0''or @intake_id=0)         
  and (S.id= @Status  or @Status=''0''or @Status=0)        
         
   and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )                 
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))             
        
        
 end    
 
 if @flag=3
 begin
 SELECT        distinct (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname)         
     AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img,S.name,CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport,         
     CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo,         
     CPD.ApplicationStatus, CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1,  im.Batch_Code as masterintake,        
      bd.Batch_Id,       
   --cs.Semester_Id, cs.Semester_Name,       
   bd.Batch_Code, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id ,CPD.active as status,    
   --S.name as statusinbarracuda    ,    
   concat(S.name,''-'',Case When ApplicationStatus=''pending''Then ''Enquiry List''      
When ApplicationStatus=''Pending''Then ''Enquiry List''      
When ApplicationStatus=''submited''Then ''Enquiry List''      
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''      
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''      
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''      
Else ''Student List(Admissions)'' end) as statusinbarracuda    
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where         
  --ApplicationStatus is not null and ApplicationStatus=''Completed'' and         
          
  (CPD.Campus= @organization_id or @organization_id=''0'')        
  and (n.Department_Id= @Department_id  or @Department_id=''0'')        
  and (n.Batch_Id= @intake_id or @intake_id=''0'')         
  and (S.id= @Status  or @Status=''0'')        
  --and [Candidate_DelStatus] =0         
  --and(n.New_Admission_Id <>'''')         
  --and (n.New_Admission_Id<>0)  
  and CPD.ApplicationStatus=''Completed''
  and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))        
        
        
 --select * from #TEMP1 where RowNumber >  CONVERT(VARCHAR,@LowerBand)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand)                      
                                                                
        
  order by [IDMatrixNo]        
   OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
 end
       if @flag=4
	   begin
	        
        
   SET @LowerBand  = (@CurrentPage - 1) * @PageSize        
   SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                           
            
SELECT distinct CPD.ApplicationStatus, CPD.active, CPD.Candidate_Id, CPD.IdentificationNo, 
    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname) AS StudentName, 
    CPD.Candidate_Dob, CPD.Candidate_Img, S.name, CPD.Initial_Application_Id, CPD.New_Admission_Id, 
    CPD.AdharNumber AS ICPassport, CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, 
    CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo, CPD.ApplicationStatus, CPD.FeeStatus, 
    CPD.Mode_Of_Study, CPD.Edit_status, Tbl_Student_Semester.Candidate_Id AS Expr1, 
    im.Batch_Code AS masterintake, bd.Batch_Id, bd.Batch_Code, D.Department_Name AS Program, 
    D.Course_Code AS ProgramCode, CL.Course_Level_Name, D.Department_Id, CPD.active AS status, 
    CONCAT(S.name, ''-'', 
        CASE 
            WHEN ApplicationStatus = ''pending'' THEN ''Enquiry List''      
            WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry List''     
            WHEN ApplicationStatus = ''submited'' THEN ''Enquiry List''      
            WHEN ApplicationStatus = ''approved'' THEN ''Candidate List(Admissions)''      
            WHEN ApplicationStatus = ''Verified'' THEN ''Verified List(Admissions)''      
            WHEN ApplicationStatus = ''Conditional_Admission'' THEN ''Verified List(Admissions)''     
            WHEN ApplicationStatus = ''Preactivated'' THEN ''Preactivated List(Admissions)''      
            WHEN ApplicationStatus = ''Completed'' THEN ''Student List(Admissions)''      
            ELSE ''Student List(Admissions)'' 
        END) AS statusinbarracuda    
FROM Tbl_Candidate_Personal_Det CPD
LEFT JOIN Tbl_Student_status S ON S.id = CPD.active
LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
LEFT JOIN Tbl_Student_Semester ON Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id
LEFT JOIN Tbl_Course_Batch_Duration bd ON n.Batch_Id = bd.Batch_Id
LEFT JOIN Tbl_IntakeMaster im ON im.id = bd.intakemasterid
LEFT JOIN Tbl_Course_Department Cdep ON Cdep.Department_Id = n.Department_Id
LEFT JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id
LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
WHERE 
    ApplicationStatus = ''Completed''
    AND CPD.active IN (3, 4, 5) 
	and (CPD.CounselorEmployee_id=@counselorid or @counselorid=0) 
	and(CPD.Campus= @organization_id or @organization_id=''0'')        
  and (n.Department_Id= @Department_id  or @Department_id=''0'')        
  and (n.Batch_Id= @intake_id or @intake_id=''0'')         
  and(CPD.ApplicationStatus=''Completed'' and (CPD.CounselorEmployee_id=@counselorid or @counselorid=0)) 
  --and [Candidate_DelStatus] =0         
  --and(n.New_Admission_Id <>'''')         
  --and (n.New_Admission_Id<>0)        
  and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))                
        
                                                  
        
  order by [IDMatrixNo] 
   OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE); 
	
	   end
	   if @Flag=5
	   begin
	 --  SELECT count(distinct(CPD.Candidate_Id)) as StudentCount        
        
  --    FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
  --       left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
  --   LEFT OUTER JOIN        
  --   tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id left join        
  --   dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
  --   --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
  --   --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
  --   dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id         
  --    left join Tbl_IntakeMaster im on im.id=bd.intakemasterid  LEFT OUTER JOIN        
  --   --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
  --   --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
  --   -- LEFT OUTER JOIN        
  --   dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
  --   dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
  --   dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
  --   --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  --where --ApplicationStatus is not null and ApplicationStatus=''Completed'' and         
  -- (CPD.Campus= @organization_id or @organization_id=''0'' or @organization_id=0)        
  --and (n.Department_Id= @Department_id  or @Department_id=''0''or @Department_id=0)  

  --and (n.Batch_Id= @intake_id or @intake_id=''0''or @intake_id=0)         
  --and(CPD.ApplicationStatus=''Completed'' and (CPD.CounselorEmployee_id=@counselorid or @counselorid=0))      
  ----and [Candidate_DelStatus] =0         
  ----and(n.New_Admission_Id <>'')         
  ----and (n.New_Admission_Id<>0)        
  --and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
  --  or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
  --  or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
  --  or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
   -- or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
  --  or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
  --  or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
  --  or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))        
SELECT COUNT(DISTINCT Candidate_Id) AS StudentCount
FROM (
    SELECT 
        CPD.Candidate_Id,
        CPD.Campus,
        n.Department_Id,
        n.Batch_Id,
        CPD.ApplicationStatus,
        CPD.CounselorEmployee_id,
        CPD.Candidate_Fname,
        CPD.Candidate_Lname,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        CPD.IdentificationNo
    FROM Tbl_Candidate_Personal_Det CPD
    LEFT JOIN Tbl_Student_status S ON S.id = CPD.active
    LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    LEFT JOIN Tbl_Student_Semester ON Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN Tbl_Course_Batch_Duration bd ON n.Batch_Id = bd.Batch_Id
    LEFT JOIN Tbl_IntakeMaster im ON im.id = bd.intakemasterid
    LEFT JOIN Tbl_Course_Department Cdep ON Cdep.Department_Id = n.Department_Id
    LEFT JOIN Tbl_Department D ON D.Department_Id = Cdep.Department_Id
    LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = D.GraduationTypeId
    WHERE 
        ApplicationStatus = ''Completed''
        AND CPD.active IN (3, 4, 5)
) AS FilteredCandidates
WHERE 
    --(Campus = @organization_id OR @organization_id = ''0'' OR @organization_id = 0)
      (Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)
    AND (Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0)
    AND (ApplicationStatus = ''Completed'' AND (CounselorEmployee_id = @counselorid OR @counselorid = 0))
    AND (
        (Candidate_Fname LIKE ''%'' + @SearchTerm + ''%'')
        OR (Candidate_Lname LIKE ''%'' + @SearchTerm + ''%'')
        OR (AdharNumber LIKE ''%'' + @SearchTerm + ''%'')
        OR (IDMatrixNo LIKE ''%'' + @SearchTerm + ''%'')
        OR (IdentificationNo LIKE ''%'' + @SearchTerm + ''%'')
        OR (Candidate_Id LIKE ''%'' + @SearchTerm + ''%'')
        OR (CONCAT(LTRIM(RTRIM(Candidate_Fname)), '' '', LTRIM(RTRIM(Candidate_Lname))) LIKE CONCAT(''%'', @SearchTerm, ''%''))
    );
	   end
         if @flag=6
	   begin
	        
        
   SET @LowerBand  = (@CurrentPage - 1) * @PageSize        
   SET @UpperBand  = (@CurrentPage * @PageSize) + 1                                           
--  SELECT * InTO #TEMP1 FROM        
--(SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS RowNumber,BK.*  FROM(           
      SELECT        distinct (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname)         
     AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img,S.name,CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport,         
     CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo,         
     CPD.ApplicationStatus, CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1,  im.Batch_Code as masterintake,        
      bd.Batch_Id,       
   --cs.Semester_Id, cs.Semester_Name,       
   bd.Batch_Code, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id ,CPD.active as status,    
   --S.name as statusinbarracuda    ,    
   concat(S.name,''-'',Case When ApplicationStatus=''pending''Then ''Enquiry List''      
When ApplicationStatus=''Pending''Then ''Enquiry List''      
When ApplicationStatus=''submited''Then ''Enquiry List''      
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''      
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''      
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''      
Else ''Student List(Admissions)'' end) as statusinbarracuda    
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where         
  --ApplicationStatus is not null and ApplicationStatus=''Completed'' and         
          
  (CPD.Campus= @organization_id or @organization_id=''0'')        
  and (n.Department_Id= @Department_id  or @Department_id=''0'')        
  and (n.Batch_Id= @intake_id or @intake_id=''0'')         
  and(CPD.ApplicationStatus=''Completed'' and (CPD.Agent_ID=@counselorid or @counselorid=0)) 
  --and [Candidate_DelStatus] =0         
  --and(n.New_Admission_Id <>'''')         
  --and (n.New_Admission_Id<>0)        
 and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))         
        
        
 --select * from #TEMP1 where RowNumber >  CONVERT(VARCHAR,@LowerBand)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand)                      
                                                                
        
  order by [IDMatrixNo]        
   OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
	   end
	   if @Flag=7
	   begin
	   SELECT count(distinct(CPD.Candidate_Id)) as StudentCount        
        
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id         
      left join Tbl_IntakeMaster im on im.id=bd.intakemasterid  LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
     -- LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where --ApplicationStatus is not null and ApplicationStatus=''Completed'' and         
   (CPD.Campus= @organization_id or @organization_id=''0'' or @organization_id=0)        
  and (n.Department_Id= @Department_id  or @Department_id=''0''or @Department_id=0)  

  and (n.Batch_Id= @intake_id or @intake_id=''0''or @intake_id=0)         
  and(CPD.ApplicationStatus=''Completed'' and (CPD.Agent_ID=@counselorid or @counselorid=0))      
  --and [Candidate_DelStatus] =0         
  --and(n.New_Admission_Id <>'''')         
  --and (n.New_Admission_Id<>0)        
  and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')         
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))          
	   end


	   
 if @flag=301
 BEGIN
 
 SELECT        distinct (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname)         
     AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img,S.name,CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport,         
     CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo,         
     CPD.ApplicationStatus, CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1,  im.Batch_Code as masterintake,        
      bd.Batch_Id,       
   --cs.Semester_Id, cs.Semester_Name,       
   bd.Batch_Code, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id ,CPD.active as status,    
   --S.name as statusinbarracuda    ,    
   concat(S.name,''-'',Case When ApplicationStatus=''pending''Then ''Enquiry List''      
When ApplicationStatus=''Pending''Then ''Enquiry List''      
When ApplicationStatus=''submited''Then ''Enquiry List''      
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''      
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''      
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''      
Else ''Student List(Admissions)'' end) as statusinbarracuda    
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id                                      
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON N.Batch_Id=CDP.Batch_Id   
                                           
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id 
		left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where       CPD.ApplicationStatus = ''Completed''
           AND CPD.active IN (3, 4, 5)         
                    
                    
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
	and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')     
  
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))
                                                     
        
  order by [IDMatrixNo]        
   --OFFSET @PageSize * (@CurrentPage - 1) ROWS        
   -- FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
	END
	if @flag=302
 BEGIN
 
 SELECT        distinct (CPD.Candidate_Id), CPD.IdentificationNo, CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Mname, '' '', CPD.Candidate_Lname)         
     AS StudentName, CPD.Candidate_Dob, CPD.Candidate_Img,S.name,CPD.Initial_Application_Id, CPD.New_Admission_Id, CPD.AdharNumber AS ICPassport,         
     CPD.AdmissionType, CPD.RegDate, CPD.Campus, CPD.TypeOfStudent, CPD.CounselorCampus, CPD.Active_Status, CPD.IDMatrixNo,         
     CPD.ApplicationStatus, CPD.FeeStatus, CPD.Mode_Of_Study, CPD.Edit_status, dbo.Tbl_Student_Semester.Candidate_Id AS Expr1,  im.Batch_Code as masterintake,        
      bd.Batch_Id,       
   --cs.Semester_Id, cs.Semester_Name,       
   bd.Batch_Code, D.Department_Name AS Program, D.Course_Code AS ProgramCode, CL.Course_Level_Name,D.Department_Id ,CPD.active as status,    
   --S.name as statusinbarracuda    ,    
   concat(S.name,''-'',Case When ApplicationStatus=''pending''Then ''Enquiry List''      
When ApplicationStatus=''Pending''Then ''Enquiry List''      
When ApplicationStatus=''submited''Then ''Enquiry List''      
When ApplicationStatus=''approved''Then ''Candidate List(Admissions)''      
When ApplicationStatus=''Verified''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Conditional_Admission''Then ''Verified List(Admissions)''      
When ApplicationStatus=''Preactivated''Then ''Preactivated List(Admissions)''      
When ApplicationStatus=''Completed''Then ''Student List(Admissions)''      
Else ''Student List(Admissions)'' end) as statusinbarracuda    
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id                                      
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON N.Batch_Id=CDP.Batch_Id   
                                           
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id 
		left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where       CPD.ApplicationStatus = ''Completed''
  AND (CPD.CounselorEmployee_id=@counselorid or @counselorid=0)
           AND CPD.active IN (3, 4, 5)         
                    
                    
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
	and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')     
  
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))
                                                     
        
  order by [IDMatrixNo]        
   --OFFSET @PageSize * (@CurrentPage - 1) ROWS        
   -- FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
	END
	if @Flag=31
	begin
	SELECT    Count(    distinct (CPD.Candidate_Id)) as count 
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id                                      
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON N.Batch_Id=CDP.Batch_Id   
                                           
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id 
		left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where       CPD.ApplicationStatus = ''Completed''
           AND CPD.active IN (3, 4, 5)         
                    
                    
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
	and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')     
  
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))
                                                     

	end
	if @Flag=32
	begin
	SELECT    Count(    distinct (CPD.Candidate_Id)) as count 
      FROM            dbo.Tbl_Candidate_Personal_Det AS CPD left join Tbl_Student_status S on s.id=CPD.active        
         left join Tbl_Candidate_ContactDetails CC on CC.Candidate_Id=cpd.Candidate_Id        
     LEFT OUTER JOIN        
     tbl_New_Admission n on n.New_Admission_Id=CPD.New_Admission_Id                                      
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON N.Batch_Id=CDP.Batch_Id   
                                           
    LEFT JOIN tbl_New_Admission NA 
        ON NA.New_Admission_Id = CPD.New_Admission_Id 
		left join        
     dbo.Tbl_Student_Semester ON dbo.Tbl_Student_Semester.Candidate_Id = CPD.Candidate_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_Mapping AS CDM ON dbo.Tbl_Student_Semester.Duration_Mapping_Id = CDM.Duration_Mapping_Id LEFT OUTER JOIN        
     --dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN        
     dbo.Tbl_Course_Batch_Duration AS bd ON n.Batch_Id = bd.Batch_Id  left join Tbl_IntakeMaster im on im.id=bd.intakemasterid          
     --LEFT OUTER JOIN        
     --Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id left join        
     --dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = SS.SemesterId         
      LEFT OUTER JOIN        
     dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = n.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id LEFT OUTER JOIN        
     dbo.Tbl_Course_Level AS CL on CL.Course_Level_Id = D.GraduationTypeId         
     --left join Tbl_Student_status JJ on JJ.id=CPD.active        
  where       CPD.ApplicationStatus = ''Completed''
  and (CPD.CounselorEmployee_id=@counselorid or @counselorid=0)
           AND CPD.active IN (3, 4, 5)         
                    
                    
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
	and(([Candidate_Fname] like  ''%''+ @SearchTerm +''%'')     
  
    or ([Candidate_Lname] like  ''%''+ @SearchTerm +''%'')          
    or([AdharNumber] like ''%''+ @SearchTerm +''%'' )        
    or (IDMatrixNo like ''%''+ @SearchTerm +''%'' )         
    or (CPD.IdentificationNo like ''%''+ @SearchTerm +''%'' )        
    or(CPD.[Candidate_Id] like ''%''+ @SearchTerm +''%'' )         
    or (CONCAT(LTRIM(RTRIM(Candidate_Fname)),'' '',LTRIM(RTRIM(Candidate_Lname)))  LIKE CONCAT(''%'',@SearchTerm,''%'')))
                                                     

	end

end

');
END;
