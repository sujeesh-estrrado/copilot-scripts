IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Duration_By_serach_Term]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_Duration_By_serach_Term] 
(              
@SearchTerm  varchar(100)              
)            
AS              
BEGIN       
             
SELECT * From (SELECT               
ROW_NUMBER() OVER                                 
   (PARTITION BY  cd.Duration_Period_Id  order by cd.Duration_Period_Id)as num,cd.Duration_Period_Id,    
       cd.Batch_Id              
      ,cd.Semester_Id              
      ,Duration_Period_From              
      ,Duration_Period_To              
      ,Duration_Period_Status              
      ,Semester_Name              
   ,Batch_Code ,      
   Closing_Date,      
   CC.Course_Category_Name+''-''+ D.Department_Name as DepartmentName            
            
  FROM Tbl_Course_Duration_PeriodDetails cd               
left JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id              
left JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id             
left JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id             
left JOIN Tbl_Course_Department Cdep on Cdep.Course_Department_Id=CDM.Course_Department_Id           
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id            
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id   ) Base         
            
WHERE    
      
(Semester_Name like  ''''+ @SearchTerm+''%''         
        
or  Batch_Code like  ''''+ @SearchTerm+''%''           
      
or  Closing_Date like  ''''+ @SearchTerm+''%''         
        
or  DepartmentName like  ''''+ @SearchTerm+''%''         
        
or  Duration_Period_From like  ''''+ @SearchTerm+''%''      
    
or  Duration_Period_To like  ''''+ @SearchTerm+''%''     
    
and  Duration_Period_Status=0     )           
                             
END
');
END;
