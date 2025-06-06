IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_GetStudentsforReviewGroup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[LMS_SP_GetStudentsforReviewGroup]
            @Employee_Id BIGINT
        AS
        BEGIN
            SET NOCOUNT ON;
            
            DECLARE @Duration_Mapping_Id BIGINT;
            
            -- Check if the employee is a class in-charge with status 0
            IF EXISTS (
                SELECT 1 
                FROM Tbl_Class_InCharge 
                WHERE Class_InCharge_Status = 0 
                  AND Employee_Id = @Employee_Id
            )
            BEGIN
                -- Get the Duration_Mapping_Id for the employee
                SET @Duration_Mapping_Id = (
                    SELECT Duration_Mapping_Id 
                    FROM Tbl_Class_InCharge 
                    WHERE Class_InCharge_Status = 0 
                      AND Employee_Id = @Employee_Id
                );

                -- Fetch students who are not in review groups
                SELECT 
                    cpd.Candidate_Id, 
                    cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName   
                FROM Tbl_Student_Registration sr                                   
                LEFT JOIN Tbl_Candidate_Personal_Det cpd 
                    ON cpd.Candidate_Id = sr.Candidate_Id                                  
                LEFT JOIN Tbl_Course_Category cc 
                    ON cc.Course_Category_Id = sr.Course_Category_Id                                             
                LEFT JOIN Tbl_Student_Semester 
                    ON Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                            
                LEFT JOIN Tbl_Course_Duration_Mapping 
                    ON Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                                 
                INNER JOIN Tbl_Course_Duration_PeriodDetails CP 
                    ON Tbl_Course_Duration_Mapping.Duration_Period_Id = CP.Duration_Period_Id                                 
                INNER JOIN Tbl_Course_Batch_Duration CBD 
                    ON CBD.Batch_Id = CP.Batch_Id                                
                INNER JOIN Tbl_Course_Semester SE 
                    ON CP.Semester_Id = SE.Semester_Id          
                WHERE Tbl_Student_Semester.Student_Semester_Current_Status = 1 
                  AND cpd.Candidate_DelStatus = 0             
                  AND Tbl_Student_Semester.Duration_Mapping_Id = @Duration_Mapping_Id        
                  AND cpd.Candidate_Id NOT IN (
                      SELECT RM.ReviewGrp_Member 
                      FROM LMS_Tbl_ReviewGrpMembers RM 
                      INNER JOIN LMS_Tbl_ReviewGrp R 
                          ON RM.ReviewGrp_Id = R.ReviewGrp_Id 
                      WHERE R.Status = 0
                  );
            END   
            ELSE  
            BEGIN  
                -- Return an empty result set if the employee is not a class in-charge
                SELECT 
                    Candidate_Id, 
                    Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname AS CandidateName 
                FROM Tbl_Candidate_Personal_Det 
                WHERE Candidate_Id = 0;
            END;
        END
    ')
END;
