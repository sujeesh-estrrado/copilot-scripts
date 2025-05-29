IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_SportsCultural_Cert_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
 create procedure [dbo].[SP_Get_Student_SportsCultural_Cert_List]                    
AS                  
BEGIN                  
SELECT ss.*, 
       CD.Course_Category_Id, 
       CC.Course_Category_Name + ''-'' + dpt.Department_Name AS [Class-Division], 
       cpd.Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname AS [CandidateName],    
       dbo.Tbl_Course_Batch_Duration.Batch_Code AS BatchSemester               
FROM Tbl_Candidate_Personal_Det cpd     
INNER JOIN Tbl_Student_SportsCultural ss ON cpd.Candidate_Id = ss.Student_Id    
INNER JOIN Tbl_Course_Department CD ON CD.Course_Department_Id = ss.Class_Id   
INNER JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = CD.Course_Category_Id    
INNER JOIN Tbl_Department dpt ON dpt.Department_Id = CD.Department_Id    
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = ss.Batch_Id    
LEFT JOIN dbo.Tbl_Course_Duration_PeriodDetails CDPD ON CDPD.Duration_Period_Id = CDM.Duration_Period_Id    
LEFT JOIN Tbl_Course_Batch_Duration ON Tbl_Course_Batch_Duration.Batch_Id = CDPD.Batch_Id                     
WHERE SportsCultural_Del_Status = 0                  
END
    ')
END;
