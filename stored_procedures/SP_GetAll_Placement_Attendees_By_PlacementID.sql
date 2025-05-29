IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Placement_Attendees_By_PlacementID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Placement_Attendees_By_PlacementID]  
        @Placement_Id BIGINT  
        AS    
        BEGIN    
            SELECT   
                PD.Placement_Details_Id,
                ISNULL(CD.Candidate_Fname, '''') + '' '' + 
                ISNULL(CD.Candidate_Mname, '''') + '' '' + 
                ISNULL(CD.Candidate_Lname, '''') AS [Name],
                ISNULL(cc.Course_Category_Name, '''') + ''-'' + 
                ISNULL(d.Department_Name, '''') AS CourseDepartment,
                PA.Attendees_Id,       -- Include only relevant columns
                PA.Placement_Id,       
                PA.Student_Id,         
                PA.Attendance_Status, 
                PA.Attendance_Date     
            FROM 
                dbo.Tbl_Placement_Details PD    
                INNER JOIN dbo.Tbl_Placement_Attendees PA 
                    ON PA.Placement_Id = PD.Placement_Details_Id  
                LEFT JOIN Tbl_Candidate_Personal_Det CD 
                    ON PA.Student_Id = CD.Candidate_Id    
                LEFT JOIN Tbl_Student_Registration sr 
                    ON sr.Candidate_Id = PA.Student_Id    
                LEFT JOIN Tbl_Department d 
                    ON d.Department_Id = sr.Department_Id          
                LEFT JOIN Tbl_Course_Category cc 
                    ON cc.Course_Category_Id = sr.Course_Category_Id      
            WHERE 
                PA.Placement_Id = @Placement_Id      
        END
    ')
END
