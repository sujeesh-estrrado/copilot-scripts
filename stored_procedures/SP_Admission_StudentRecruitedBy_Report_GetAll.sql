IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_StudentRecruitedBy_Report_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Admission_StudentRecruitedBy_Report_GetAll] --1,0,0,0,0,0,0,1,10000,''587,40,43,42,41,44,39,46,50,48,49,47,51,45,611,588,56,54,55,53,57,52,58,63,61,62,60,64,59,589,66,70,68,69,67,71,65,72,74,78,76,77,75,79,73,463,591,81,80,86,84,85,83,87,82,88,89,93,91,92,94''

(@flag int,
@MarketingStaff bigint=0,
@Agent bigint=0,
@ProgramType bigint=0,
@Program  bigint=0,
@Faculty bigint=0,
@Status bigint=0,
@CurrentPage bigint=0,
@pagesize bigint= 0,
@Intake varchar(max)='''',
@Other varchar(max)=''''
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
        concat(Candidate_Fname,'' '',Candidate_Lname) as Candidatename,IDMatrixNo,
       concat( E.Employee_FName,'' '',Employee_LName) as CounselorName,Course_Level_Name,d.recruitedby_other,
            A.Agent_Name,Department_Name,P.Course_Code,bd.Batch_Code as Intake,D.CounselorEmployee_id
            from Tbl_Candidate_Personal_Det D
            Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
            Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
            Left join Tbl_Department P on P.Department_Id=N.Department_Id
            Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
            left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
            left join Tbl_Course_Level CL on CL.Course_Level_Id=N.Course_Level_Id
            left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
                left join Tbl_IntakeMaster IM on IM.id =bd.IntakeMasterID
            where ApplicationStatus=''Completed''
             and (@MarketingStaff=0 or D.CounselorEmployee_id=@MarketingStaff) 
            and (@ProgramType=0 or N.Course_Category_Id=@ProgramType) 
            and (@Program=0 or N.Department_Id=@Program)
            and (@Faculty=0 or N.Course_Level_Id=@Faculty)
            and (@Status='''' or D.active=@Status )
            and (@Agent=0 or A.Agent_ID=@Agent)
            and (@Other='''' or D.recruitedby_other like CONCAT(@Other,''%''))
            and( IM.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''')  
             --and N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
            ))BK)B
            select *  from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)   
    end 

 
if(@flag=2)
    begin

          SELECT * InTO #TEMP2 FROM
        (select ROW_NUMBER() OVER(ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id, 
        concat(Candidate_Fname,'' '',Candidate_Lname) as Candidatename,IDMatrixNo,
       concat( E.Employee_FName,'' '',Employee_LName) as CounselorName,Course_Level_Name,
            A.Agent_Name,Department_Name,P.Course_Code,bd.Batch_Code as Intake,D.CounselorEmployee_id
            from Tbl_Candidate_Personal_Det D
            Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
            Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
            Left join Tbl_Department P on P.Department_Id=N.Department_Id
            Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
            left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
            left join Tbl_Course_Level CL on CL.Course_Level_Id=N.Course_Level_Id
            left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
            left join Tbl_IntakeMaster IM on IM.id =bd.IntakeMasterID
            where ApplicationStatus=''Completed'' and (@MarketingStaff=0 or D.CounselorEmployee_id=@MarketingStaff) 
            and (@ProgramType=0 or N.Course_Category_Id=@ProgramType) 
            and (@Program=0 or N.Department_Id=@Program)
            and (@Faculty=0 or N.Course_Level_Id=@Faculty)
            and (@Agent=0 or A.Agent_ID=@Agent)
            and (@Other='''' or D.recruitedby_other like CONCAT(@Other,''%''))
            and (@Status='''' or D.active=@Status ) 
            and( Im.id IN(SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@Intake, '','')) or @Intake='''')  
            --and N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)
            ))BK)B
        select count(Candidate_Id) as totcount from #TEMP2   
    end    
END
    ')
END
