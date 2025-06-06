IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_StudentAppeal]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_StudentAppeal]                                    
(               
@flag bigint=0 ,              
@StudentAppeal_Id bigint=0 ,              
@Student_Id bigint=0 ,              
@StudentAppeal_Number varchar(MAX)='''' ,              
@Appeal_Date datetime=null,              
@TimetableSerialNumber bigint=0 ,              
@TotalAmount_Tobe_Paid decimal(8, 2)=0 ,              
@TotalAmount__Paid decimal(8,2)=0 ,              
@PaymentStatus bigint=0 ,              
@ApprovalStatus bigint=0 ,              
@Course_Id bigint=0,            
@Approved_By bigint=0            
)              
AS                                      
Begin                                      
if(@flag=0)                
begin                
              
 Select * from Tbl_Student_Appeal_Master AM              
inner join Tbl_Student_Appeal_Child  AC on AC.StudentAppeal_Id=AM.StudentAppeal_Id                      
end                
if(@flag=1)                
begin                
if not exists(select * from Tbl_Student_Appeal_Master where TimetableSerialNumber=@TimetableSerialNumber and Student_Id=@Student_Id and  delete_Status=0)              
begin              
INSERT INTO [dbo].[Tbl_Student_Appeal_Master]              
           ([Student_Id]              
           ,[StudentAppeal_Number]              
           ,[Appeal_Date]              
           ,[TimetableSerialNumber]              
           ,[TotalAmount_Tobe_Paid]              
           ,[TotalAmount__Paid]              
           ,[PaymentStatus]              
           ,[ApprovalStatus]              
           ,[Created_Date]              
           ,[delete_Status])              
     VALUES              
           (@Student_Id              
           ,@StudentAppeal_Number              
           ,@Appeal_Date              
           ,@TimetableSerialNumber              
           ,@TotalAmount_Tobe_Paid              
           ,@TotalAmount__Paid              
           ,@PaymentStatus              
           ,@ApprovalStatus              
           ,getdate(),0  )              
     select SCOPE_IDENTITY();              
     end              
     end              
if(@flag=2)                
begin              
              
INSERT INTO [dbo].[Tbl_Student_Appeal_Child]              
           ([Student_Id]              
           ,[Course_Id]              
           ,[StudentAppeal_Id]              
           ,[Created_Date]              
           ,[delete_Status])              
     VALUES              
           (@Student_Id              
           ,@Course_Id              
           ,@StudentAppeal_Id,GETDATE(),0)              
end              
if(@flag=3)                                              
begin                                              
                                    
 select REPLICATE(''0'',3-LEN(RTRIM(isnull(max(StudentAppeal_Id)+1,1)))) + RTRIM(isnull(max(StudentAppeal_Id)+1,1))                                  
 as  Max_name_SerialNumber from   Tbl_Student_Appeal_Master                                  
                   
end               
if(@flag=4)                                              
begin                                              
                                    
 select distinct  EM.Exam_Master_id,EM.Exam_Name from  Tbl_Exam_Master EM                
  left join Tbl_MarkEntryMaster ED on ED.Exam_Id=EM.Exam_Master_id              
 where EM.Result_PublishStatus=1 and   ED.EntryType=''R2''               
 and Result_status not in(''Academic Disciplinary – Pardoned'',''Academic Disciplinary – Not Pardoned'',''Y'',''Z'',''F'',''X'',''I'')              
 --and EM.Exam_Master_id not in (select TimetableSerialNumber from Tbl_Student_Appeal_Master)              
 and ED.Student_Id=@Student_Id                            
                   
end              
if(@flag=5)                                              
begin                                              
                                    
 select distinct  ED.Course_Id,concat(NC.Course_Name,'' - '',Nc.Course_code)as coursename from  Tbl_Exam_Master EM                
 left join Tbl_MarkEntryMaster ED on ED.Exam_Id=EM.Exam_Master_id              
 left join Tbl_New_Course NC on NC.Course_Id=ED.Course_Id              
 where EM.Result_PublishStatus=1 and   ED.EntryType=''R2''               
 and Result_status not in(''Academic Disciplinary – Pardoned'',''Academic Disciplinary – Not Pardoned'',''Y'',''Z'',''F'',''X'',''I'')              
  and ED.Student_Id=@Student_Id  and   ED.Exam_Id=@TimetableSerialNumber              
end              
if(@flag=6)                                        begin                                              
                                    
 select FS.Course_Id,FS.Fee_Amount from Tbl_Exam_Master EM                         
left join Tbl_Course_Duration_PeriodDetails CPD   on CPD.Duration_Period_Id=Em.Duration_Period_id                                    
 inner join Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CPD.Batch_Id and                                      
 CBD.Batch_DelStatus=0 and CPD.Delete_Status=0                                      
  inner join Tbl_Department D on D.Department_Id=CBD.Duration_Id                                    
  inner join Tbl_Course_Level L On L.Course_Level_Id=D.GraduationTypeId                                    
 inner join Tbl_Course_Semester S on S.Semester_Id=CPD.Semester_Id and S.Semester_DelStatus=0                 
 inner join  Tbl_ReEvaluation_Fee_Master FM on FM.Programme_Id=D.Department_Id and FM.Intake_Id=CBD.Batch_Id and FM.Semester_Id=S.Semester_Id              
 inner join  Tbl_ReEvaluation_Fee_Settings FS on FS.ReEvaluation_Fee_Master_Id=FM.ReEvaluation_Fee_Master_Id              
 where  Em.Publish_status=2 and EM.Result_PublishStatus=1 and FS.Course_Id=@Course_Id and EM.Exam_Master_id=@TimetableSerialNumber              
              
end              
if(@flag=7)                                              
begin                                              
                                    
 select distinct AM.StudentAppeal_Number,convert(varchar(50),AM.Appeal_Date,103) as Appeal_Date,AC.StudentAppeal_Id,AC.Student_Id,              
count(AC.course_Id)as Numberofcourses ,              
case when PaymentStatus= 1 then ''Pending'' else ''Paid'' end as PaymentStatus,              
case when ApprovalStatus=1 then ''Pending'' else ''Approved'' end as ApprovalStatus              
 from Tbl_Student_Appeal_Master AM              
inner join  Tbl_Student_Appeal_Child AC on AC.StudentAppeal_Id=AM.StudentAppeal_Id              
where AM.Student_Id=@Student_Id and AM.delete_Status=0              
              
group by AM.StudentAppeal_Number,AM.Appeal_Date,AC.StudentAppeal_Id,AC.Student_Id,PaymentStatus,ApprovalStatus              
              
end              
if(@flag=8)                                              
begin                                              
                                    
Update Tbl_Student_Appeal_Master set delete_status=1 where StudentAppeal_Id=@StudentAppeal_Id and Student_Id=@Student_Id              
Update  Tbl_Student_Appeal_Child set delete_status=1 where StudentAppeal_Id=@StudentAppeal_Id and Student_Id=@Student_Id              
              
end              
if(@flag=9)              
begin              
 select distinct AM.StudentAppeal_Number,AM.Appeal_Date,AC.StudentAppeal_Id,AC.Student_Id,AM.TotalAmount_Tobe_Paid,EM.Exam_Master_id,EM.Exam_Name,              
case when PaymentStatus= 1 then ''Pending'' else ''Paid'' end as PaymentStatus,              
case when ApprovalStatus=1 then ''Pending'' else ''Approved'' end as ApprovalStatus              
 from Tbl_Student_Appeal_Master AM              
inner join  Tbl_Student_Appeal_Child AC on AC.StudentAppeal_Id=AM.StudentAppeal_Id              
   inner join Tbl_Exam_Master EM on EM.Exam_Master_id=AM.TimetableSerialNumber              
where AM.Student_Id=@Student_Id and AM.delete_Status=0 and AC.StudentAppeal_Id=@StudentAppeal_Id              
              
              
end              
if(@flag=10)              
begin              
 select distinct AM.StudentAppeal_Number,convert(varchar(50),AM.Appeal_Date,103) as Appeal_Date,AC.StudentAppeal_Id,AC.Student_Id,             
 concat(CDP.Candidate_Fname,'' '',Candidate_Lname)as studentname,CDP.IDMatrixNo,CDP.AdharNumber,            
count(AC.course_Id)as Numberofcourses ,           
case when PaymentStatus= 1 then ''Pending'' else ''Paid'' end as PaymentStatus,              
case when ApprovalStatus=1 then ''Pending'' else ''Approved'' end as ApprovalStatus              
 from Tbl_Student_Appeal_Master AM              
inner join  Tbl_Student_Appeal_Child AC on AC.StudentAppeal_Id=AM.StudentAppeal_Id              
inner join Tbl_Candidate_Personal_Det CDP on CDP.Candidate_Id= AC.Student_Id            
where AM.delete_Status=0              
              
group by AM.StudentAppeal_Number,AM.Appeal_Date,AC.StudentAppeal_Id,AC.Student_Id,PaymentStatus,ApprovalStatus ,            
CDP.Candidate_Fname,Candidate_Lname,CDP.IDMatrixNo,CDP.AdharNumber            
              
              
end             
if(@flag=11)              
begin              
Update Tbl_Student_Appeal_Master set ApprovalStatus=2,Approved_By=@Approved_By WHERE StudentAppeal_Id=@StudentAppeal_Id            
              
              
end             
if(@flag=12)              
begin              
 select distinct AM.StudentAppeal_Number,AM.Appeal_Date,AC.StudentAppeal_Id,AC.Student_Id,AM.TotalAmount_Tobe_Paid,EM.Exam_Master_id,EM.Exam_Name,             
 concat(CDP.Candidate_Fname,'' '',Candidate_Lname)as studentname,CDP.IDMatrixNo,CDP.AdharNumber,            
case when PaymentStatus= 1 then ''Pending'' else ''Paid'' end as PaymentStatus,              
case when ApprovalStatus=1 then ''Pending'' else ''Approved'' end as ApprovalStatus              
 from Tbl_Student_Appeal_Master AM              
inner join  Tbl_Student_Appeal_Child AC on AC.StudentAppeal_Id=AM.StudentAppeal_Id              
  inner join Tbl_Candidate_Personal_Det CDP on CDP.Candidate_Id= AC.Student_Id            
   inner join Tbl_Exam_Master EM on EM.Exam_Master_id=AM.TimetableSerialNumber            
where AM.Student_Id=@Student_Id and AM.delete_Status=0 and AC.StudentAppeal_Id=@StudentAppeal_Id              
              
              
end             
if(@flag=13)              
begin              
 select distinct AC.Course_Id,AC.Student_Id,AC.StudentAppeal_Id             
 from Tbl_Student_Appeal_Master AM              
inner join  Tbl_Student_Appeal_Child AC on AC.StudentAppeal_Id=AM.StudentAppeal_Id              
  inner join Tbl_Candidate_Personal_Det CDP on CDP.Candidate_Id= AC.Student_Id            
   inner join Tbl_Exam_Master EM on EM.Exam_Master_id=AM.TimetableSerialNumber            
where AM.Student_Id=@Student_Id and AM.delete_Status=0 and AC.StudentAppeal_Id=@StudentAppeal_Id              
              
              
end            
if(@flag=14)                                              
begin                                              
                                    
 select distinct  EM.Exam_Master_id,EM.Exam_Name from  Tbl_Exam_Master EM                
  left join Tbl_MarkEntryMaster ED on ED.Exam_Id=EM.Exam_Master_id              
 where EM.Result_PublishStatus=1 and   ED.EntryType=''R2''               
 and Result_status not in(''Academic Disciplinary – Pardoned'',''Academic Disciplinary – Not Pardoned'',''Y'',''Z'',''F'',''X'',''I'')                   
 and ED.Student_Id=@Student_Id                            
                   
end      
End 
    ')
END
