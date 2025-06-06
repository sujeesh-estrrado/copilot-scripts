IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Misc_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_Misc_Details]
        @Duration_Mapping_Id BIGINT 
        AS  
        BEGIN    
            IF(@Duration_Mapping_Id = 0)  
            BEGIN                  
                SELECT DISTINCT 
                    CPD.Candidate_Id, 
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,                        
                    CPD.AdharNumber,
                    D.Course_Code,                        
                    CBD.Batch_Code,                        
                    SUM(FEM.Amount) AS Amountobepaid,
                    CBD.Batch_Id,                        
                    D.Department_Name,
                    D.Department_Id,
                    D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CS.Semester_Code AS BatchSemester,
                    FEM.ItemDescription,
                    ISNULL(FEM.Paid, 0) AS Paid,              
                    FEM.FeeHeadId,
                    FEM.Amount - ISNULL(FEM.Paid, 0) AS balance
                FROM dbo.Tbl_Fee_Entry_Main FEM 
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON FEM.Candidate_Id = CPD.Candidate_Id                        
                INNER JOIN dbo.Tbl_Student_Registration SR ON SR.Candidate_Id = FEM.Candidate_Id                        
                INNER JOIN dbo.Tbl_Department D ON SR.Department_Id = D.Department_Id                        
                INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Candidate_Id = FEM.Candidate_Id                        
                INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = SS.Duration_Mapping_Id                        
                INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id                        
                INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id      
                INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id
                WHERE FEM.typ = ''MISC'' 
                    AND FEM.ActiveStatus IS NULL 
                    AND SS.Student_Semester_Current_Status = 1  
                GROUP BY 
                    CPD.Candidate_Id, 
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname,                        
                    CPD.AdharNumber, 
                    CBD.Batch_Code, 
                    FEM.Paid, 
                    D.Department_Name, 
                    CBD.Batch_Id, 
                    D.Department_Id, 
                    D.Course_Code, 
                    FEM.ItemDescription, 
                    FEM.Paid, 
                    FEM.FeeHeadId, 
                    FEM.Amount, 
                    CS.Semester_Code;
            END 
            ELSE
            BEGIN                  
                SELECT DISTINCT 
                    CPD.Candidate_Id, 
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CandidateName,                        
                    CPD.AdharNumber,
                    D.Course_Code,                        
                    CBD.Batch_Code,                        
                    SUM(FEM.Amount) AS Amountobepaid,
                    CBD.Batch_Id,                        
                    D.Department_Name,
                    D.Department_Id,
                    D.Course_Code + ''-'' + CBD.Batch_Code + ''-'' + CS.Semester_Code AS BatchSemester,
                    FEM.ItemDescription,
                    ISNULL(FEM.Paid, 0) AS Paid,              
                    FEM.FeeHeadId,
                    FEM.Amount - ISNULL(FEM.Paid, 0) AS balance
                FROM dbo.Tbl_Fee_Entry_Main FEM 
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON FEM.Candidate_Id = CPD.Candidate_Id                        
                INNER JOIN dbo.Tbl_Student_Registration SR ON SR.Candidate_Id = FEM.Candidate_Id                        
                INNER JOIN dbo.Tbl_Department D ON SR.Department_Id = D.Department_Id                        
                INNER JOIN dbo.Tbl_Student_Semester SS ON SS.Candidate_Id = FEM.Candidate_Id                        
                INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = SS.Duration_Mapping_Id                        
                INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id                        
                INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id      
                INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id          
                WHERE FEM.typ = ''MISC'' 
                    AND FEM.ActiveStatus IS NULL 
                    AND SS.Student_Semester_Current_Status = 1  
                    AND CDM.Duration_Mapping_Id = @Duration_Mapping_Id                       
                GROUP BY 
                    CPD.Candidate_Id, 
                    CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname,                        
                    CPD.AdharNumber, 
                    CBD.Batch_Code, 
                    FEM.Paid, 
                    D.Department_Name, 
                    CBD.Batch_Id, 
                    D.Department_Id, 
                    D.Course_Code, 
                    FEM.ItemDescription, 
                    FEM.Paid, 
                    FEM.FeeHeadId, 
                    FEM.Amount, 
                    CS.Semester_Code;
            END 
        END
    ')
END
