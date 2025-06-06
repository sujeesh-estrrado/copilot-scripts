IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Ge_Course_Employee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Ge_Course_Employee]           
        @Employee_Id BIGINT          
        AS          
        BEGIN          
            SELECT DISTINCT  
                Course_Code + ''-'' + Batch_Code + ''-'' + Semester_Code AS Batch, 
                SS.Duration_Mapping_Id AS Batch_Id, 
                SS.Duration_Mapping_Id          
            FROM dbo.Tbl_Class_TimeTable CT            
            INNER JOIN dbo.Tbl_Semester_Subjects SS 
                ON CT.Semster_Subject_Id = SS.Semester_Subject_Id            
            INNER JOIN dbo.Tbl_Department_Subjects DS 
                ON DS.Department_Subject_Id = SS.Department_Subjects_Id            
            INNER JOIN dbo.Tbl_Subject S 
                ON S.Subject_Id = DS.Subject_Id            
            INNER JOIN Tbl_Course_Duration_Mapping DM 
                ON SS.Duration_Mapping_Id = DM.Duration_Mapping_Id                
            INNER JOIN Tbl_Course_Duration_PeriodDetails CP 
                ON DM.Duration_Period_Id = CP.Duration_Period_Id                
            INNER JOIN Tbl_Course_Batch_Duration B 
                ON CP.Batch_Id = B.Batch_Id                
            INNER JOIN Tbl_Course_Semester SE 
                ON CP.Semester_Id = SE.Semester_Id                
            INNER JOIN Tbl_Course_Department CD 
                ON CD.Department_Id = DM.Course_Department_Id               
            INNER JOIN Tbl_Course_Category CC 
                ON CC.Course_Category_Id = CD.Course_Category_Id              
            INNER JOIN Tbl_Department D 
                ON CD.Department_Id = D.Department_Id          
            WHERE CT.Employee_Id = @Employee_Id          
        END
    ')
END
ELSE
BEGIN
EXEC('-- create by Karthika          
ALTER procedure [dbo].[Ge_Course_Employee]           
@Employee_Id bigint          
as          
begin          
          
           
SELECT distinct  Course_Code+''-''+Batch_Code+''-''+Semester_Code as Batch, SS.Duration_Mapping_Id as Batch_Id, SS.Duration_Mapping_Id          
 FROM dbo.Tbl_Class_TimeTable CT            
INNER JOIN dbo.Tbl_Semester_Subjects SS ON CT.Semster_Subject_Id=SS.Semester_Subject_Id            
INNER JOIN dbo.Tbl_Department_Subjects DS ON DS.Department_Subject_Id=SS.Department_Subjects_Id            
INNER JOIN dbo.Tbl_Subject S ON S.Subject_Id=DS.Subject_Id            
          
Inner Join Tbl_Course_Duration_Mapping DM On SS.Duration_Mapping_Id=DM.Duration_Mapping_Id                
Inner Join Tbl_Course_Duration_PeriodDetails CP On DM.Duration_Period_Id=CP.Duration_Period_Id                
Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id                
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id                
Inner Join Tbl_Course_Department CD On CD.Department_Id=DM.Course_Department_Id               
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id              
Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id          
WHERE CT.Employee_Id=@Employee_Id          
end


')
END
