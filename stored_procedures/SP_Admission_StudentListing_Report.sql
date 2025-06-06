IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_StudentListing_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Admission_StudentListing_Report]
    --[dbo].[SP_Admission_StudentListing_Report] 1,0,0,0,0,'''','''',1,10
@flag int ,
    @Batch_Id bigint=0,
    @Country bigint=0,
    @State bigint=0,
    @Race varchar(500)='''',
    @Religion varchar(500)='''',
    @Gender varchar(500)='''',
    @CurrentPage bigint=0,
    @pagesize bigint= 0

AS      
BEGIN 

if(@flag=1)
begin
        Declare @UpperBand int
           Declare @LowerBand int

           SET @LowerBand  = (@CurrentPage - 1) * @PageSize
           SET @UpperBand  = (@CurrentPage * @PageSize) + 1 
   
         SELECT * InTO #TEMP1 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id,ApplicationStatus,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,
        Candidate_Email,Candidate_Mob1,Candidate_Telephone,Candidate_Guardian_Mob,Candidate_PermAddress,
        --Na.Nationality as Candidate_Nationality,
        Department_Name,P.Course_Code,Diocese,E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name as Sponsorship,
        A.Agent_Name,convert(varchar,RegDate,103) as RegDate,D.IDMatrixNo
        ,s.State_Name,  CASE WHEN D.TypeOfStudent = ''LOCAL'' THEN ''Y''
            WHEN D.TypeOfStudent = ''INTERNATIONAL'' THEN ''N''
            END AS Citizenship,D.TypeOfStudent ,CS.Semester_Name,B.Batch_Code as Intake
        from Tbl_Candidate_Personal_Det D
        left join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
        Left join Tbl_Department P on P.Department_Id=N.Department_Id
        Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
        left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
        left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
        --left join Tbl_Nationality Na on NA.Nationality_Id=D.Candidate_Nationality
        Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
        left join Tbl_State S on s.State_Id=C.candidate_permaddress_state
        left join Tbl_Student_Semester ST on ST.Candidate_Id=D.Candidate_Id
        left join Tbl_Course_Semester CS on CS.Semester_Id=ST.SEMESTER_NO
        left join Tbl_Course_Batch_Duration B on N.Batch_Id=B.Batch_Id
        left join Tbl_IntakeMaster IM on IM.id=B.IntakeMasterID
        where  ApplicationStatus=''Completed'' 
        and (@Batch_Id=0 or IM.id=@Batch_Id )
        and (@Country=0 or C.Candidate_PermAddress_Country=@Country )and
         (@State=0 or C.Candidate_ContAddress_State=@State or @State=''0'' )
    and   (  (@Race = ''Others'' AND D.Race NOT IN (''Malay'', ''Chinese'', ''Indian'', ''Other Known Races'',''Bumiputra Sabah'',''Bumiputra Sarawak'','''')) or(D.Race=@Race OR @Race='''' OR @Race=''0'') )
        and   ((@Religion = ''Others'' AND D.Religion NOT IN (''Islam'', ''Buddhism'', ''Christian'', ''Hinduism'', ''Sikhism''))  or (D.Religion=@Religion OR @Religion=''--Select--'' or @Religion='''' or @Religion=''0'' ))and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0''  )
        and ( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0''  )
        ))BK  )B
         select * from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 
 end
if(@flag=2)
    begin

          SELECT * InTO #TEMP2 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id,ApplicationStatus,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,Candidate_Gender,
        Candidate_Email,Candidate_Mob1,Candidate_Telephone,Candidate_Guardian_Mob,Candidate_PermAddress,
        --Na.Nationality as Candidate_Nationality,
        Department_Name,P.Course_Code,Diocese,E.Employee_FName+'' ''+Employee_LName as CounselorName,EnrollBy,Scolorship_Name as Sponsorship,
        A.Agent_Name,convert(varchar,RegDate,103) as RegDate,D.IDMatrixNo
        ,s.State_Name,  CASE WHEN D.TypeOfStudent = ''LOCAL'' THEN ''Y''
            WHEN D.TypeOfStudent = ''INTERNATIONAL'' THEN ''N''
            END AS  Citizenship,D.TypeOfStudent ,CS.Semester_Name,B.Batch_Code as Intake
        from Tbl_Candidate_Personal_Det D
        Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
        Left join Tbl_Department P on P.Department_Id=N.Department_Id
        Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
        left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
        left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
        --left join Tbl_Nationality Na on NA.Nationality_Id=D.Candidate_Nationality
        Left join Tbl_FollowUp_Detail F on F.Candidate_Id=D.Candidate_Id
        left join Tbl_State S on s.State_Id=C.candidate_permaddress_state
        left join Tbl_Student_Semester ST on ST.Candidate_Id=D.Candidate_Id
        left join Tbl_Course_Semester CS on CS.Semester_Id=ST.SEMESTER_NO
        left join Tbl_Course_Batch_Duration B on N.Batch_Id=B.Batch_Id
        left join Tbl_IntakeMaster IM on IM.id=B.IntakeMasterID
        where  ApplicationStatus=''Completed'' and (@Batch_Id=0 or IM.id=@Batch_Id or @Batch_Id=''''  )
        and (@Country=0 or C.Candidate_PermAddress_Country=@Country or @Country='''' )and
         (@State=0 or C.Candidate_ContAddress_State=@State or @State=''0'' )
        and (  (@Race = ''Others'' AND D.Race NOT IN (''Malay'', ''Chinese'', ''Indian'', ''Other Known Races'',''Bumiputra Sabah'',''Bumiputra Sarawak'','''')) or (D.Race=@Race OR @Race='''' OR @Race=''0'')) 
        --and  (D.Religion=@Religion OR @Religion=''--Select--'' or @Religion='''' or @Religion=''0'' ) 
        and ((@Religion = ''Others'' AND D.Religion NOT IN (''Islam'', ''Buddhism'', ''Christian'', ''Hinduism'', ''Sikhism'')) or (D.Religion=@Religion OR @Religion=''--Select--'' or @Religion='''' or @Religion=''0'' ))and( D.Candidate_Gender=@Gender or @Gender='''' or @Gender=''0''  )
        ))BK  )B
        select count(Candidate_Id) as totcount from #TEMP2   
    end          
    --select * from Tbl_Candidate_Personal_Det where C
END
    ')
END
