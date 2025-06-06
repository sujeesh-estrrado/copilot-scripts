IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Tabulation_report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Tabulation_report] --1,0,0,0,''SPM'',1,100
    (
    @Flag int,
    @ProgramType bigint=0,
    @Program bigint=0,
    @Intake bigint=0,
    @Qualification varchar(max)='''',
    @CurrentPage bigint=1,
    @pagesize bigint= 0
    )
AS
BEGIN
    Declare @UpperBand int
           Declare @LowerBand int

           SET @LowerBand  = (@CurrentPage - 1) * @PageSize
           SET @UpperBand  = (@CurrentPage * @PageSize) + 1 
    if(@Flag=1)
            
            Begin
         SELECT * InTO #TEMP1 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(      
        select distinct D.Candidate_Id,Adharnumber,NAi.Course_Category_Id,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,D.Candidate_Gender,IDMatrixNo,case when TypeOfStudent=''Local'' then ''Not Required'' else ''Required'' end as englishrequired,
        DA.Department_Name,Nationality,InstitutionName,N.Institution_Level,N.Yearof_Pass,case when(exists (select * from Tbl_Candidate_Englishtest where Cand_Id=D.Candidate_Id))
        then ''pass'' else ''fail'' end as ERStatus,case when Candidate_Img is null or 
Candidate_Img=''''
        then ''No'' else ''Yes'' end as PassPortPhoto,case when Institution_Level =''SPM'' or Institution_Level=''O-LEVEL''
        then ''Yes'' else ''No'' end as Spm_Olevel,case when Offerletter_Path is not null or Offerletter_Path=''''
        then 
''Yes'' else ''No'' end as Acceptance_letter,case when Program_Duration_Type=''Years'' then
         (Cast(Program_Duration_Year as varchar) + '' ''+Program_Duration_Type)
         else (Cast(Program_Duration_Sem as varchar) + '' ''+Program_Duration_Type)
         
   end as Duration_Of_Study
            from Tbl_Candidate_Personal_Det D
            inner join Tbl_New_admission NAi on NAi.New_Admission_Id=D.New_Admission_Id 
            Inner join Tbl_Candidate_Additionalqualification  C on C.Candidate_Id=D.Candidate_Id
            Left join Tbl_Candidate_EducationDetails N on N.Candidate_Id =D.Candidate_Id
            Left join Tbl_Candidate_Education_Grade P on P.Cand_Id=N.Candidate_Id
            left join tbl_New_Admission CL on CL.New_Admission_Id=D.New_Admission_Id
            left join Tbl_Department DA on DA.Department_Id=CL.Department_Id
            left join Tbl_Nationality NA on NA.Nationality_Id=D.Candidate_Nationality
            left join Tbl_Candidate_Englishtest CE on CE.Cand_Id=D.Candidate_Id
            inner  join Tbl_Course_Batch_Duration CBD on CBD.Batch_id=NAi.Batch_id
            left join Tbl_Offerlettre OL on OL.candidate_id=D.Candidate_Id
            inner join Tbl_Program_Duration PD on PD.Duration_Id=CBD.Duration_Id
            where ApplicationStatus=''Completed'' and  N.Institution_level=@Qualification 
            )BK  )B
         select * from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 
    end 

    if(@Flag=2)
        begin
        select Sub_Name,Sub_Grade,Sub_other from Tbl_Candidate_Education_Grade Where Education_Type=''Secondary'' and Cand_Id=59 and Sub_other!=''Other'' or Sub_other is null

        end
        
if(@Flag=3)
            
            Begin
         SELECT * InTO #TEMP2 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(      
        select distinct D.Candidate_Id,Adharnumber,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,D.Candidate_Gender,IDMatrixNo,case when TypeOfStudent=''Local'' then ''Not Required'' else ''Required'' end as englishrequired,
        DA.Department_Name,Nationality,InstitutionName,N.Institution_Level,N.Yearof_Pass,case when(exists (select * from Tbl_Candidate_Englishtest where Cand_Id=D.Candidate_Id))
        then ''pass'' else ''fail'' end as ERStatus,case when Candidate_Img is null or 
Candidate_Img=''''
        then ''No'' else ''Yes'' end as PassPortPhoto,case when Institution_Level =''SPM'' or Institution_Level=''O-LEVEL''
        then ''Yes'' else ''No'' end as Spm_Olevel,case when Offerletter_Path is not null or Offerletter_Path=''''
        then 
''Yes'' else ''No'' end as Acceptance_letter,case when Program_Duration_Type=''Years'' then
         (Cast(Program_Duration_Year as varchar) + '' ''+Program_Duration_Type)
         else (Cast(Program_Duration_Sem as varchar) + '' ''+Program_Duration_Type)
         
   end as Duration_Of_Study
            from Tbl_Candidate_Personal_Det D
            inner join Tbl_New_admission NAi on NAi.New_Admission_Id=D.New_Admission_Id 
            Inner join Tbl_Candidate_Additionalqualification  C on C.Candidate_Id=D.Candidate_Id
            Left join Tbl_Candidate_EducationDetails N on N.Candidate_Id =D.Candidate_Id
            Left join Tbl_Candidate_Education_Grade P on P.Cand_Id=N.Candidate_Id
            left join tbl_New_Admission CL on CL.New_Admission_Id=D.New_Admission_Id
            left join Tbl_Department DA on DA.Department_Id=CL.Department_Id
            left join Tbl_Nationality NA on NA.Nationality_Id=D.Candidate_Nationality
            left join Tbl_Candidate_Englishtest CE on CE.Cand_Id=D.Candidate_Id
            inner  join Tbl_Course_Batch_Duration CBD on CBD.Batch_id=NAi.Batch_id
            left join Tbl_Offerlettre OL on OL.candidate_id=D.Candidate_Id
            inner join Tbl_Program_Duration PD on PD.Duration_Id=CBD.Duration_Id
            where ApplicationStatus=''Completed'' and  N.Institution_level=@Qualification
            )BK  )B
         select count(Candidate_Id) as totcount from #TEMP2 
         end
END
    ');
END
