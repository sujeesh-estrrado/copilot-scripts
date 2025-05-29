IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Candidate_TC_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      
CREATE procedure [dbo].[SP_Get_Candidate_TC_Details]             
(            
                
@CurrentPage int = null,            
@PageSize int = null  ,        
@SearchTerm varchar(100)          
)            
                
AS            
            
BEGIN            
    SET NOCOUNT ON            
            
    DECLARE @SqlString nvarchar(max)        
 Declare @SqlStringWithout nvarchar(max)            
    Declare @UpperBand int            
    Declare @LowerBand int                    
                
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                
            
    BEGIN            
             
      
      
IF @SearchTerm IS NOT NULL      
      
BEGIN      
      
 SET @SqlString=''WITH tempProfile AS            
        (                                
             SELECT   
SR.Student_Reg_Id,                  
SR.Candidate_Id as ID,         
SG.BloodGroup,         
CP.IdentificationNo as IdentificationNumber ,                  
CP.Candidate_Fname+'''' ''''+CP.Candidate_Mname+'''' ''''+CP.Candidate_Lname as CandidateName,                  
CP.Candidate_Gender as Gender,                  
CP.Candidate_Dob as DOB,                  
CC.Course_Category_Id,                  
D.Department_Id,                  
Tbl_Course_Category.Course_Category_Name+'''' ''''+D.Department_Name as Class,                  
SR.Student_Reg_No,                  
P.Candidate_Telephone as Telephone,  
P.Candidate_Email,  
t.TC_Id,   
t.TC_No,   
t.TC_Issue_Date,  
t.TC_Relieving_Date,  
t.First_Admission_Date,  
t.Last_studied_Class,  
t.TC_Admission_Date,         
Tbl_Student_Semester.Student_Semester_Current_Status as newstatus,            
Tbl_Course_Duration_Mapping.Course_Department_Id,                              
D.Department_Name as new_dept ,            
Tbl_Course_Category.Course_Category_Name   
  
,ROW_NUMBER() over (ORDER BY SR.Student_Reg_Id DESC) AS RowNumber     
             
                  
From dbo.Tbl_Student_Registration SR                  
                  
LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP  on CP.Candidate_Id=SR.Candidate_Id    
                
LEFT JOIN dbo.Tbl_Candidate_ContactDetails CD on CD.Candidate_Id=CP.Candidate_Id   
                 
LEFT JOIN dbo.Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id                  
                
LEFT JOIN dbo.Tbl_Candidate_ContactDetails P on P.Candidate_Id=CP.Candidate_Id   
                 
left join dbo.Tbl_Student_TC_Details t on t.Candidate_Id=CP.Candidate_Id   
                 
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = CP.Candidate_Id  
            
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id   
           
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id   
           
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id   
           
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id  
            
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id   
              
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CP.Candidate_Id                   
            
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and CP.Candidate_DelStatus=0       
      
      
and  (CP.Candidate_Fname+'''' ''''+CP.Candidate_Mname+'''' ''''+CP.Candidate_Lname like  ''''''+ @SearchTerm+''%''''       
      
or SR.Student_Reg_No like  ''''''+ @SearchTerm+''%''''   
  
or  CP.Candidate_Gender like  ''''''+ @SearchTerm+''%''''  
  
or  CP.IdentificationNo like  ''''''+ @SearchTerm+''%''''  
  
or  SG.BloodGroup like  ''''''+ @SearchTerm+''%''''  
  
or  CP.Candidate_Dob like  ''''''+ @SearchTerm+''%''''  
  
or  Tbl_Course_Category.Course_Category_Name+'''' ''''+D.Department_Name like  ''''''+ @SearchTerm+''%''''  
  
or  P.Candidate_Telephone like  ''''''+ @SearchTerm+''%''''  
  
or  P.Candidate_Email like  ''''''+ @SearchTerm+''%''''  
  
or  t.TC_No like  ''''''+ @SearchTerm+''%''''  
  
or  t.TC_Issue_Date like  ''''''+ @SearchTerm+''%''''  
  
or  t.TC_Relieving_Date like  ''''''+ @SearchTerm+''%''''      
      
)      
      
           
        )                 
            
        SELECT             
            Student_Reg_Id,                  
   ID,         
   BloodGroup,         
   IdentificationNumber ,                  
   CandidateName,                  
   Gender,                  
   DOB,                  
   Course_Category_Id,                  
   Department_Id,                  
   Class,                  
   Student_Reg_No,                  
   Telephone,  
   Candidate_Email,  
   TC_Id,   
   TC_No,   
   TC_Issue_Date,  
   TC_Relieving_Date,  
   First_Admission_Date,  
   Last_studied_Class,  
   TC_Admission_Date,            
   newstatus,            
   Course_Department_Id,                             
   new_dept ,            
   Course_Category_Name,  
   RowNumber                                  
        FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (                                
             SELECT   
SR.Student_Reg_Id,                  
SR.Candidate_Id as ID,         
SG.BloodGroup,         
CP.IdentificationNo as IdentificationNumber ,                  
CP.Candidate_Fname+'''' ''''+CP.Candidate_Mname+'''' ''''+CP.Candidate_Lname as CandidateName,                  
CP.Candidate_Gender as Gender,                  
CP.Candidate_Dob as DOB,                  
CC.Course_Category_Id,                  
D.Department_Id,                  
Tbl_Course_Category.Course_Category_Name+'''' ''''+D.Department_Name as Class,                  
SR.Student_Reg_No,                  
P.Candidate_Telephone as Telephone,  
P.Candidate_Email,  
t.TC_Id,   
t.TC_No,   
t.TC_Issue_Date,  
t.TC_Relieving_Date,  
t.First_Admission_Date,  
t.Last_studied_Class,  
t.TC_Admission_Date,            
Tbl_Student_Semester.Student_Semester_Current_Status as newstatus,            
Tbl_Course_Duration_Mapping.Course_Department_Id,                              
D.Department_Name as new_dept ,            
Tbl_Course_Category.Course_Category_Name   
  
,ROW_NUMBER() over (ORDER BY SR.Student_Reg_Id DESC) AS RowNumber   
               
                  
From dbo.Tbl_Student_Registration SR                  
                  
LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP  on CP.Candidate_Id=SR.Candidate_Id    
                
LEFT JOIN dbo.Tbl_Candidate_ContactDetails CD on CD.Candidate_Id=CP.Candidate_Id   
                 
LEFT JOIN dbo.Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id                  
                 
LEFT JOIN dbo.Tbl_Candidate_ContactDetails P on P.Candidate_Id=CP.Candidate_Id   
                 
left join dbo.Tbl_Student_TC_Details t on t.Candidate_Id=CP.Candidate_Id   
                 
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = CP.Candidate_Id   
           
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id   
           
left join Tbl_Course_Department on dbo.Tbl_Course_Duration_Mapping.Course_Department_Id = Tbl_Course_Department.Course_Department_Id  
            
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id   
           
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id   
           
left join Tbl_Department D on   Tbl_Course_Department.Department_Id =  D.Department_Id   
  
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CP.Candidate_Id                   
            
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and CP.Candidate_DelStatus=0                
        )                 
            
        SELECT             
            Student_Reg_Id,                  
   ID,         
   BloodGroup,         
   IdentificationNumber ,                  
   CandidateName,                  
   Gender,                  
   DOB,                  
   Course_Category_Id,                  
   Department_Id,                  
   Class,                  
   Student_Reg_No,                  
   Telephone,  
   Candidate_Email,  
   TC_Id,   
   TC_No,   
   TC_Issue_Date,  
   TC_Relieving_Date,  
   First_Admission_Date,  
   Last_studied_Class,  
   TC_Admission_Date,          
   newstatus,            
   Course_Department_Id,                              
   new_dept ,            
   Course_Category_Name,  
   RowNumber                                  
        FROM             
            tempProfile  WHERE RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
end      
      
   EXEC sp_executesql @SqlString            
        
            
    END            
END
    ');
END;