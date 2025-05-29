IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Agent_StudentClearance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_Get_Agent_StudentClearance]  --0,152773  
 @flag bigint  =0,  
 @studentid bigint=0,  
 @ProgramID bigint=0,  
 @Feegroupid bigint=0  
AS    
BEGIN    
if(@flag=0) --Student Details
 begin  
  select active,Candidate_Id,AdharNumber,CPD.New_Admission_Id,NA.Batch_Id,TypeOfStudent,NA.Department_Id   
  from Tbl_Candidate_Personal_Det CPD  
  inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id  
  where CPD.Candidate_Id=@studentid  
 end  
if(@flag=1) --Get Fee group  
 begin  
  select FeeGroupID,FeeGroupCode   
  from tbl_Student_AccountGroup_Map   
  where StudentID=@studentid and ProgrmID=@ProgramID  
 end   
 if(@flag=2)  --Get Outstanding Balance of Candidate ( 0,-1, 1st sem)
 begin  
 select sum(outstandingbalance)as outstandingbalance    
 from student_bill b   
 inner join Tbl_AutoInvoiceLog AL on AL.Billid=b.billid  
 where b.billcancel =0 and AL.Billid<>0 and AL.Semester in(-1,0,1) and AL.StudentId=@studentid and AL.Feegroupid=@Feegroupid  
 end   
  if(@flag=3)  --Get total Outstanding Balance of Candidate 
 begin  
 select sum(outstandingbalance)as outstandingbalance    
 from student_bill b   
 inner join Tbl_AutoInvoiceLog AL on AL.Billid=b.billid  
 where b.billcancel =0 and 
 AL.Billid<>0  and 
 AL.StudentId=@studentid and AL.Feegroupid=@Feegroupid  
 end 
   if(@flag=4)  --Get total Commission Amount of Agent by Candidate 
 begin  
	select Sum(CG.International_Amount)as International_Amount,sum(CG.Local_Amount) as Local_Amount 
	from Tbl_Agent_Invoice AI
	inner join Tbl_Candidate_Personal_Det CPD on AI.Candidate_Id=CPD.Candidate_Id
	Inner join tbl_New_Admission NA on NA.New_Admission_Id=CPD.New_Admission_Id
	inner join Tbl_CommissionMapping CM on CM.Programme_Id= NA.Department_Id and CM.Intake_Id=NA.Batch_Id 
		 and CM.Faculty_Id=NA.Course_Level_Id
	left join Tbl_CommissionGroup CG on CG.Commission_GroupId=CM.Commission_Group_Id
	
	where AI.Candidate_Id=@studentid 
	--group by CG.FacultyId,CG.ProgrammeId,CG.IntakeId
 end 
END    

    ')
END
