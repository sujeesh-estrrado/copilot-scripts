IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_FeeRecepit_Candidate_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_FeeRecepit_Candidate_Id]    
      
@Candidate_id bigint    
AS    
BEGIN    
select  distinct AL.Approval_Id,                             
Student_Reg_No,                  
sr.Student_Reg_Id,                      
sr.Candidate_Id,     
           
Tbl_Course_Category.Course_Category_Name+'' ''+D.Department_Name as Class,                      
Tbl_Course_Category.Course_Category_Id,                      
D.Department_Id,                      
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                      
Tbl_Course_Category.Course_Category_Name,                      
D.Department_Name,                
Tbl_Student_Semester.Student_Semester_Current_Status as newstatus,                
Tbl_Course_Duration_Mapping.Course_Department_Id,               
Tbl_Course_Duration_Mapping.Duration_Mapping_Id,             
D.Department_Name as new_dept ,                
Fee_Entry_Id,      
Payment_Details_Id,          
PD.Approval_Id,          
Case           
When Payment_Details_Mode=1 Then ''Cash''          
When Payment_Details_Mode=2 Then ''Cheque''          
When Payment_Details_Mode=3 Then ''DD''          
When Payment_Details_Mode=4 Then ''Coupon''         
When Payment_Details_Mode=5 Then ''Credit''          
Else '''' End AS PaymentMode,          
Payment_Details_Particulars,          
         
Payment_Details_Amount,          
Payment_Details_Date      
Approval_Total_Amount,        
Approval_Balance_Amount,      
(Approval_Total_Amount+Approval_Balance_Amount) as Amount_to_be_paid,    
AdmissionType,    
(Case When Approval_Balance_Amount=0 Then ''0'' --Fully paid        
 When Approval_Balance_Amount>0 Then ''1'' --Partially Paid        
 When Approval_Del_Status=1 Then ''3'' --cancelled        
 Else ''2'' END) As PaymentStatus  --not paid                
                      
FROM (Tbl_Student_Registration sr                      
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                     
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                 
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id                
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id                
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id                
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id                   
left join Tbl_Fee_Entry FE on  cpd.Candidate_Id=FE.Candidate_Id        
left join Tbl_Payment_Details PD on PD.Payment_Details_Particulars_Id=FE.Fee_Entry_Id and Payment_Details_Particulars=''FEES''        
left join Tbl_Payment_Approval_List AL on AL.Approval_Id=PD.Approval_Id )       
     
where Tbl_Student_Semester.Student_Semester_Current_Status=1  and sr.Candidate_Id=@Candidate_id    
     
END
    ')
END
