IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_StudentFeePending_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[sp_Finance_StudentFeePending_Report]  --1,0,0,0,1,47
(
@flag bigint = 0,
@ProgrammeType bigint = 0,
@Intake bigint = 0,
@PgmID bigint = 0,
@Accountcode bigint = 0,
@StudentId bigint = 0
)
as

begin
if(@flag=0)
begin
select distinct PD.Candidate_Id,Concat(Candidate_Fname,Candidate_Lname)as studentName,
concat(D.Course_Code,''-'',D.Department_Name) as Department_Name,IM.intake_no as Batch_Code,IDMatrixNo,AdharNumber,IM.Batch_Code,
0.00 as payable,0.00 as paid,0.00 as balance
 from tbl_Candidate_Personal_Det PD
left join tbl_New_Admission NA on NA.New_Admission_Id=PD.New_Admission_Id
left join Tbl_Department D on D.Department_Id=NA.Department_Id
left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id
   left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterID
left join student_bill SB on SB.studentid=PD.Candidate_Id 
where ApplicationStatus=''Completed''and 
(NA.Course_Category_Id=@ProgrammeType or @ProgrammeType=0) and
(@Intake=0 or IM.id=@Intake) and (@PgmID=0 or NA.Department_Id=@PgmID) 

end
if(@flag=1)
begin
select isnull(sum(SB.totalamountpayable-SB.adjustmentamount),0.00) as payable,
isnull(sum(sb.totalamountpaid),0.00) as paid,
isnull(sum(SB.outstandingbalance-SB.adjustmentamount),0.00)as balance from student_bill SB where studentid=@StudentId
  and (SB.accountcodeid=@Accountcode or @Accountcode=0)

end

end
    ');
END
GO