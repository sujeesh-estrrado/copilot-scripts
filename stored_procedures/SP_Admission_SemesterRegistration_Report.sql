IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_SemesterRegistration_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Admission_SemesterRegistration_Report] --2,0,0,0,'''',1,0
(   
    @flag bigint=0 ,
    @Intake bigint=0,
    @Faculty bigint=0,
    @Program bigint=0,
    @Semester varchar(MAX)='''',
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
 
         SELECT * InTO #TEMP1 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,IDMatrixNo,Department_Name + '' - ''+BA.Batch_Code as accademicsession,
        P.Course_Code,SEMESTER_NO,''Not Registered'' as Registration,''Completed'' as Academicstatus,N.Department_Id as Department,N.Batch_Id as Intake,N.Course_Level_Id as Faculty
        
        
        from Tbl_Candidate_Personal_Det D
        Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
        Left join Tbl_Department P on P.Department_Id=N.Department_Id
        Left join Tbl_Student_Semester S on D.Candidate_Id=S.Candidate_Id
        Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
        where  (ApplicationStatus=''Completed'' )
        and (@Intake=0 or N.Batch_Id=@Intake or N.Batch_Id='''' or N.Batch_Id=0 or N.Batch_Id is null)
        and (@Faculty=0 or N.Course_Level_Id=@Faculty or N.Course_Level_Id='''' or N.Course_Level_Id=0 or N.Course_Level_Id is null)
        and (@Program=0 or N.Department_Id=@Program or N.Department_Id='''' or N.Department_Id=0 or N.Department_Id is null)
        and (@Semester=0 or S.SEMESTER_NO=@Semester or S.SEMESTER_NO='''' or S.SEMESTER_NO=0 )
       --and (@Semester=0 or S.Semester_Id=@Semester or S.Semester_Id='''' or S.Semester_Id=0 )
        ))BK  )B
         select * from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 
 end
 if(@flag=2)

        
   begin
         SELECT * InTO #TEMP2 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,IDMatrixNo,Department_Name + '' - ''+BA.Batch_Code as accademicsession,
        P.Course_Code,SEMESTER_NO,''Not Registered'' as Registration,'' '' as Academicstatus
        
        
        from Tbl_Candidate_Personal_Det D
        Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
        Left join Tbl_Department P on P.Department_Id=N.Department_Id
        Left join Tbl_Student_Semester S on D.Candidate_Id=S.Candidate_Id
        Left join Tbl_Course_Batch_Duration BA on BA.Batch_Id=N.Batch_Id
        where  (ApplicationStatus=''Completed'')
        and (@Intake=0 or N.Batch_Id=@Intake or N.Batch_Id='''' or N.Batch_Id=0 or N.Batch_Id is null)
        and (@Faculty=0 or N.Course_Level_Id=@Faculty or N.Course_Level_Id='''' or N.Course_Level_Id=0 or N.Course_Level_Id is null)
        and (@Program=0 or N.Department_Id=@Program or N.Department_Id='''' or N.Department_Id=0 or N.Department_Id is null)
        and (@Semester=0 or S.SEMESTER_NO=@Semester or S.SEMESTER_NO='''' or S.SEMESTER_NO=0 )
               --and (@Semester=0 or S.Semester_Id=@Semester or S.Semester_Id='''' or S.Semester_Id=0 )
        ))BK  )B
         select Count(Candidate_Id)as totcount from #TEMP2     
 end
END
 --select * from Tbl_Student_Semester
    ')
END;
