IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_StudentSummary_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Admission_StudentSummary_Report] --1,0,0,0,0,0,0,1,100

(@flag int,
@intake bigint=0,
@ProgramType bigint=0,
@Program  bigint=0,
@Faculty bigint=0,
@CurrentPage bigint=0,
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
        (select ROW_NUMBER() OVER(ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id, 
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,IDMatrixNo,
        E.Employee_FName+'' ''+Employee_LName as CounselorName,Course_Level_Name,
            A.Agent_Name,Department_Name,P.Course_Code,bd.Batch_Code as Intake,D.CounselorEmployee_id
            from Tbl_Candidate_Personal_Det D
            Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
            Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
            Left join Tbl_Department P on P.Department_Id=N.Department_Id
            Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
            left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
            left join Tbl_Course_Level CL on CL.Course_Level_Id=N.Course_Level_Id
            left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
            where ApplicationStatus=''Completed'' 
            and (@ProgramType=0 or N.Course_Category_Id=@ProgramType) 
            and (@Program=0 or N.Department_Id=@Program)
            and (@Faculty=0 or N.Course_Level_Id=@Faculty)
            and (N.Batch_Id=@intake or @intake=0 )
            ))BK)B
            select *  from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)   
    end 

 
END
    ')
END
