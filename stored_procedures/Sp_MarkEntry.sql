IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_MarkEntry]') 
    AND type = N'P'
)
BEGIN
    EXEC ('  
CREATE procedure [dbo].[Sp_MarkEntry]    
(@flag bigint=0,@ExamMarkEntryId bigint=0,                              
 @Student_Id bigint=0,                             
 @Exam_Id bigint=0,                            
 @Course_Id bigint=0,                              
 @Result_status varchar(50) ='''',                              
 @Created_By bigint=0,                              
 @acesscode bigint=0,                              
 @mark decimal(18,2)=0,                              
 @masterid bigint=0,                              
 @id bigint=0,                          
 @attendancests varchar(100)='''',                      
 @EntryType varchar(max)='''')                              
 as                              
 begin                              
 if(@flag=1)--insert on Tbl_MarkEntryMaster                              
 begin                              
                               
                               
 if not exists(select * from Tbl_MarkEntryMaster where Student_Id=@Student_Id and Course_Id=@Course_Id and Exam_Id=@Exam_Id and EntryType =@EntryType and  Delete_Status=0)                              
 begin                              
 INSERT INTO [dbo].[Tbl_MarkEntryMaster]                              
           ([Student_Id]                              
           ,[Course_Id]                              
           ,[Result_status]                              
           ,[Created_By]                              
           ,[Create_date]                              
           ,[Delete_Status],Exam_Id,Publish_Status,EntryType )                              
     VALUES(@Student_Id,@Course_Id,@Result_status,@Created_By,getdate(),0,@Exam_Id,1,@EntryType)                              
  select @@IDENTITY                              
  end                              
  else                              
  UPDATE [dbo].[Tbl_MarkEntryMaster]                              
  set                              
                               
      [Result_status] = @Result_status,                      
   Attendance_Status=@attendancests                      
                                 
 WHERE  Student_Id=@Student_Id and Course_Id=@Course_Id and Delete_Status=0  and  Exam_Id=@Exam_Id  and EntryType =@EntryType                          
select ExamMarkEntryId from Tbl_MarkEntryMaster where Student_Id=@Student_Id and Course_Id=@Course_Id and Delete_Status=0   and EntryType =@EntryType                             
  end                              
  if(@flag=2)-- inser on Tbl_Mark_Entry_Acessset                              
  begin                              
  if not exists (select * from Tbl_Mark_Entry_Acessset where Master_Mark_ID=@masterid and AssesmentSetup=@acesscode and EntryType=@EntryType)                              
  begin                              
  INSERT INTO [dbo].[Tbl_Mark_Entry_Acessset]                              
           ([Master_Mark_ID]                              
           ,[AssesmentSetup]                              
           ,[Mark],EntryType)                              
     VALUES(@masterid,@acesscode,@mark,@EntryType)                              
                              
                              
  end                              
  else                              
  begin                              
  update Tbl_Mark_Entry_Acessset set [Mark]=@mark where Master_Mark_ID=@masterid and AssesmentSetup=@acesscode  and EntryType=@EntryType                            
  end                              
  end                              
  if(@flag=3)--insert on  edit log                            
  begin                            
                            
  insert into Tbl_Mark_edit_Status(Edited_by,Edited_date,delete_staus,MasterId) values(@id,GETDATE(),0,@masterid);                            
                            
                            
  end                            
  if(@flag=4)--select master                            
  begin                            
         
  select * from Tbl_MarkEntryMaster                             
                            
  end                            
  if(@flag=5)--select employee                            
  begin                            
                            
  select CONVERT(VARCHAR(10), ES.edited_date, 103) as Date ,concat(E.Employee_FName,'' '',E.Employee_LName) as Name,CONVERT(VARCHAR(10), ES.edited_date, 108) as Time  from Tbl_Mark_edit_Status ES                          
  inner join Tbl_MarkEntryMaster M on ES.MasterId=M.ExamMarkEntryId                    
  left join Tbl_Employee E on E.Employee_Id=ES.Edited_by                          
  where ES.MasterId=@Exam_Id and M.Course_Id=@Course_Id                   
                            
  end                           
    if(@flag=6)--select master                            
  begin                          
    select A.Mark from Tbl_MarkEntryMaster E inner join Tbl_Mark_Entry_Acessset A on E.ExamMarkEntryId=A.Master_Mark_ID and E.Delete_Status=0                        
 where E.Student_Id=@Student_Id and E.Course_Id=@Course_Id and A.Master_Mark_ID=@masterid and         
 AssesmentSetup=@acesscode    and  A.EntryType=@EntryType                    
  end                            
   if(@flag=7)--select masterid using exam                            
begin                          
    select * from Tbl_MarkEntryMaster E   left join Tbl_Mark_Entry_Acessset A on A.Master_Mark_ID=E.ExamMarkEntryId                     
 where Exam_Id=@Exam_Id           
 and Student_Id=@Student_Id and Course_Id=@Course_Id and Delete_Status=0   and E.EntryType=@EntryType                     
  end                        
  if(@flag=8)                    
   begin                              
  update Tbl_MarkEntryMaster set Publish_Status=1                     
  where                    
  Student_Id=@Student_Id and Course_Id=@Course_Id and Delete_Status=0  and  Exam_Id=@Exam_Id   and    EntryType =@EntryType                            
  end                     
   if(@flag=9)  --insert exam publish                  
   begin                       
   if not exists (select * from Tbl_ExamApprovalLog where ExamMaster=@ExamMarkEntryId)                
   begin                
   insert into Tbl_ExamApprovalLog (ExamPublishedBy,ExamPublishdate,ExamMaster)values (@id ,getdate(),@Exam_Id)                
   select @@IDENTITY                   
   end                
  update Tbl_ExamApprovalLog set ExamPublishedBy=@id, ExamPublishdate=GETDATE() where ExamMaster=@Exam_Id                  
    select ExamMaster from Tbl_ExamApprovalLog where ExamMaster=@Exam_Id              
  end                   
   if(@flag=10)  --insert exam head approval                  
   begin                       
   if not exists (select * from Tbl_ExamApprovalLog where ExamMaster=@Exam_Id)                
   begin                
   insert into Tbl_ExamApprovalLog (ExamHeadApprovedBy,ExamApprovalDate,ExamMaster)values (@id ,getdate(),@Exam_Id)                
   select @@IDENTITY                   
  end                
  update Tbl_ExamApprovalLog set ExamHeadApprovedBy=@id, ExamApprovalDate=GETDATE() where ExamMaster=@Exam_Id                  
        select ExamMaster from Tbl_ExamApprovalLog where ExamMaster=@Exam_Id              
              
  end                  
     if(@flag=11)  --insert exam registrra approval                  
   begin                       
   if not exists (select * from Tbl_ExamApprovalLog where ExamMaster=@Exam_Id)                
   begin                
   insert into Tbl_ExamApprovalLog (RegistrarApprovedBy,RegistrarApprovalDate,ExamMaster)values (@id ,getdate(),@Exam_Id)                
    select @@IDENTITY                   
   end                
  update Tbl_ExamApprovalLog set RegistrarApprovedBy=@id, RegistrarApprovalDate=GETDATE() where ExamMaster=@Exam_Id                  
    update Tbl_Exam_Master set Publish_status=3 where Exam_Master_id=@Exam_Id              
 update Tbl_MarkEntryMaster set Publish_Status=2 where Exam_Id=@Exam_Id              
     select ExamMaster from Tbl_ExamApprovalLog where ExamMaster=@Exam_Id              
              
  end               
   if(@flag=12)  --insert exam registrra approval                  
   begin                       
select C.Course_Name,CPD.Candidate_Id,Me.Result_status from Tbl_MarkEntryMaster ME inner join               
Tbl_Exam_Master Em on Em.Exam_Master_id=ME.Exam_Id              
inner join Tbl_New_Course C on ME.Course_Id=C.Course_Id              
inner join Tbl_Candidate_Personal_Det CPD on Cpd.Candidate_Id=ME.Student_Id              
Inner Join Tbl_Course_Duration_PeriodDetails CP On                            
                             
EM.Duration_Period_id=CP.Duration_Period_Id                
where      
(ME.EntryType=''R2'' or ME.EntryType=''R3'')and      
Cpd.Candidate_Id=@Student_Id and ME.Course_Id in  (select Department_Subjects_Id from  Tbl_Semester_Subjects S   where Duration_Mapping_Id=CP.Duration_Period_Id and S.Semester_Subjects_Status=0)              
              
              
             
              
  end               
  if(@flag=13)  --insert exam registrra approval                  
   begin             
   if  exists (select * from Tbl_Exam_Attendance A             
   inner join Tbl_Exam_Attendance_Master AM on Am.Attendance_Master_Id=A.Attendance_Master_Id            
inner join Tbl_Exam_Schedule ES on ES.Exam_Schedule_Id=AM.Exam_Schedule_Id where ES.Exam_Master_Id=@Exam_Id and A.Student_Id=@Student_Id             
and (A.Present=0   or (A.Misconduct=1 and A.Approval_Status=2)))            
begin            
   update Tbl_Student_Semester set SEMESTER_NO=SEMESTER_NO+1 where Candidate_Id=@Student_Id and Delete_Status=0             
            
   end            
  end       
   if(@flag=14)  --insert exam registrra approval                  
   begin     
   if Exists(select * from Tbl_MarkEntryMaster where Exam_Id=@Exam_Id and Student_Id=@Student_Id and Course_Id=@Course_Id and Delete_Status=0 )    
   begin    
     Update  Tbl_MarkEntryMaster set Result_status=''F''                     
    where Exam_Id=@Exam_Id           
    and Student_Id=@Student_Id and Course_Id=@Course_Id and Delete_Status=0     
   end    
   else    
    begin    
     Insert into  Tbl_MarkEntryMaster (Exam_Id,Attendance_Status,Student_Id,Course_Id,Result_status,EntryType,Created_By,Create_date,Delete_Status,Publish_Status)                    
    values(@Exam_Id,''Approved''  ,   @Student_Id, @Course_Id,''F'',''Entry'',1,getdate(),0,2)    
       
   end    
 end              
    
END') 
END;
