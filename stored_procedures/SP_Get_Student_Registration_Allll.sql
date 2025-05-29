IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Registration_Allll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE procedure [dbo].[SP_Get_Student_Registration_Allll]                  
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
        (SELECT ROW_NUMBER() OVER (ORDER BY sr.Student_Reg_No DESC) AS RowNumber,       
    
       
       sr.Student_Reg_No as [Reg No],                        
       sr.Student_Reg_Id,                             
       sr.Candidate_Id as ID,                                   
       cc.Course_Category_Name+''''-''''+D.Department_Name as Class,     
    Batch_Code+''''-''''+Semester_Code AS BatchSemester,                         
       cc.Course_Category_Id,                        
       D.Department_Id,                              
       cpd.Candidate_Fname,      
       cpd.Candidate_Mname,      
       cpd.Candidate_Lname,                         
       cpd.Candidate_Fname+'''' ''''+cpd.Candidate_Mname+'''' ''''+cpd.Candidate_Lname As CandidateName,           
       ccd.Candidate_Email,                                           
       cc.Course_Category_Name as [Category],          
       NA.Batch_Id as BatchID,           
       cdm.Duration_Mapping_Id,                      
       CBD.Batch_Code as Batch,      
       SE.Semester_Code as Semester,                        
       D.Department_Name,                                 
       cdm.Course_Department_Id,                                            
       D.Department_Name as new_dept,                    
       cc.Course_Category_Name,    
    cpd.Candidate_Gender as Gender,                                        
       cpd.Candidate_Dob as DOB,     
    SG.BloodGroup,        
       ss.Student_Semester_Current_Status     
     
      FROM Tbl_Student_Registration sr        
         
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = sr.UserId)      
                         
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id      
          
inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id           
                    
inner Join dbo.Tbl_Candidate_ContactDetails ccd on ccd.Candidate_Id=cpd.Candidate_Id       
                         
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id      
                     
left join Tbl_Student_Semester ss on ss.Candidate_Id = cpd.Candidate_Id       
                   
left join Tbl_Course_Duration_Mapping cdm on ss.Duration_Mapping_Id = cdm.Duration_Mapping_Id      
         
Inner Join Tbl_Course_Duration_PeriodDetails CP On cdm.Duration_Period_Id=CP.Duration_Period_Id       
        
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id       
       
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id       
                 
left join Tbl_Course_Department cd on cdm.Course_Department_Id = cd.Course_Department_Id      
                    
left join Tbl_Course_Category  on cd.Course_Category_Id = cc.Course_Category_Id      
                    
left join Tbl_Course_Level cl on  cc.Course_level_Id = cl.Course_level_Id       
                   
left join Tbl_Department D on   cd.Department_Id =  D.Department_Id      
                       
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = cpd.Candidate_Id      
      
where ss.Student_Semester_Current_Status=1         
           
