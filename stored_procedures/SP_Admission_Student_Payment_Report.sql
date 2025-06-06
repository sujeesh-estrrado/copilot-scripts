IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_Student_Payment_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Admission_Student_Payment_Report] 
    -- [dbo].[SP_Admission_Student_Payment_Report]1,0,0,1,100
    @flag int ,
    --@IntakeId bigint=0,
    @Department_Id bigint =0 ,
    @coursetype bigint=0,
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
            (SELECT ROW_NUMBER() OVER (ORDER BY Department_Id desc) AS slno,BK.*  FROM(        
                (select distinct Department_Name,N.Department_Id,bd.Batch_Code as Intake,P.Course_Code+'' ''+Department_Name as Course_Department
                        ---UnPaid----
                    ,(select COUNT(*)  from Tbl_Candidate_Personal_Det D
                        Left join tbl_New_Admission N2 on N2.New_Admission_Id=D.New_Admission_Id
                        left join Tbl_Course_Department CD  on CD.Department_Id=N2.Department_Id
                        left join student_bill b on b.studentid=d.Candidate_Id
                        WHERE outstandingbalance>0 and CD.Department_Id=N.Department_Id )as Unpaid
                        ---Paid----
                     ,(select COUNT(*)  from Tbl_Candidate_Personal_Det D
                            Left join tbl_New_Admission N3 on N3.New_Admission_Id=D.New_Admission_Id
                            left join Tbl_Course_Department CD  on CD.Department_Id=N3.Department_Id
                            left join student_bill b on b.studentid=d.Candidate_Id
                            WHERE outstandingbalance<=0 and CD.Department_Id=N.Department_Id)as paid
                from Tbl_Candidate_Personal_Det D
                Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
                Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
                Left join Tbl_Department P on P.Department_Id=N.Department_Id
                left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
                left join Tbl_Course_Category cc on cc.Course_Category_Id=CD.Course_Category_Id
                left join student_bill b on b.studentid=d.Candidate_Id
                left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
                where  ApplicationStatus=''Completed''
                and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null) 
                and (@coursetype=0 or CD.Course_Category_Id =@coursetype or @coursetype='''' or @coursetype is null)
                and ( N.Batch_Id in (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))
                ))BK  )B
         select  * ,''paid: ''+CONVERT(varchar(100),paid )+'' | ''+''Unpaid: ''+ CONVERT(varchar(100),Unpaid) as Deposit
         --,''Staff: ''+ CounselorName as CounselorName,''Agent: ''+ Agent_Name as Agent_Name,
     from #TEMP1 where slno >  CONVERT(VARCHAR,@LowerBand)   AND slno <  CONVERT(VARCHAR, @UpperBand)    
 
 end
if(@flag=2)
    begin

          SELECT * InTO #TEMP2 FROM
        (SELECT ROW_NUMBER() OVER (ORDER BY Department_Name desc) AS slno,BK.*  FROM(        
        (select distinct Department_Name,CD.Department_Id,bd.Batch_Code as Intake,P.Course_Code+'' ''+Department_Name as Course_Department
                        ---UnPaid----
                    ,(select COUNT(*)  from Tbl_Candidate_Personal_Det D
                        Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
                        left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
                        left join student_bill b on b.studentid=d.Candidate_Id
                        WHERE outstandingbalance>0 and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null))as Unpaid
                        ---Paid----
                     ,(select COUNT(*)  from Tbl_Candidate_Personal_Det D
                            Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
                            left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
                            left join student_bill b on b.studentid=d.Candidate_Id
                            WHERE outstandingbalance<0 and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null))as paid
                from Tbl_Candidate_Personal_Det D
                Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
                Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
                Left join Tbl_Department P on P.Department_Id=N.Department_Id
                left join Tbl_Course_Department CD  on CD.Department_Id=N.Department_Id
                left join Tbl_Course_Category cc on cc.Course_Category_Id=CD.Course_Category_Id
                left join student_bill b on b.studentid=d.Candidate_Id
                left join Tbl_Course_Batch_Duration bd on N.Batch_Id=bd.Batch_Id
                where  ApplicationStatus=''Completed''
                and (@Department_Id=0 or N.Department_Id=@Department_Id or @Department_Id='''' or @Department_Id is null) 
                and (@coursetype=0 or CD.Course_Category_Id =@coursetype or @coursetype='''' or @coursetype is null)
                and ( N.Batch_Id in (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList))
                ))BK  )B
        select count(Department_Name) as totcount from #TEMP2    
    end          
    
END
    ')
END
