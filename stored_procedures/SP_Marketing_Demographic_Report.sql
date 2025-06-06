IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_Demographic_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Marketing_Demographic_Report] --1,0,0,0,''Others'',''Others'','''',1,100
( 
  @flag bigint=0 ,
  @Batch_Id bigint=0,
  @Country bigint=0,
  @State bigint=0,
  @Race varchar(MAX)='''',
  @Religion varchar(MAX)='''',
  @Gender varchar(MAX)='''',
  @CurrentPage bigint=1,
  @pagesize bigint= 0
)
AS      
BEGIN 

if(@flag=1)
begin
    Declare @UpperBand int
       Declare @LowerBand int

       SET @LowerBand  = (@CurrentPage - 1) * @PageSize
       SET @UpperBand  = (@CurrentPage * @PageSize) + 1 
   if(@Race=''Others'')
   begin
    SELECT * InTO #TEMP3 FROM
    (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
    (select distinct D.Candidate_Id,ApplicationStatus,D.Race,D.Religion,
    Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,Candidate_Email,
    Candidate_Mob1,Candidate_Telephone,Candidate_PermAddress+'' ''+Candidate_parentAddress2 as Permaddress,
    Candidate_ContAddress+''''+Candidate_ContAddress_Line2 as mailingaddress,case when TypeOfStudent=''LOCAL'' then ''Y'' else ''N'' end as citizenship,
    Na.Nationality as Candidate_Nationality,Department_Name,P.Course_Code,0 as Semester,BA.Batch_Code,S.State_Id,
    E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name,case when (Candidate_Hereaboutus is null or Candidate_Hereaboutus='''')then Enquiry_From else  Candidate_Hereaboutus 
 end  as MarketingSource,
    A.Agent_Name,convert(varchar,RegDate,103) as RegDate
    from Tbl_Candidate_Personal_Det D
    Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
    Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
    Left join Tbl_Department P on P.Department_Id=N.Department_Id
    Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
    left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
    left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
    left join Tbl_Nationality Na on convert(varchar(10),NA.Nationality_Id)=convert(varchar(10),D.Candidate_Nationality)
    Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
    left join Tbl_State S on S.State_Id=C.candidate_permaddress_state
    Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
    where  (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'')
    and (@Batch_Id=0 or N.Batch_Id=@Batch_Id or N.Batch_Id='''' )
    and (@Country=0 or C.Candidate_PermAddress_Country=@Country or @Country='''' )
    and (@State=0 or C.candidate_permaddress_state=@State or @State='''' )
    and (D.Race!=''0'' and D.Race!='' '' and D.Race!=''Bumiputra Sabah'' and D.Race!=''Bumiputra Sarawak'' 
    and D.Race!=''Chinese'' and  D.Race!=''Indian'' and D.Race!=''Malay'') 
    and  (D.Religion=@Religion OR @Religion='''' or D.Religion=''0''  or @Religion is null) 
    and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0'' or @Gender is null)
    ))BK  )B
     select * from #TEMP3 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
   end
   
  else if(@Religion=''Others'')
  begin
     SELECT * InTO #TEMP4 FROM
    (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
    (select distinct D.Candidate_Id,ApplicationStatus,D.Race,D.Religion,
    Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,Candidate_Email,
    Candidate_Mob1,Candidate_Telephone,Candidate_PermAddress+'' ''+Candidate_parentAddress2 as Permaddress,
    Candidate_ContAddress+''''+Candidate_ContAddress_Line2 as mailingaddress,case when TypeOfStudent=''LOCAL'' then ''Y'' else ''N'' end as citizenship,
    Na.Nationality as Candidate_Nationality,Department_Name,P.Course_Code,0 as Semester,BA.Batch_Code,S.State_Id,
    E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name,case when (Candidate_Hereaboutus is null or Candidate_Hereaboutus='''')then Enquiry_From else  Candidate_Hereaboutus 
     end  as MarketingSource,
    A.Agent_Name,convert(varchar,RegDate,103) as RegDate
    from Tbl_Candidate_Personal_Det D
    Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
    Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
    Left join Tbl_Department P on P.Department_Id=N.Department_Id
    Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
    left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
    left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
    left join Tbl_Nationality Na on convert(varchar(10),NA.Nationality_Id)=convert(varchar(10),D.Candidate_Nationality)
    Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
    left join Tbl_State S on S.State_Id=C.candidate_permaddress_state
    Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
    where  (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'')
    and (@Batch_Id=0 or N.Batch_Id=@Batch_Id or N.Batch_Id='''' )
    and (@Country=0 or C.Candidate_PermAddress_Country=@Country or @Country='''' )
    and (@State=0 or C.candidate_permaddress_state=@State or @State='''' )
    and (D.Race=@Race or @Race='''' or @Race=''0'' or @Race is null) 
    and  (D.Religion!=''Islam'' and D.Religion!=''Buddhism'' and D.Religion!=''Christian'' and D.Religion!=''Hinduism'' 
    and D.Religion!=''Sikhism'' and D.Religion!=''''  and D.Religion!=''--Select--'') 
    and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0'' or @Gender is null)
    ))BK  )B
     select * from #TEMP4 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 end
  else if(@Race=''Others'' and @Religion=''Others'')
  begin

    SELECT * InTO #TEMP5 FROM
    (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
    (select distinct D.Candidate_Id,ApplicationStatus,D.Race,D.Religion,
    Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,Candidate_Email,
    Candidate_Mob1,Candidate_Telephone,Candidate_PermAddress+'' ''+Candidate_parentAddress2 as Permaddress,
    Candidate_ContAddress+''''+Candidate_ContAddress_Line2 as mailingaddress,case when TypeOfStudent=''LOCAL'' then ''Y'' else ''N'' end as citizenship,
    Na.Nationality as Candidate_Nationality,Department_Name,P.Course_Code,0 as Semester,BA.Batch_Code,S.State_Id,
    E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name,case when (Candidate_Hereaboutus is null or Candidate_Hereaboutus='''')then Enquiry_From else  Candidate_Hereaboutus 
 end  as MarketingSource,
    A.Agent_Name,convert(varchar,RegDate,103) as RegDate
    from Tbl_Candidate_Personal_Det D
    Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
    Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
    Left join Tbl_Department P on P.Department_Id=N.Department_Id
    Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
    left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
    left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
    left join Tbl_Nationality Na on convert(varchar(10),NA.Nationality_Id)=convert(varchar(10),D.Candidate_Nationality)
    Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
    left join Tbl_State S on S.State_Id=C.candidate_permaddress_state
    Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
    where  (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'')
    and (@Batch_Id=0 or N.Batch_Id=@Batch_Id or N.Batch_Id='''' )
    and (@Country=0 or C.Candidate_PermAddress_Country=@Country or @Country='''' )
    and (@State=0 or C.candidate_permaddress_state=@State or @State='''' )
    and (D.Race!=''0'' and D.Race!='' '' and D.Race!=''Bumiputra Sabah'' and D.Race!=''Bumiputra Sarawak'' 
    and D.Race!=''Chinese'' and  D.Race!=''Indian'' and D.Race!=''Malay'') 
    and  (D.Religion!=''Islam'' and D.Religion!=''Buddhism'' and D.Religion!=''Christian'' and D.Religion!=''Hinduism'' 
    and D.Religion!=''Sikhism'' and D.Religion!=''''  and D.Religion!=''--Select--'') 
    and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0'' or @Gender is null)
    ))BK  )B
     select * from #TEMP5 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 end
 else
   begin
     SELECT * InTO #TEMP1 FROM
    (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
    (select distinct D.Candidate_Id,ApplicationStatus,D.Race,D.Religion,
    Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,Candidate_Email,
    Candidate_Mob1,Candidate_Telephone,Candidate_PermAddress+'' ''+Candidate_parentAddress2 as Permaddress,
    Candidate_ContAddress+''''+Candidate_ContAddress_Line2 as mailingaddress,case when TypeOfStudent=''LOCAL'' then ''Y'' else ''N'' end as citizenship,
    Na.Nationality as Candidate_Nationality,Department_Name,P.Course_Code,0 as Semester,BA.Batch_Code,S.State_Id,
    E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name,case when (Candidate_Hereaboutus is null or Candidate_Hereaboutus='''')then Enquiry_From else  Candidate_Hereaboutus 
 end  as MarketingSource,
    A.Agent_Name,convert(varchar,RegDate,103) as RegDate
    from Tbl_Candidate_Personal_Det D
    Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
    Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
    Left join Tbl_Department P on P.Department_Id=N.Department_Id
    Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
    left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
    left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
    left join Tbl_Nationality Na on convert(varchar(10),NA.Nationality_Id)=convert(varchar(10),D.Candidate_Nationality)
    Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
    left join Tbl_State S on S.State_Id=C.candidate_permaddress_state
    Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
    where  (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'')
    and (@Batch_Id=0 or N.Batch_Id=@Batch_Id or N.Batch_Id='''' )
    and (@Country=0 or C.Candidate_PermAddress_Country=@Country or @Country='''' )
    and (@State=0 or C.candidate_permaddress_state=@State or @State='''' )
    and (D.Race=@Race or @Race='''' or @Race=''0'' or @Race is null) 
    and  (D.Religion=@Religion OR @Religion='''' or D.Religion=''0''  or @Religion is null) 
    and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0'' or @Gender is null)
    ))BK  )B
     select * from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 end
 end
if(@flag=2)
  begin

      SELECT * InTO #TEMP2 FROM
    (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
    (select distinct D.Candidate_Id,ApplicationStatus,D.Race,D.Religion,
    Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,Candidate_Email,
    Candidate_Mob1,Candidate_Telephone,Candidate_PermAddress+'' ''+Candidate_parentAddress2 as Permaddress,
    Candidate_ContAddress+''''+Candidate_ContAddress_Line2 as mailingaddress,case when TypeOfStudent=''LOCAL'' then ''Y'' else ''N'' end as citizenship,
    Na.Nationality as Candidate_Nationality,Department_Name,P.Course_Code,0 as Semester,BA.Batch_Code,S.State_Id,
    E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name,case when (Candidate_Hereaboutus is null or Candidate_Hereaboutus='''')then Enquiry_From else  Candidate_Hereaboutus 
 end as MarketingSource,
    A.Agent_Name,convert(varchar,RegDate,103) as RegDate
    from Tbl_Candidate_Personal_Det D
    Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
    Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
    Left join Tbl_Department P on P.Department_Id=N.Department_Id
    Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
    left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
    left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
    left join Tbl_Nationality Na on convert(varchar(10),NA.Nationality_Id)=convert(varchar(10),D.Candidate_Nationality)
    Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
    left join Tbl_State S on S.State_Id=C.candidate_permaddress_state
    Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
    where  (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'')
    and (@Batch_Id=0 or N.Batch_Id=@Batch_Id or N.Batch_Id='''' )
    and (@Country=0 or C.Candidate_PermAddress_Country=@Country or @Country='''' )
    and (@State=0 or C.candidate_permaddress_state=@State or @State='''' )
    and (D.Race=@Race or @Race='''' or @Race=''0'' or @Race is null) 
    and  (D.Religion=@Religion OR @Religion='''' or D.Religion=''0''  or @Religion is null) 
    and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0'' or @Gender is null)
    ))BK  )B
    select count(Candidate_Id) as totcount from #TEMP2   
  end          

END

    ')
END
