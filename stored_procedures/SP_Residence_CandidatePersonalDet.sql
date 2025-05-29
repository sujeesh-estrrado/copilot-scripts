IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Residence_CandidatePersonalDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Residence_CandidatePersonalDet]          
(
    @Candidate_Id BIGINT,  
    @Flag BIGINT  
)                                    
AS                                    
BEGIN     
    IF (@Flag = 1)                    
    BEGIN    
        SELECT DISTINCT 
            CPD.Candidate_Id,
            AdharNumber,
            CONCAT(Candidate_Fname, '' '', candidate_Lname) AS CandidateName,        
            IDMatrixNo,
            cbd.Batch_Code,
            IM.id AS IntakeId,
            CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,      
            D.Department_Id,
            CS.Semester_Name,
            SSS.name,
            CC.Candidate_Email AS EmailID,
            ApplicationStatus,      
            CASE 
                WHEN ApplicationStatus = ''pending'' THEN ''Enquiry''            
                WHEN ApplicationStatus = ''Pending'' THEN ''Enquiry''            
                WHEN ApplicationStatus = ''submited'' THEN ''Enquiry''          
                WHEN ApplicationStatus = ''Completed'' THEN ''Student'' 
            END AS TypeName       
        FROM Tbl_Candidate_Personal_Det CPD        
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id       
        LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id        
        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id       
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id        
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterId        
        LEFT JOIN Tbl_Student_semester SS ON SS.Candidate_Id = CPD.Candidate_Id        
        LEFT JOIN Tbl_Course_Semester CS ON CS.Semester_Id = SS.SEMESTER_NO        
        LEFT JOIN Tbl_Student_Status SSS ON SSS.id = CPD.active   
        LEFT JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id = NA.Batch_Id  
        WHERE CPD.Candidate_Id = @Candidate_Id   
    END  
	END
');
END;