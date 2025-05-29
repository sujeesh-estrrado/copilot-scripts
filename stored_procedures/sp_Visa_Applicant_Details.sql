IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Visa_Applicant_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Visa_Applicant_Details]         
(        
@Flag int =0,        
@SearchTerm varchar(max) ='''',        
@CurrentPage bigint=0,        
@pagesize bigint=0,        
@organization_id bigint=0,         
@intake_id bigint=0,        
@Department_id bigint=0,        
@Status bigint=0  ,
@counselorid bigint=0
)        
as        
begin        
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
  --and [Candidate_DelStatus] =0         
  --and(n.New_Admission_Id <>'''')         
  --and (n.New_Admission_Id<>0)        
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
        
        
 --select * from #TEMP1 where RowNumber >  CONVERT(VARCHAR,@LowerBand)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand)                      
                                                                
        
  order by [IDMatrixNo]        
   OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);  
	   end
	   if @Flag=5
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
end
');
END;
