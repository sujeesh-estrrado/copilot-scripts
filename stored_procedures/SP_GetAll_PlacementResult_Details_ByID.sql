IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_PlacementResult_Details_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_PlacementResult_Details_ByID]
        @Placement_Details_Id BIGINT        
      
        AS      
        BEGIN       
            SELECT DISTINCT 
                PR.Placement_Result_Id,             -- Explicit columns from PR
                PR.Placement_Id,
                PR.Student_Id,
                PR.Result_Status,
                PR.Remarks,
                PR.Created_Date AS PR_Created_Date,
                PR.Modified_Date AS PR_Modified_Date,
                PD.Placement_Details_Id,            -- Explicit columns from PD
                PD.Company_Id,
                PD.Placement_Date,
                PD.Placement_Location,
                PD.Job_Description,
                PD.Salary,
                PD.Placement_Status,
                PD.Placement_Coordinator,
                PD.Delete_Status,
                PD.Created_Date AS PD_Created_Date,
                PD.Modified_Date AS PD_Modified_Date,
                CR.Company_Name,
                ISNULL(CD.Candidate_Fname, '''') + '' '' + 
                ISNULL(CD.Candidate_Mname, '''') + '' '' + 
                ISNULL(CD.Candidate_Lname, '''') AS [Name],
                cc.Course_Category_Name + ''-'' + d.Department_Name AS CourseDepartment
            FROM 
                dbo.Tbl_Placement_Result PR
                LEFT JOIN Tbl_Candidate_Personal_Det CD 
                    ON PR.Student_Id = CD.Candidate_Id
                LEFT JOIN Tbl_Student_Registration sr 
                    ON sr.Candidate_Id = PR.Student_Id    
                LEFT JOIN Tbl_Department d 
                    ON d.Department_Id = sr.Department_Id          
                LEFT JOIN Tbl_Course_Category cc 
                    ON cc.Course_Category_Id = sr.Course_Category_Id
                INNER JOIN dbo.Tbl_Placement_Details PD 
                    ON PD.Placement_Details_Id = PR.Placement_Id
                INNER JOIN dbo.Tbl_Company_Registration CR 
                    ON CR.Company_Id = PD.Company_Id 
                INNER JOIN dbo.Tbl_Placement_Attendees PA 
                    ON PA.Placement_Id = PD.Placement_Details_Id  
            WHERE 
                PR.Placement_Id = @Placement_Details_Id    
        END
    ')
END
