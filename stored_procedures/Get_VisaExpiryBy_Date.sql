-- Create Get_VisaExpiryBy_Date procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_VisaExpiryBy_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                   
CREATE procedure [dbo].[Get_VisaExpiryBy_Date] --''10/10/2017'' , ''12/10/2018''           
@fromdate varchar(200),        
@todate varchar(200)      
as      
begin      
--    declare @from datetime      
--    declare @to datetime      
--set @from=convert(datetime, convert(varchar(30), @fromdate), 101)      
--set @to=convert(datetime, convert(varchar(30), @todate), 101)      
      
SELECT                                          
sr.Student_Reg_Id,                          
sr.Candidate_Id,                                          
sr.Candidate_Id as ID,                                
SG.BloodGroup,                               
cpd.IdentificationNo as IdentificationNumber ,                  
cpd.AdharNumber,                               
cpd.Candidate_Gender as Gender,cpd.Candidate_Nationality,                                      
cpd.Candidate_Gender,                                         
cpd.Candidate_Dob as DOB,                                          
D.Department_Name as Class,                                          
Tbl_Course_Category.Course_Category_Id,cpd.Race,                                        
D.Department_Id,                                          
sr.Student_Reg_No,                                          
sr.Student_Reg_Status,                          
cpd.Candidate_Fname,                                         
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,                           
ccd.Candidate_Email,                                         
Tbl_Course_Category.Course_Category_Id,                                          
Tbl_Course_Category.Course_Category_Name as [Category],                          
NA.Batch_Id as BatchID,                        
Batch_Code+''-''+Semester_Code AS BatchSemester,                        
Tbl_Course_Duration_Mapping.Duration_Mapping_Id,Semester_Name ,                                     
CBD.Batch_Code as Batch,                           
 (Case when SR.UserId IS NULL  Then ''''                                            
 Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                         
D.Department_Name,                                    
Tbl_Student_Semester.Student_Semester_Current_Status as newstatus,                                    
Tbl_Course_Duration_Mapping.Course_Department_Id,                                   
                                 
Tbl_Course_Department.Course_Category_Id,                                    
Tbl_Course_Department.Department_Id,                                    
D.Department_Name as new_dept,                                    
Tbl_Course_Category.Course_Category_Name,Visa,cpd.VisaFrom,cpd.VisaTo,Passport,PassportFrom,PassportDate                                        
                                          
FROM Tbl_Student_Registration sr                           
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = sr.UserId)                                         
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                          
inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                           
                                    
inner Join dbo.Tbl_Candidate_ContactDetails ccd on ccd.Candidate_Id=cpd.Candidate_Id                                          
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                                     
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                    
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                      
Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id                       
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id                        
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id                                  
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id                                    
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id                
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id                                    
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id                                       
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = cpd.Candidate_Id                                         
                               
                                   
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and cpd.Candidate_DelStatus=0 and      
--VisaTo  between @fromdate and @todate --convert(varchar(8)VisaTo(103))      
--and  VisaFrom  between @fromdate and @todate      
         
--VisaTo >= @fromdate  and VisaTo <=@todate   -- and VisaTo<=@todate        
  --VisaFrom >= @todate  and VisaTo <=@todate     
  --VisaTo between @fromdate and @todate  
    convert(datetime,@fromdate,103)<= convert(datetime,cpd.VisaTo,103)  
     and convert(datetime,@todate,103) >=convert(datetime,cpd.VisaTo,103) 

end

--====================
--Athira
--=======================
    ')
END;
GO
