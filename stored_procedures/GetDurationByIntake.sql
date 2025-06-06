IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetDurationByIntake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[GetDurationByIntake] --1
@Duration_Mapping_Id bigint
as
begin

SELECT                 
ROW_NUMBER() OVER                                   
   (PARTITION BY  cd.Duration_Period_Id  order by cd.Duration_Period_Id)as num,cd.Duration_Period_Id          
      ,cd.Batch_Id                
      ,cd.Semester_Id                
      ,convert(varchar(50),Duration_Period_From,103)+''-''+         
      convert(varchar(50),Duration_Period_To,103) as Duration_Period                
      ,Duration_Period_Status                
      ,Semester_Name                
   ,Batch_Code ,        
   convert(varchar(50),Closing_Date,103) as Closing_Date  ,        
   CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,Duration_Mapping_Id              
              
  FROM Tbl_Course_Duration_PeriodDetails cd                 
left JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id                
left JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id               
left JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id               
left JOIN Tbl_Course_Department Cdep on Cdep.Department_Id=CDM.Course_Department_Id             
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id              
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id              
              
WHERE Duration_Period_Status=0
and Duration_Mapping_Id=@Duration_Mapping_Id
end

--select * from Tbl_Course_Duration_Mapping
--Tbl_Course_Batch_Duration

    ')
END
