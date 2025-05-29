IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Search_StudentDeatils_Mutiple]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Search_StudentDeatils_Mutiple]                  
(    
@CurrentPage int=1,                  
@pagesize bigint =10,                  
@Type varchar(50)='''',                   
@Status bigint=0,                  
@Department_Id bigint=0,      
@Intake_Id bigint=0,    
@Country bigint=0,    
@Gender varchar(50)='''',    
@Age bigint=0,    
@Flag bigint=1    
)       
AS      
BEGIN      
     
if(@Flag=1)                  
begin         
--search type only      
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin      
    
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type    
  Order by Candidate_Id desc    
    
        
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
      
End      
    
    
     
----search Status only      
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin      
    
     
     select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where CPD.active=@Status    
  Order by Candidate_Id desc    
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Department_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin        
    
      
       select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where NA.Department_Id =@Department_Id     
  Order by Candidate_Id desc    
      
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
      
--search Intake_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin        
      
        
       select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where BD.IntakeMasterId=@Intake_Id    
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Country only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin      
           select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where cpd.Candidate_Nationality =@Country    
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Gender only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin       
                 select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where cpd.Candidate_Gender =@Gender    
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
      
End      
--search Age only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin     
        
       select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where YEAR( cpd.Candidate_Dob )=@Age    
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
  
 ---Second start------  
 --search type only      
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin      
    
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  and  CPD.active=@Status  
  Order by Candidate_Id desc    
    
        
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
      
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin      
    
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  and   NA.Department_Id =@Department_Id  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  and BD.IntakeMasterId=@Intake_Id  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  and cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS        
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end)as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and YEAR( cpd.Candidate_Dob )=@Age   
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and NA.Department_Id =@Department_Id  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and BD.IntakeMasterId=@Intake_Id  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and YEAR( cpd.Candidate_Dob )=@Age   
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end)as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
(Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and YEAR( cpd.Candidate_Dob )=@Age  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end)  as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
 BD.IntakeMasterId=@Intake_Id  and cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   BD.IntakeMasterId=@Intake_Id  and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   BD.IntakeMasterId=@Intake_Id  and YEAR( cpd.Candidate_Dob )=@Age  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   cpd.Candidate_Nationality =@Country  and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   cpd.Candidate_Nationality =@Country  and  YEAR( cpd.Candidate_Dob )=@Age   
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  cpd.Candidate_Gender =@Gender and  YEAR( cpd.Candidate_Dob )=@Age   
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
 /*second saving End*/  
/*Third saving start*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and   NA.Department_Id =@Department_Id  
  Order by Candidate_Id desc    
 OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and BD.IntakeMasterId=@Intake_Id  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and  cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and  cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and  YEAR( cpd.Candidate_Dob )=@Age  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  BD.IntakeMasterId=@Intake_Id  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  YEAR( cpd.Candidate_Dob )=@Age   
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and YEAR( cpd.Candidate_Dob )=@Age  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Nationality =@Country and YEAR( cpd.Candidate_Dob )=@Age  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR( cpd.Candidate_Dob )=@Age  
  Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
 /*4 start*/  
/*type,status,programm*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and  BD.IntakeMasterId=@Intake_Id   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and  cpd.Candidate_Nationality =@Country  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and  cpd.Candidate_Gender =@Gender  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and YEAR( cpd.Candidate_Dob )=@Age   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Nationality =@Country  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Gender =@Gender  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and YEAR(cpd.Candidate_Dob)=@Age   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country and YEAR(cpd.Candidate_Dob)=@Age   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
/*5 start*/  
/*type,status,programm,intake*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country    
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Gender =@Gender  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id and YEAR(cpd.Candidate_Dob)=@Age  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id   
  and cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id   
  and cpd.Candidate_Nationality =@Country and YEAR(cpd.Candidate_Dob)=@Age  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id   
  and cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
 /*6 start*/  
