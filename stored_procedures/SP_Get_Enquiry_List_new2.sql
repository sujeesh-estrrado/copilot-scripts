IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Enquiry_List_new2]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_Enquiry_List_new2]-- 1,100,'''',''--select--'',''--select--'',''--select--'',''28/12/2015'',''28/12/2015''          
(              
@CurrentPage int=null ,                             
@PageSize int=null   ,                          
@SearchTerm varchar(100),          
@CounselorCampus1 varchar(50) ,          
@EmployeeName varchar(50),          
@Type1 varchar(50),      
@from   varchar(50),      
@to varchar(50)      
              
)                                                       
AS                                                    
BEGIN               
SET NOCOUNT ON                                  
    DECLARE @Unspecified  nvarchar(max) set  @Unspecified=''Unspecified''               
    DECLARE @Admin  nvarchar(max) set  @Admin=''Admin''                       
    DECLARE @SqlString nvarchar(max)                              
    Declare @SqlStringWithout nvarchar(max)                                  
    Declare @UpperBand int                                  
    Declare @LowerBand int                                          
                                     
    SET @LowerBand  = (@CurrentPage -              
     1) * @PageSize                                  
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                 
     --BEGIN                                  
--WITH tempProfile AS              
  IF OBJECT_ID(''#TEMP1'', ''U'') IS NOT NULL          
  DROP TABLE #TEMP1;    
    IF OBJECT_ID(''#TEMP2'', ''U'') IS NOT NULL          
  DROP TABLE #TEMP2;         
    if(@from=@to)      
       begin                 
SELECT * InTO #TEMP1 FROM                                                
     ( SELECT ROW_NUMBER() OVER (ORDER BY ID desc) AS RowNumber,Base.*  FROM                                               
(SELECT CPD.Candidate_Id as ID,SG.BloodGroup,              
EC.Employee_FName+'' ''+EC.Employee_LName as Employee_Name,              
CPD.RegDate,              
CPD.CounselorCampus,              
CPD.TypeOfStudent,                                                
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                                             
CPD.Candidate_Fname,CPD.AdharNumber,                                                            
CPD.Candidate_Dob as DOB,                                                 
CPD.New_Admission_Id as AdmnID,                                  
CC.Candidate_idNo as IdentificationNumber ,                                      
                                                
CC.Candidate_ContAddress as Address,                                                    
CC.Candidate_Mob1 as MobileNumber,                                                  
CC.Candidate_Email as EmailID ,                                          
CCat.Course_Category_Id,                              
                                         
cbd.Batch_Id as BatchID,                                          
                                                
cbd.Batch_Code as Batch,                  
NA.Batch_Id,                 
                                        
case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                  
cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                  
                
                                                
 (Case when SR.UserId IS NULL  Then '' ''                                                
 Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                
                                                  
 NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                  
 NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                           
                                               
 NA.Department_Id as DepartmentID,                                        
                                      
                                        
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                  
D.Department_Id=NA.Department_Id)  end  as Department                   
                  
                                   
FROM Tbl_Candidate_Personal_Det  CPD                                                  
                                   
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                           
left join                        
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                         
and   ss.student_semester_current_status=1                          
left JOIN                               
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                               
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id              
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                   
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                                 
                          
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                           
                                               
                                          
                                              
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                               
                                               
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                   
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                                  
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                 
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                       
   left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id               
left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id and EC.Employee_Status=0)where CPD.Candidate_DelStatus=0  
and (CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname like ''''+ @SearchTerm +''%''   
or CCat.Course_Category_Name like  ''''+ @SearchTerm +''%'' or CC.Candidate_Mob1 like  ''''+ @SearchTerm +''%'' or CC.Candidate_Email like  ''''+ @SearchTerm +''%'' or @SearchTerm='''')  
and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'')  
and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')  
and (EC.Employee_FName+'' ''+EC.Employee_LName=@EmployeeName or @EmployeeName=''--Select--'')  
and (convert(datetime,CPD.RegDate,103)>= convert(datetime,@from,103)or @from='''' )   
)Base )A  
 SELECT                     
            ID,                       
            BloodGroup,                                               
            CandidateName,              
            Employee_Name,               
           convert(varchar(10),RegDate,103)RegDate,              
                 case CounselorCampus when ''--Select--''then '' '' else CounselorCampus  end CounselorCampus,          
             case TypeOfStudent when ''--Select--''then '' '' else TypeOfStudent  end TypeOfStudent,                                        
            Candidate_Fname ,                         
            AdharNumber ,                  
            convert(varchar(10),DOB,103)DOB,                     
            AdmnID ,                    
            IdentificationNumber,                    
     Address,                  
            MobileNumber,              
             EmailID,               
             BatchID,                 
             Course_Category_Id,                 
             Batch,              
              Batch_Id,              
              Batch_Code,              
              UserName,              
               [LevelName],             
                [Category],              
                 DepartmentID,              
                Department,                            
            RowNumber                                                      
        FROM                                   
            #TEMP1          
            where            
  RowNumber >  CONVERT(VARCHAR,@LowerBand)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand)   
end   
else  
begin  
SELECT * InTO #TEMP2 FROM                                                
     ( SELECT ROW_NUMBER() OVER (ORDER BY ID desc) AS RowNumber,Base.*  FROM                                               
(SELECT CPD.Candidate_Id as ID,SG.BloodGroup,              
EC.Employee_FName+'' ''+EC.Employee_LName as Employee_Name,              
CPD.RegDate,              
CPD.CounselorCampus,              
CPD.TypeOfStudent,                                                
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CandidateName,                                             
CPD.Candidate_Fname,CPD.AdharNumber,                                                            
CPD.Candidate_Dob as DOB,                                                 
CPD.New_Admission_Id as AdmnID,                                  
CC.Candidate_idNo as IdentificationNumber ,                                      
                                                
CC.Candidate_ContAddress as Address,                                                    
CC.Candidate_Mob1 as MobileNumber,                                                  
CC.Candidate_Email as EmailID ,                                          
CCat.Course_Category_Id,                              
                                         
cbd.Batch_Id as BatchID,                                          
                                                
cbd.Batch_Code as Batch,                  
NA.Batch_Id,                 
                                        
case when  NA.Batch_Id=0 then ''Unspecified'' else (select cbd.Batch_Code from Tbl_Course_Batch_Duration cbd where                  
cbd.Batch_Id=NA.Batch_Id)  end  as Batch_Code,                  
                
                                                
 (Case when SR.UserId IS NULL  Then '' ''                                                
 Else Isnull(E. Employee_FName,''Admin'') END) as UserName,                                                
                                                  
 NA.Course_Level_Id as [LevelID],CL.Course_Level_Name as [LevelName],                                                  
 NA.Course_Category_Id as CategoryID,CCat.Course_Category_Name as [Category],                                           
                                               
 NA.Department_Id as DepartmentID,                                        
                                      
                                        
case when  NA.Department_Id=0 then ''Unspecified'' else (select D.Department_Name from Tbl_Department D where                  
D.Department_Id=NA.Department_Id)  end  as Department                   
                  
                                   
FROM Tbl_Candidate_Personal_Det  CPD                                                  
                                   
left join  Tbl_Candidate_ContactDetails CC on CPD.Candidate_Id=CC.Candidate_Id                           
left join                        
dbo.Tbl_Student_Semester SS on SS.Candidate_Id=CPD.Candidate_Id   and  SS.Student_Semester_Delete_Status=0                         
and   ss.student_semester_current_status=1                          
left JOIN                               
Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                               
left JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id              
left JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                                   
left JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                                 
                          
left join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id                                           
                                               
                                          
                                              
left join Tbl_Course_Level CL On CL.Course_Level_Id=NA.Course_Level_Id                               
                                               
left join Tbl_Course_Category CCat On CCat.Course_Category_Id=NA.Course_Category_Id                   
left join  Tbl_Department D on NA.Department_Id=D.Department_Id                                                
--inner join Tbl_Department D On D.Department_Id=NA.Department_Id                                                  
LEFT JOIN Tbl_Student_Registration SR on CPD.Candidate_Id = SR.Candidate_Id                                                 
LEFT JOIN Tbl_Employee E on E.Employee_Id= (Select Employee_Id from dbo.Tbl_Employee_User where [User_Id] = SR.UserId)                       
   left join dbo.Tbl_Student_Health_General SG ON  SG.StudentId = CPD.Candidate_Id               
left join  Tbl_Employee EC on (EC.Employee_Id=CPD.CounselorEmployee_id and EC.Employee_Status=0)where CPD.Candidate_DelStatus=0  
and (CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname like ''''+ @SearchTerm +''%''   
or CCat.Course_Category_Name like  ''''+ @SearchTerm +''%'' or CC.Candidate_Mob1 like  ''''+ @SearchTerm +''%'' or CC.Candidate_Email like  ''''+ @SearchTerm +''%'' or @SearchTerm='''')  
and (CPD.CounselorCampus= @CounselorCampus1 or @CounselorCampus1=''--Select--'')  
and(CPD.TypeOfStudent=@Type1 or @Type1=''--Select--'')  
and (EC.Employee_FName+'' ''+EC.Employee_LName=@EmployeeName or @EmployeeName=''--Select--'')  
and (convert(datetime,RegDate,103)>= convert(datetime,@from,103) or @from='''')  
and (convert(datetime,RegDate,103)<= convert(datetime,@to,103)or @to='''')    
)Base )A  
 SELECT                     
            ID,                       
            BloodGroup,                                               
            CandidateName,              
            Employee_Name,               
           convert(varchar(10),RegDate,103)RegDate,              
                 case CounselorCampus when ''--Select--''then '' '' else CounselorCampus  end CounselorCampus,          
             case TypeOfStudent when ''--Select--''then '' '' else TypeOfStudent  end TypeOfStudent,                                        
            Candidate_Fname ,                         
            AdharNumber ,                  
            convert(varchar(10),DOB,103)DOB,                     
            AdmnID ,                    
            IdentificationNumber,                    
     Address,                  
            MobileNumber,              
             EmailID,               
             BatchID,                 
             Course_Category_Id,                 
             Batch,              
              Batch_Id,              
              Batch_Code,              
              UserName,              
               [LevelName],             
                [Category],              
                 DepartmentID,              
                Department,                            
            RowNumber                                                      
        FROM                                   
            #TEMP2          
            where            
  RowNumber >  CONVERT(VARCHAR,@LowerBand)   AND RowNumber <  CONVERT(VARCHAR, @UpperBand)   
end                  
           
       
       End
    ')
END
