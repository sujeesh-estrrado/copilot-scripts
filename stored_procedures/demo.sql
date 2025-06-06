IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[demo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[demo] --226            
@Course_Department_Id bigint             
AS              
BEGIN              
SELECT               
Duration_Mapping_Id,Batch_From,Batch_To,              
Batch_Code+''-''+Semester_Code AS BatchSemester              
 FROM Tbl_Course_Duration_PeriodDetails cd               
left JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id              
left JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id      
left JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id             
left JOIN Tbl_Course_Department Cdep on Cdep.Course_Department_Id=CDM.Course_Department_Id           
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id            
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id     
where Duration_Mapping_Id= @Course_Department_Id    
  
  
 
     
END
    ')
END
