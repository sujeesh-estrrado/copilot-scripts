IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[CHECK_SEMESTER_student_bulkupload]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[CHECK_SEMESTER_student_bulkupload]

 @Department_Name NVARCHAR(255), 
    @Batch_Code NVARCHAR(50) ,
     @faculty NVARCHAR(255) ,
     @Semester NVARCHAR(255) 

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT              
cd.Duration_Period_Id            
      ,cd.Batch_Id                  
      ,cd.Semester_Id                  
      ,convert(varchar(50),Duration_Period_From,103) as Duration_Period_From           
      ,convert(varchar(50),Duration_Period_To,103) as Duration_Period_To                   
      ,Duration_Period_Status                  
      ,Semester_Name  ,
    --CASE 
 --       WHEN CHARINDEX(''-'', Batch_Code) > 0 
 --       THEN LEFT(Batch_Code, CHARINDEX(''-'', Batch_Code) - 1)
 --       ELSE Batch_Code
 --   END AS Batch_Code ,               
   Batch_Code ,          
   convert(varchar(50),Closing_Date,103) as Closing_Date  ,          
   --CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,  
    D.Department_Name,    
   D.Department_Id as ProgramID,CL.Course_Level_Name  
                
  FROM Tbl_Course_Duration_PeriodDetails cd                   
left JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id                  
left JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id                 
left JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id                 
left JOIN Tbl_Course_Department Cdep on Cdep.Department_Id=CDM.Course_Department_Id               
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id                
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id    
inner join Tbl_Course_Level CL on D.GraduationTypeId=CL.Course_Level_Id  

WHERE D.Department_Name = @Department_Name AND LEFT(Batch_Code, 7) = @Batch_Code and Course_Level_Name =@faculty and Semester_Name = @Semester;



END
    ')
END;