and  (Student_Reg_No like  ''''''+ @SearchTerm+''%''''      
      
or  cpd.Candidate_Fname+'''' ''''+cpd.Candidate_Mname+'''' ''''+cpd.Candidate_Lname like  ''''''+ @SearchTerm+''%''''      
      
            
            
or  Gender like  ''''''+ @SearchTerm+''%''''      
      
or  Course_Category_Name+''''-''''+Department_Name like  ''''''+ @SearchTerm+''%''''       
      
or  Department_Name like  ''''''+ @SearchTerm+''%''''             
          
or  Class like  ''''''+ @SearchTerm+''%''''        
      
or  Batch+''''-''''+Semester like  ''''''+ @SearchTerm+''%''''       
      
or  Batch like  ''''''+ @SearchTerm+''%''''       
      
or  Semester like  ''''''+ @SearchTerm+''%''''          
          
or  BatchSemester like  ''''''+ @SearchTerm+''%''''           
           
)          
          
        )                       
                  
        SELECT      
      
       [Reg No],                        
       Student_Reg_Id,                             
       ID,                                   
       Class,     
    BatchSemester,                         
       Course_Category_Id,                        
       Department_Id,                              
       Candidate_Fname,      
       Candidate_Mname,      
       Candidate_Lname,                         
       CandidateName,           
       Candidate_Email,                                           
       [Category],          
       BatchID,           
       Duration_Mapping_Id,                      
       Batch,      
       Semester,                        
       Department_Name,                                 
       Course_Department_Id,                                            
       new_dept,                    
       Course_Category_Name,    
    Gender,                                        
       DOB,     
    BloodGroup,        
       Student_Semester_Current_Status,       
       RowNumber                                     
        FROM                   
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)                
           
END            
        
--IF @SearchTerm is null              
            
 IF (@SearchTerm is null or @SearchTerm = '''')            
            
begin            
            
 SET @SqlString=''WITH tempProfile AS                  
        (SELECT ROW_NUMBER() OVER (ORDER BY sr.Student_Reg_No DESC) AS RowNumber,    
      
       sr.Student_Reg_No as[Reg No],                        
       sr.Student_Reg_Id,                             
       sr.Candidate_Id as ID,                                   
       cc.Course_Category_Name+''''-''''+D.Department_Name as Class,     
    Batch_Code+''''-''''+Semester_Code AS BatchSemester,                         
       cc.Course_Category_Id,                        
       D.Department_Id,                              
       cpd.Candidate_Fname,      
       cpd.Candidate_Mname,      
       cpd.Candidate_Lname,                         
       cpd.Candidate_Fname+'''' ''''+cpd.Candidate_Mname+'''' ''''+cpd.Candidate_Lname As CandidateName,           
       ccd.Candidate_Email,                                           
       cc.Course_Category_Name as [Category],          
       NA.Batch_Id as BatchID,           
       cdm.Duration_Mapping_Id,                      
       CBD.Batch_Code as Batch,      
       SE.Semester_Code as Semester,                        
       D.Department_Name,                                 
       cdm.Course_Department_Id,                                            
       D.Department_Name as new_dept,                    
       cc.Course_Category_Name,    
    cpd.Candidate_Gender as Gender,                                        
   cpd.Candidate_Dob as DOB,     
    SG.BloodGroup,        
       ss.Student_Semester_Current_Status     
     
      FROM Tbl_Student_Registration sr        
         
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = sr.UserId)      
                         
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id      
          
inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id           
                    
inner Join dbo.Tbl_Candidate_ContactDetails ccd on ccd.Candidate_Id=cpd.Candidate_Id       
                         
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id      
                     
left join Tbl_Student_Semester ss on ss.Candidate_Id = cpd.Candidate_Id       
                   
left join Tbl_Course_Duration_Mapping cdm on ss.Duration_Mapping_Id = cdm.Duration_Mapping_Id      
         
Inner Join Tbl_Course_Duration_PeriodDetails CP On cdm.Duration_Period_Id=CP.Duration_Period_Id       
        
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id       
       
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id       
                 
left join Tbl_Course_Department cd on cdm.Course_Department_Id = cd.Course_Department_Id      
                    
left join Tbl_Course_Category  on cd.Course_Category_Id = cc.Course_Category_Id      
                    
left join Tbl_Course_Level cl on  cc.Course_level_Id = cl.Course_level_Id       
                   
left join Tbl_Department D on   cd.Department_Id =  D.Department_Id      
                       
left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = cpd.Candidate_Id    
      
where ss.Student_Semester_Current_Status=1         
           
          
            
  )                       
                  
        SELECT          
      
       [Reg No],                        
       Student_Reg_Id,                             
       ID,                                   
       Class,     
    BatchSemester,                         
       Course_Category_Id,                        
       Department_Id,                              
       Candidate_Fname,      
       Candidate_Mname,      
       Candidate_Lname,                         
       CandidateName,           
       Candidate_Email,                                           
       [Category],          
       BatchID,           
       Duration_Mapping_Id,                      
       Batch,      
       Semester,                        
       Department_Name,                                 
       Course_Department_Id,                                            
       new_dept,                    
       Course_Category_Name,    
    Gender,                                        
       DOB,     
    BloodGroup,        
       Student_Semester_Current_Status,       
    RowNumber                                     
        FROM                   
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)         
               
end            
            
   EXEC sp_executesql @SqlString                  
              
                 
    END                  
END
    ');
END;