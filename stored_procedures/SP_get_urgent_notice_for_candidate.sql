IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Uploaded_Docs]')
    AND type = N'P'
)
BEGIN
    EXEC('
     create procedure [dbo].[sp_Get_Uploaded_Docs] --''2020-03-19'',''2020-06-19'',304,10,0,'''',2020     
(      
    
@Fromdate varchar(MAX)='''',      
@todate varchar(MAX)='''',    
@CurrentPage int=null,              
@pagesize bigint null,    
@Flag bigint=0,    
@Intake varchar(MAX)='''',    
@IntakeYear bigint=0,
@Search varchar(max)=''''
    
)      
as      
begin    
if(@Flag=0)    
begin    
 select DISTINCT concat(CPD.Candidate_Fname,'' '',CPD.candidate_Lname) as CandiadteName,CPD.Candidate_Id as ID, CCD.Candidate_Mob1 as Mobile,CCD.Candidate_Email as Candidate_Email, E.Employee_FName as Counsellor,             CPD.ApplicationStatus,CPD.AdharNumber as ICpassportNo,CONVERT(VARCHAR, SD.CreatedDateDate, 103) AS CreatedDateDate ,      case when  NA.Department_Id=0      then ''Unspecified''  
     else (select D.Department_Name from Tbl_Department D where D.Department_Id=NA.Department_Id)  end  as Programme,CPD.create_date as create_date,CONVERT(VARCHAR, CPD.RegDate, 103)  as reg_date,           (case when SD.MarketingVerifyBy!='''' and SD.MarketingVerify!=0  then concat(E.Employee_FName,'' '',E.Employee_LName) when SD.MarketingVerifyBy=''0'' and SD.MarketingVerify!=0then ''Admin'' else ''--'' end)as MarketingVerifyed_By,  
  (case when SD.AdmissionVerifyBy!='''' and SD.AdmissionVerify!=0 then concat(EA.Employee_FName,'' '',EA.Employee_LName) When SD.AdmissionVerifyBy=''0'' and SD.AdmissionVerify!=0 then ''Admin'' else ''--'' end)as AdmissionVerifyed_By,          CL.Course_Level_Name as Faculty,    CPD.IDMatrixNo as StudentId,    SD.DocumentName as DocumentName,     
  CM.Document_Name,    
  --IM.intake_no,
  IM.Batch_Code as intake_no,
  CPD.TypeOfStudent     from tbl_StudentDocUpload SD    
left join tbl_candidate_personal_det CPD on SD.StudentId=CPD.Candidate_Id   
left join Tbl_Candidate_ContactDetails CCD on CPD.Candidate_Id=CCD.candidate_Id  
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id    
left join Tbl_Employee E on E.Employee_Id=SD.MarketingVerifyBy   
left Join Tbl_Employee EA on EA.Employee_Id=SD.AdmissionVerifyBy  
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id    
left join tbl_certificate_master CM on CM. id= SD.DocType left join dbo.Tbl_Course_Batch_Duration AS bd ON NA.Batch_Id = bd.Batch_Id             
left join Tbl_IntakeMaster im on im.id=bd.intakemasterid  where (((CONVERT(date,Sd.CreatedDateDate)) >= @Fromdate and (CONVERT(date,Sd.CreatedDateDate)) < DATEADD(day,1,@todate))       
                                   OR (@Fromdate IS NULL AND @todate IS NULL)      
                                   OR (@Fromdate IS NULL AND (CONVERT(date,Sd.CreatedDateDate)) < DATEADD(day,1,@todate))      
                                   OR (@todate IS NULL AND (CONVERT(date,Sd.CreatedDateDate)) >= @Fromdate))    
           and( NA.Batch_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''')     
           and(IM.intake_year=@IntakeYear or @IntakeYear=0) 
           and
           (([Candidate_Fname] like  concat(''%'',@Search ,''%'') )     
    or ([Candidate_Lname] like  concat(''%'',@Search ,''%'')  )    
    or([AdharNumber] like concat(''%'',@Search ,''%'') ))   
    
          ORDER BY ICpassportNo
OFFSET @PageSize * (@CurrentPage - 1) ROWS
FETCH NEXT @PageSize ROWS ONLY
OPTION (RECOMPILE);     
      
  end    
  if(@Flag=1)    
  begin    
   select Count( CPD.Candidate_Id) as counts from (select distinct(DocType),StudentId,MarketingVerifyBy,AdmissionVerifyBy,CreatedDateDate from tbl_StudentDocUpload) SD    
   left join tbl_candidate_personal_det CPD on SD.StudentId=CPD.Candidate_Id  
   left join Tbl_Candidate_ContactDetails CCD on CPD.Candidate_Id=CCD.candidate_Id   
   left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id   
   left join Tbl_Employee E on E.Employee_Id=SD.MarketingVerifyBy  
 left Join Tbl_Employee EA on EA.Employee_Id=SD.AdmissionVerifyBy left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id    
 left join tbl_certificate_master CM on CM. id= SD.DocType left join dbo.Tbl_Course_Batch_Duration AS bd ON NA.Batch_Id = bd.Batch_Id             
left join Tbl_IntakeMaster im on im.id=bd.intakemasterid  where (((CONVERT(date,Sd.CreatedDateDate)) >= @Fromdate and (CONVERT(date,Sd.CreatedDateDate)) < DATEADD(day,1,@todate))       
                                   OR (@Fromdate IS NULL AND @todate IS NULL)      
                                   OR (@Fromdate IS NULL AND (CONVERT(date,Sd.CreatedDateDate)) < DATEADD(day,1,@todate))      
                                   OR (@todate IS NULL AND (CONVERT(date,Sd.CreatedDateDate)) >= @Fromdate))    
           and( NA.Batch_Id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''')    
             and(IM.intake_year=@IntakeYear or @IntakeYear=0)  
              and
           (([Candidate_Fname] like  concat(''%'',@Search ,''%'') )     
    or ([Candidate_Lname] like  concat(''%'',@Search ,''%'')  )    
    or([AdharNumber] like concat(''%'',@Search ,''%'') ))   
      
  end    
  if(@Flag=2)    
  begin    
  select distinct intake_year from Tbl_IntakeMaster where DeleteStatus=0    
  end    
    
end

    ')
END
GO
