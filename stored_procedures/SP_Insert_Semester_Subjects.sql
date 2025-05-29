IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Semester_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Insert_Semester_Subjects](          
@Duration_Mapping_Id bigint,          
@Department_Subjects_Id bigint,          
@Semester_Subjects_Status bit)          
AS          
BEGIN         
DECLARE @Semester_Subject_Id AS BIGINT;       
DECLARE @Class_Name AS VARCHAR(200);    
DECLARE @Subject_Name AS VARCHAR(200);    
DECLARE @Course_Desc AS VARCHAR(200);    
DECLARE @Class_Id AS BIGINT;     
          
       
--IF NOT EXISTS(SELECT * FROM dbo.Tbl_Semester_Subjects WHERE Department_Subjects_Id = @Department_Subjects_Id        
--            AND Duration_Mapping_Id = @Duration_Mapping_Id)         
BEGIN        
INSERT INTO Tbl_Semester_Subjects(Duration_Mapping_Id,Department_Subjects_Id,Semester_Subjects_Status)          
VALUES(@Duration_Mapping_Id,@Department_Subjects_Id,@Semester_Subjects_Status)       
      
--Set @Semester_Subject_Id=(Select @@IDENTITY)      
---- LMS INSERT CLASS      
      
--SET @Class_Name=( SELECT TOP 1              
-- B.Subject_Name+'' - ''+         
----CC.Course_Category_Name+'', ''+              
--CBD.Batch_Code+'', ''+         
--CS.Semester_Code+''- ''+         
--D.Department_Name             
        
--  FROM Tbl_Subject B                
--LEFT JOIN Tbl_Subject A on A.Parent_Subject_Id=B.Subject_Id              
--INNER JOIN Tbl_Department_Subjects DS on DS.Subject_Id=B.Subject_Id              
--INNER JOIN Tbl_Semester_Subjects SS on SS.Department_Subjects_Id=DS.Department_Subject_Id              
--INNER JOIN Tbl_Course_Department CD on CD.Course_Department_Id=DS.Course_Department_Id              
--INNER JOIN Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id              
--INNER JOIN Tbl_Department D on D.Department_Id=CD.Department_Id              
--INNER JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id              
--INNER JOIN Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id              
--INNER JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id              
--INNER JOIN Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id            
--where SS.Semester_Subject_Id=@Semester_Subject_Id)     
    
--SET @Subject_Name=( SELECT TOP 1              
-- B.Subject_Name         
        
--  FROM Tbl_Subject B                
--LEFT JOIN Tbl_Subject A on A.Parent_Subject_Id=B.Subject_Id              
--INNER JOIN Tbl_Department_Subjects DS on DS.Subject_Id=B.Subject_Id              
--INNER JOIN Tbl_Semester_Subjects SS on SS.Department_Subjects_Id=DS.Department_Subject_Id              
--INNER JOIN Tbl_Course_Department CD on CD.Course_Department_Id=DS.Course_Department_Id              
--INNER JOIN Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id              
--INNER JOIN Tbl_Department D on D.Department_Id=CD.Department_Id              
--INNER JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id              
--INNER JOIN Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id              
--INNER JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id              
--INNER JOIN Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id            
--where SS.Semester_Subject_Id=@Semester_Subject_Id)      
    
--SET @Course_Desc=( SELECT TOP 1                 
--CC.Course_Category_Name+'', ''+              
--CBD.Batch_Code+'', ''+         
--CS.Semester_Code+''- ''+         
--D.Department_Name             
        
--  FROM Tbl_Subject B                
--LEFT JOIN Tbl_Subject A on A.Parent_Subject_Id=B.Subject_Id       
--INNER JOIN Tbl_Department_Subjects DS on DS.Subject_Id=B.Subject_Id        
--INNER JOIN Tbl_Semester_Subjects SS on SS.Department_Subjects_Id=DS.Department_Subject_Id              
--INNER JOIN Tbl_Course_Department CD on CD.Course_Department_Id=DS.Course_Department_Id              
--INNER JOIN Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id              
--INNER JOIN Tbl_Department D on D.Department_Id=CD.Department_Id              
--INNER JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id              
--INNER JOIN Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id              
--INNER JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id              
--INNER JOIN Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id            
--where SS.Semester_Subject_Id=@Semester_Subject_Id)            
      
--INSERT INTO  LMS_Tbl_Class (Class_Name,Is_Existing_Class,Type,Type_Id,Active_Status)      
--VALUES(@Class_Name,1,''Subject'',@Semester_Subject_Id,1)     
    
----to insert Lms course created by sumithra on 25/4/2014    
--set @Class_Id =(Select @@IDENTITY)    
--INSERT INTO LMS_Tbl_Course(Course_Name,Is_Existing_Course,Type,Type_Id,Active_Status,Course_Description,Class_Id)      
--VALUES(@Subject_Name,1,''Subject'',@Semester_Subject_Id,1,@Course_Desc,@Class_Id)     
      
END        
          
            
END


--select * from Tbl_Subject

    ');
END;
