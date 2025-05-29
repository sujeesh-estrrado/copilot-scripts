IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_Payment_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Marketing_Payment_Report] 
    -- [dbo].[SP_Marketing_Payment_Report]1,0,0,0,0,1,100
    @flag int ,
    --@IntakeId bigint=0,
    @Department_Id bigint =0 ,
    @coursetype bigint=0,
    @Agent_ID bigint=0,
    @Employee_Id bigint =0,
    @CurrentPage bigint=0,
    @pagesize bigint= 0
    --@id int =0 output 
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
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,
        Candidate_Mob1,Department_Name,P.Course_Code,E.Employee_FName+'' ''+Employee_LName as CounselorName,
        A.Agent_Name,D.IDMatrixNo,b.outstandingbalance  ,CASE WHEN outstandingbalance <= 0  THEN ''Paid'' WHEN outstandingbalance > 0 THEN ''UnPaid'' 
        WHEN outstandingbalance is null THEN ''UnPaid'' END AS PaidStatus,
    bd.Batch_Code as Intake
        from Tbl_Candidate_Personal_Det D
        Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
        Left join Tbl_Department P on P.Department_Id=N.Department_Id
        left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
        Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
        left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
        left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
        left join Tbl_Course_Category cc on cc.Course_Category_Id=CD.Course_Category_Id
        left join student_bill b on b.studentid=d.Candidate_Id
        left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
        where  
        (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or
         ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'') and
          (@Employee_Id=0 or E.Employee_Id=@Employee_Id or @Employee_Id=''''  or @Employee_Id is null)
        and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null) 
        and (@Agent_ID=0 or D.Agent_ID =@Agent_ID or @Agent_ID='''' or @Agent_ID is null)
        and (@coursetype=0 or CD.Course_Category_Id =@coursetype or @coursetype='''' or @coursetype is null)
        and ( N.Batch_Id in (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))
        ))BK  )B
         select slno,Candidate_Id, Candidatename,AdharNumber,
        Candidate_Mob1,''Staff: ''+ CounselorName as CounselorName,''Agent: ''+ Agent_Name as Agent_Name,
        Course_Code+'' - ''+Department_Name as Course_Department,
        IDMatrixNo,outstandingbalance, PaidStatus,
    Intake  from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 
 end
if(@flag=2)
    begin

          SELECT * InTO #TEMP2 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
        (select distinct D.Candidate_Id,
        Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,
        Candidate_Mob1,Department_Name,P.Course_Code,E.Employee_FName+'' ''+Employee_LName as CounselorName,
        A.Agent_Name,D.IDMatrixNo,b.outstandingbalance  ,CASE WHEN outstandingbalance < 0 THEN ''Paid'' WHEN outstandingbalance >0 THEN ''UnPaid'' 
        WHEN outstandingbalance =NULL THEN ''UnPaid''END AS PaidStatus,
    bd.Batch_Code as Intake
        from Tbl_Candidate_Personal_Det D
        Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
        Left join Tbl_Department P on P.Department_Id=N.Department_Id
        left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
        Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
        left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
        left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
        left join Tbl_Course_Category cc on cc.Course_Category_Id=CD.Course_Category_Id
        left join student_bill b on b.studentid=d.Candidate_Id
        left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
        where  
        (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or
         ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'') and
          (@Employee_Id=0 or E.Employee_Id=@Employee_Id or @Employee_Id=''''  or @Employee_Id is null)
        and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null) 
        and (@Agent_ID=0 or D.Agent_ID =@Agent_ID or @Agent_ID='''' or @Agent_ID is null)
        and (@coursetype=0 or CD.Course_Category_Id =@coursetype or @coursetype='''' or @coursetype is null)
        and ( N.Batch_Id in (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))
        ))BK  )B
        select count(Candidate_Id) as totcount from #TEMP2   
    end          
    --select * from Tbl_Candidate_Personal_Det where C
END

    --  Declare @UpperBand int
    --     Declare @LowerBand int

    --     SET @LowerBand  = (@CurrentPage - 1) * @PageSize
    --     SET @UpperBand  = (@CurrentPage * @PageSize) + 1 
   
    --   SELECT * InTO #TEMP1 FROM
    --  (SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id desc) AS slno,BK.*  FROM(        
    --  (select distinct D.Candidate_Id,
    --  Candidate_Fname+'' ''+Candidate_Lname as Candidatename,AdharNumber,
    --  Candidate_Mob1,Department_Name,P.Course_Code,E.Employee_FName+'' ''+Employee_LName as CounselorName,
    --  A.Agent_Name,D.IDMatrixNo,b.outstandingbalance  ,CASE WHEN outstandingbalance < 0 THEN ''Paid'' WHEN outstandingbalance >0 THEN ''UnPaid'' 
    --  WHEN outstandingbalance =NULL THEN ''UnPaid''END AS PaidStatus,
    --bd.Batch_Code as Intake
    --  from Tbl_Candidate_Personal_Det D
    --  Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
    --  Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
    --  Left join Tbl_Department P on P.Department_Id=N.Department_Id
    --  left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
    --  Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
    --  left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
    --  left join Tbl_Candidate_Additionalqualification AQ on AQ.Candidate_Id=D.Candidate_Id
    --  left join Tbl_Course_Category cc on cc.Course_Category_Id=CD.Course_Category_Id
    --  left join student_bill b on b.studentid=d.Candidate_Id
    --  left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
    --  where  
    --  (ApplicationStatus=''Pending'' or ApplicationStatus=''Conditional_Admission'' or ApplicationStatus=''Verified'' or ApplicationStatus=''approved''or
    --   ApplicationStatus=''submited'' or ApplicationStatus=''Preactivated'') and
    --    (@Employee_Id=0 or E.Employee_Id=@Employee_Id or @Employee_Id=''''  or @Employee_Id is null)
    --  and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null) 
    --  and (@Agent_ID=0 or D.Agent_ID =@Agent_ID or @Agent_ID='''' or @Agent_ID is null)
    --  and (@coursetype=0 or CD.Course_Category_Id =@coursetype or @coursetype='''' or @coursetype is null)
    --  and ( N.Batch_Id in (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))
    --  ))BK  )B
    --   select slno,Candidate_Id, Candidatename,AdharNumber,
    --  Candidate_Mob1,Department_Name,Course_Code,''Staff: ''+ CounselorName as CounselorName,''Agent: ''+ Agent_Name as Agent_Name,
    --  IDMatrixNo,outstandingbalance, PaidStatus,
    --Intake from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
    ----end


--END
--select Candidate_Id,IDMatrixNo,ApplicationStatus from Tbl_Candidate_Personal_Det');
END;
