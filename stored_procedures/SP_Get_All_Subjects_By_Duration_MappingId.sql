IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Subjects_By_Duration_MappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_Get_All_Subjects_By_Duration_MappingId]                        
@Duration_mapping_Id int =0  ,    
@CourseDepartmentID  int =0  , 
@flag bigint=0    
AS                          
Begin                          
if(@flag=0)    
begin    
 SELECT * FROM                           
 (SELECT DISTINCT                            
 S.DURATION_MAPPING_ID AS DURATIONMAPPINGID,''0.00''AS FEE_AMOUNT,                          
 C.COURSE_ID AS SEMESTER_SUBJECT_ID,                      
 S.DEPARTMENT_SUBJECTS_ID,      C.COURSE_NAME AS SUBJECTNAME   ,  CONCAT(C.COURSE_NAME,''-'',C.COURSE_CODE) AS CODE,             
 CP.BATCH_ID,                          
 CP.SEMESTER_ID,                          
 B.BATCH_CODE AS BATCHNAME,                        
 BATCH_CODE+''-''+SEMESTER_CODE AS BATCHSEMESTER,                          
 B.BATCH_ID AS BATCHID,                          
 --DM.COURSE_DEPARTMENT_ID AS COURSEDEPARTMENTID,                         
 D.DEPARTMENT_ID AS COURSEDEPARTMENTID,                    
 CC.COURSE_CATEGORY_NAME+''-''+D.DEPARTMENT_NAME AS DEPARTMENTNAME,   D.COURSE_REREG_STATUS AS EDITSTATUS,                      
                        
 SE.SEMESTER_NAME AS SEMESTERNAME                          
 FROM TBL_SEMESTER_SUBJECTS S                 
INNER JOIN TBL_NEW_COURSE C ON S.DEPARTMENT_SUBJECTS_ID   = C.COURSE_ID             
 --INNER JOIN TBL_COURSE_DURATION_MAPPING DM ON S.DURATION_MAPPING_ID=DM.DURATION_MAPPING_ID                          
 INNER JOIN TBL_COURSE_DURATION_PERIODDETAILS CP ON                    
 --DM.DURATION_PERIOD_ID=CP.DURATION_PERIOD_ID                      
 S.DURATION_MAPPING_ID=CP.DURATION_PERIOD_ID                    
 INNER JOIN TBL_COURSE_BATCH_DURATION B ON CP.BATCH_ID=B.BATCH_ID                          
 INNER JOIN TBL_COURSE_SEMESTER SE ON CP.SEMESTER_ID=SE.SEMESTER_ID                          
 INNER JOIN TBL_COURSE_DEPARTMENT CD ON CD.DEPARTMENT_ID=B.DURATION_ID                        
 INNER JOIN TBL_COURSE_CATEGORY CC ON CC.COURSE_CATEGORY_ID=CD.COURSE_CATEGORY_ID                        
 INNER JOIN TBL_DEPARTMENT D ON CD.DEPARTMENT_ID=D.DEPARTMENT_ID              
 WHERE CP.DELETE_STATUS=0)TEMP_TBL                          
 WHERE                      
 DURATIONMAPPINGID=@DURATION_MAPPING_ID                                  
 ORDER BY SUBJECTNAME 

--SELECT 
--CN.Course_Id AS Semester_Subject_Id,
-- CN.Course_code AS Subject_Code,
----CN.Course_Name AS SubjectName,
--CONCAT(CN.Course_Code, ''-'', CN.Course_Name) AS SubjectName,

-- concat(CN.Course_Name,''-'',CN.Course_code) as code, 
-- SS.Duration_Mapping_Id as DurationMappingID,''0.00''as Fee_Amount,
-- SS.Department_Subjects_Id,CP.Batch_Id,                          
-- CP.Semester_Id,
-- B.Batch_Code as BatchName,                        
-- B.Batch_Code+''-''+SE.Semester_Code AS BatchSemester,                          
-- B.Batch_Id as BatchI ,
 
-- D.Department_Id as CourseDepartmentID,                    
-- CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,   D.course_rereg_status as editstatus 

--FROM 
--Tbl_Semester_Subjects     SS
--INNER JOIN Tbl_New_Course   CN                     ON  SS.Department_Subjects_Id=CN.Course_Id
--INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON  SS.Duration_Mapping_Id=CDP.Duration_Period_Id
--INNER JOIN Tbl_Department_Subjects           DS  ON   CN.Course_Id=DS.Subject_Id
                   
-- Inner Join Tbl_Course_Duration_PeriodDetails CP On  SS.Duration_Mapping_Id=CP.Duration_Period_Id
-- Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id                        
-- Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id  
                                              
-- Inner Join Tbl_Course_Department CD On CD.Department_Id=b.Duration_Id  
-- Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id                        
-- Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id  
--WHERE 
--CDP.Duration_Period_Id=@Duration_mapping_Id
--AND DS.Course_Department_Id=@CourseDepartmentID
--AND SS.Semester_Subjects_Status=0
--AND CN.Delete_Status=0
--GROUP BY 
--        CN.Course_Id,
--        CN.Course_Name ,
--       CN.Course_code,SS.Duration_Mapping_Id, SS.Department_Subjects_Id,
--       CP.Batch_Id,   B.Batch_Code,         B.Batch_Id, D.Department_Id    ,           
-- CP.Semester_Id,SE.Semester_Code, CC.Course_Category_Name,D.Department_Name,D.course_rereg_status
--    ORDER BY SubjectName  
--end    
--if(@flag=1)    
--begin    
-- Select * from                           
-- (Select                            
-- S.Duration_Mapping_Id as DurationMappingID, fs.*,                         
-- S.Semester_Subject_Id,                        
-- S.Department_Subjects_Id,      C.Course_Name as SubjectName   ,  concat(c.Course_Name,''-'',C.Course_code) as code,             
-- CP.Batch_Id,                          
-- CP.Semester_Id,                          
-- B.Batch_Code as BatchName,                        
-- Batch_Code+''-''+Semester_Code AS BatchSemester,                          
-- B.Batch_Id as BatchID,                          
-- --DM.Course_Department_Id as CourseDepartmentID,                         
-- D.Department_Id as CourseDepartmentID,                    
-- CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,   D.course_rereg_status as editstatus,                      
                        
-- SE.Semester_Name as SemesterName                          
-- From Tbl_Semester_Subjects S                 
-- left join Tbl_New_Course C on C.Course_Id=S.Department_Subjects_Id              
-- --Inner Join Tbl_Course_Duration_Mapping DM On S.Duration_Mapping_Id=DM.Duration_Mapping_Id                          
-- Inner Join Tbl_Course_Duration_PeriodDetails CP On                    
-- --DM.Duration_Period_Id=CP.Duration_Period_Id                      
-- S.Duration_Mapping_Id=CP.Duration_Period_Id                    
-- Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id                          
-- Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id                          
-- Inner Join Tbl_Course_Department CD On CD.Department_Id=b.Duration_Id                        
-- Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id                        
-- Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id       
-- left join Tbl_ReEvaluation_Fee_Settings fs ON fs.Course_Id=c.Course_Id    
-- where CP.Delete_Status=0
-- and CD.Department_Id=@CourseDepartmentID
-- )Temp_Tbl                          
-- where                      
-- DurationMappingID=@Duration_mapping_Id    
-- ORDER By SubjectName                  
--end 
end
End   
    ')
END
