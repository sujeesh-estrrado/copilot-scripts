IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Batch_Course_Semester]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Batch_Course_Semester]     
(    
@facultyid bigint=0,    
 @CurrentPage bigint=0,    
 @pagesize bigint=0,    
 @SearchKeyWord varchar(max))       
AS        
Begin        
      
   if (@facultyid=0)    
   begin      
Select * from         
(Select         
ROW_NUMBER() Over (Partition By S.Duration_Mapping_Id Order By S.Duration_Mapping_Id) AS RNO,        
S.Duration_Mapping_Id as DurationMappingID,        
S.Semester_Subject_Id,        
CP.Batch_Id,        
CP.Semester_Id,        
B.Batch_Code as BatchName,      
Batch_Code+''-''+Semester_Code AS BatchSemester,        
B.Batch_Id as BatchID,        
--DM.Course_Department_Id as CourseDepartmentID,  
D.Department_Id as CourseDepartmentID,  
CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,       
      
SE.Semester_Name as SemesterName        
From Tbl_Semester_Subjects S         
--Inner Join Tbl_Course_Duration_Mapping DM On S.Duration_Mapping_Id=DM.Duration_Mapping_Id        
Inner Join Tbl_Course_Duration_PeriodDetails CP On s.Duration_Mapping_Id=CP.Duration_Period_Id        
Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id        
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id        
Inner Join Tbl_Course_Department CD On CD.Department_Id=B.Duration_Id       
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id      
Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id and (S.Duration_Mapping_Id like ''%'' +@SearchKeyWord+ ''%''or S.Semester_Subject_Id like ''%'' +@SearchKeyWord+ ''%''    
     
  or CP.Batch_Id like ''%'' +@SearchKeyWord+ ''%'' or concat(CC.Course_Category_Name,''-'',D.Department_Name) like ''%'' +@SearchKeyWord+ ''%''    
  or B.Batch_Code like ''%'' +@SearchKeyWord+ ''%'' or  concat(Batch_Code,''-'',Semester_Code) like ''%'' +@SearchKeyWord+ ''%'')) Temp_Tbl        
where Temp_Tbl.RNO=1        
ORDER By Semester_Subject_Id DESC     
OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);         
End      
else    
begin    
Select * from         
(Select         
ROW_NUMBER() Over (Partition By S.Duration_Mapping_Id Order By S.Duration_Mapping_Id) AS RNO,        
S.Duration_Mapping_Id as DurationMappingID,        
S.Semester_Subject_Id,        
CP.Batch_Id,        
CP.Semester_Id,        
B.Batch_Code as BatchName,      
Batch_Code+''-''+Semester_Code AS BatchSemester,        
B.Batch_Id as BatchID,        
--DM.Course_Department_Id as CourseDepartmentID,        
D.Department_Id as CourseDepartmentID,  
CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,       
      
SE.Semester_Name as SemesterName        
From Tbl_Semester_Subjects S         
--Inner Join Tbl_Course_Duration_Mapping DM On S.Duration_Mapping_Id=DM.Duration_Mapping_Id        
Inner Join Tbl_Course_Duration_PeriodDetails CP On s.Duration_Mapping_Id=CP.Duration_Period_Id        
Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id        
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id        
Inner Join Tbl_Course_Department CD On CD.Department_Id=B.Duration_Id      
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id      
Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id        
inner join Tbl_Emp_CourseDepartment_Allocation EA on D.GraduationTypeId=EA.Allocated_CourseDepartment_Id    
where  EA.Employee_Id=@facultyid and (S.Duration_Mapping_Id like ''%'' +@SearchKeyWord+ ''%''or S.Semester_Subject_Id like ''%'' +@SearchKeyWord+ ''%''    
     
  or CP.Batch_Id like ''%'' +@SearchKeyWord+ ''%'' or concat(CC.Course_Category_Name,''-'',D.Department_Name) like ''%'' +@SearchKeyWord+ ''%''    
  or B.Batch_Code like ''%'' +@SearchKeyWord+ ''%'' or  concat(Batch_Code,''-'',Semester_Code) like ''%'' +@SearchKeyWord+ ''%''))Temp_Tbl    
where Temp_Tbl.RNO=1       
ORDER By Semester_Subject_Id DESC     
OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
end    
end    
    
');
END;