/*type,status,programm,intake*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
--7 statred--------  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0 and @Gender!=''Select'' and @Age!=0)       
begin   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age   
Order by Candidate_Id desc OFFSET @PageSize * (@CurrentPage - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);     
End  
  

  
  
      
End      
    
End      
      
  if(@Flag=2)                  
begin         
--search type only      
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
select * into #temp from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type    
    
    )base        
   select count(*) as totcount from #temp     
      
End      
--search Status only      
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
 select * into #temp1 from (       
      
         
     
     select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where CPD.active=@Status    
 )base        
   select count(*) as totcount from #temp1     
      
End      
--search Department_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin        
    
   select * into #temp2 from (       
       select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where NA.Department_Id =@Department_Id     
        
      
    )base        
   select count(*) as totcount from #temp2      
      
End      
      
--search Intake_Id only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin         
    
   select * into #temp3 from (     
        
       select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where BD.IntakeMasterId=@Intake_Id    
      
      
    )base        
   select count(*) as totcount from #temp3       
      
End      
--search Country only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin         
    select * into #temp4 from (      
           select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where cpd.Candidate_Nationality =@Country    
      
      
    )base        
   select count(*) as totcount from #temp4         
      
End      
--search Gender only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin       
select * into #temp5 from (     
                 select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where cpd.Candidate_Gender =@Gender    
      
      
    )base        
   select count(*) as totcount from #temp5      
      
End      
--search Age only      
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin        
     select * into #temp6 from (     
       select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where YEAR( cpd.Candidate_Dob )=@Age    
      
      
    )base        
   select count(*) as totcount from #temp6      
      
End      
  
--Second start  
--search type only      
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
select * into #temp7 from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and  CPD.active=@Status   
    
    )base        
   select count(*) as totcount from #temp7     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
select * into #temp8 from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   NA.Department_Id =@Department_Id   
    
    )base        
   select count(*) as totcount from #temp8     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin     
select * into #temp9 from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where(Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and BD.IntakeMasterId=@Intake_Id  
    
    )base        
   select count(*) as totcount from #temp9     
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin     
select * into #temp10 from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and  cpd.Candidate_Nationality =@Country  
    
    )base        
   select count(*) as totcount from #temp10    
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin     
select * into #temp11 from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and  cpd.Candidate_Gender =@Gender  
    
    )base        
   select count(*) as totcount from #temp11    
End   
if(@Type!=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin     
select * into #temp12 from (       
        
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
  from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and  YEAR( cpd.Candidate_Dob )=@Age   
    
    )base        
   select count(*) as totcount from #temp11    
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp13 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and NA.Department_Id =@Department_Id  
    )base        
   select count(*) as totcount from #temp13     
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp14 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and BD.IntakeMasterId=@Intake_Id  
   )base        
   select count(*) as totcount from #temp14  
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin  
select * into #temp15 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and cpd.Candidate_Nationality =@Country  
   )base        
   select count(*) as totcount from #temp15   
End   
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp16 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and cpd.Candidate_Gender =@Gender  
   )base        
   select count(*) as totcount from #temp16  
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp17 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  CPD.active=@Status  and YEAR( cpd.Candidate_Dob )=@Age   
    )base        
   select count(*) as totcount from #temp17  
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp18 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
  )base        
   select count(*) as totcount from #temp18     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp19 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and cpd.Candidate_Nationality =@Country  
    )base        
   select count(*) as totcount from #temp19  
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp20 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and cpd.Candidate_Gender =@Gender  
   )base        
   select count(*) as totcount from #temp20     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp21 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  NA.Department_Id =@Department_Id  and YEAR( cpd.Candidate_Dob )=@Age  
  )base        
   select count(*) as totcount from #temp21  
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp22 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
 BD.IntakeMasterId=@Intake_Id  and cpd.Candidate_Nationality =@Country  
   )base        
   select count(*) as totcount from #temp22    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin  
select * into #temp23 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   BD.IntakeMasterId=@Intake_Id  and cpd.Candidate_Gender =@Gender  
  )base        
   select count(*) as totcount from #temp23    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp24 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   BD.IntakeMasterId=@Intake_Id  and YEAR( cpd.Candidate_Dob )=@Age  
  )base        
   select count(*) as totcount from #temp24   
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp25 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   cpd.Candidate_Nationality =@Country  and cpd.Candidate_Gender =@Gender  
  )base        
   select count(*) as totcount from #temp25   
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp26 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry'' When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry'' When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
   cpd.Candidate_Nationality =@Country  and  YEAR( cpd.Candidate_Dob )=@Age   
 )base        
   select count(*) as totcount from #temp26   
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age!=0)       
begin   
select * into #temp27 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId      
  left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO      
  left join Tbl_Student_Status SSS on SSS.id=CPD.active  where   
  cpd.Candidate_Gender =@Gender and  YEAR( cpd.Candidate_Dob )=@Age   
)base        
select count(*) as totcount from #temp27    
End  
 /*second saving End*/  
/*Third saving start*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp28 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and   NA.Department_Id =@Department_Id  
 )base        
select count(*) as totcount from #temp28  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp29 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and BD.IntakeMasterId=@Intake_Id  
)base        
select count(*) as totcount from #temp29  
    
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp30 from (   
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and  cpd.Candidate_Nationality =@Country  
  )base        
select count(*) as totcount from #temp30  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp31 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and  cpd.Candidate_Gender =@Gender  
 )base        
select count(*) as totcount from #temp31     
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp32 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type and   
   CPD.active=@Status  and  YEAR( cpd.Candidate_Dob )=@Age  
)base select count(*) as totcount from #temp32     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp33 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  BD.IntakeMasterId=@Intake_Id  
 )base select count(*) as totcount from #temp33  
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp34 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  cpd.Candidate_Nationality =@Country  
  )base select count(*) as totcount from #temp34  
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp35 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp35     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp36 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status  and  NA.Department_Id =@Department_Id and  YEAR( cpd.Candidate_Dob )=@Age   
)base select count(*) as totcount from #temp36    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp37 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country  
    
)base select count(*) as totcount from #temp37     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp38 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Gender =@Gender  
 )base select count(*) as totcount from #temp38    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp39 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and YEAR( cpd.Candidate_Dob )=@Age  
 )base select count(*) as totcount from #temp39  
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp40 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp40  
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp41 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Nationality =@Country and YEAR( cpd.Candidate_Dob )=@Age  
 )base select count(*) as totcount from #temp41     
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
select * into #temp42 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR( cpd.Candidate_Dob )=@Age  
)base select count(*) as totcount from #temp42   
End  
 /*4 start*/  
/*type,status,programm*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp43 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and  BD.IntakeMasterId=@Intake_Id  
)base select count(*) as totcount from #temp43  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp44 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and  cpd.Candidate_Nationality =@Country  
)base select count(*) as totcount from #temp44  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
  
select * into #temp45 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end)=@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and  cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp45  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp46 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and  CPD.active=@Status and  NA.Department_Id =@Department_Id and YEAR( cpd.Candidate_Dob )=@Age   
)base select count(*) as totcount from #temp46  
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin  
select * into #temp47 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Nationality =@Country  
)base select count(*) as totcount from #temp47    
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp48 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp48  
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp49 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and YEAR(cpd.Candidate_Dob)=@Age   
)base select count(*) as totcount from #temp49    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp50 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp50    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp51 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
 (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where  NA.Department_Id =@Department_Id and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country and YEAR(cpd.Candidate_Dob)=@Age   
)base select count(*) as totcount from #temp51    
End  
if(@Type=''Select'' and @Status=0 and @Department_Id=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
  
select * into #temp52 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age   
  )base select count(*) as totcount from #temp52  
End  
/*5 start*/  
/*type,status,programm,intake*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age=0)       
begin   
select * into #temp53 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id and  cpd.Candidate_Nationality =@Country    
)base select count(*) as totcount from #temp53  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp54 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id     
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id and cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp54  
  
End  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country=0  and @Gender=''Select'' and @Age!=0)       
begin  
select * into #temp55 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id and YEAR(cpd.Candidate_Dob)=@Age  
)base select count(*) as totcount from #temp55    
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp56 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id   
  and cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp56     
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender=''Select'' and @Age!=0)       
begin   
select * into #temp57 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id   
  and cpd.Candidate_Nationality =@Country and YEAR(cpd.Candidate_Dob)=@Age  
)base select count(*) as totcount from #temp57   
End  
if(@Type=''Select'' and @Status=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
select * into #temp58 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id   
  and cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age  
)base select count(*) as totcount from #temp58     
End  
 /*6 start*/  
/*type,status,programm,intake*/  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age=0)       
begin   
select * into #temp59 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
   (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender  
)base select count(*) as totcount from #temp59  
  
End  
if(@Type=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
select * into #temp60 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age   
)base select count(*) as totcount from #temp60  
  
End  
--7 statred--------  
if(@Type!=''Select'' and @Status!=0 and @Department_Id!=0 and @Intake_Id!=0 and @Country!=0  and @Gender!=''Select'' and @Age!=0)       
begin   
select * into #temp61 from (  
   select distinct CPD.Candidate_Id,AdharNumber,concat(Candidate_Fname,'' '',candidate_Lname) as CandidateName,      
  IDMatrixNo,IM.intake_no as Batch_Code,concat(D.Course_Code,''-'',D.Department_Name)as Department_Name,    
  D.Department_Id,CS.Semester_Name,SSS.name , CC.Candidate_Email as EmailID  ,ApplicationStatus,    
  (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) as TypeName     
   from Tbl_Candidate_Personal_Det CPD      
   left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id     
  left join Tbl_New_Admission  NA on CPD.New_Admission_Id=NA.New_Admission_Id      
  left join Tbl_Department D on D.Department_Id=NA.Department_Id     
  left join Tbl_Course_Batch_Duration BD on BD.Batch_Id=NA.Batch_Id      
  left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterId left join Tbl_Student_semester SS on SS.Candidate_Id=CPD.Candidate_Id      
  left join Tbl_Course_Semester CS on CS.Semester_Id=SS.SEMESTER_NO left join Tbl_Student_Status SSS on SSS.id=CPD.active   
  where (Case When ApplicationStatus=''pending''Then ''Enquiry''          
When ApplicationStatus=''Pending''Then ''Enquiry''          
When ApplicationStatus=''submited''Then ''Enquiry''        
When ApplicationStatus=''Completed''Then ''Student'' end) =@Type  
and CPD.active=@Status and NA.Department_Id =@Department_Id  and BD.IntakeMasterId=@Intake_Id  
and  cpd.Candidate_Nationality =@Country and cpd.Candidate_Gender =@Gender and YEAR(cpd.Candidate_Dob)=@Age   
)base select count(*) as totcount from #temp61     
End  
  
  
  
    
End     
      
END 
');
END;
