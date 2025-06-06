-- Check if the stored procedure [dbo].[Proc_GetAll_StaffMaxHrs_By_DurationMappingId] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_StaffMaxHrs_By_DurationMappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_StaffMaxHrs_By_DurationMappingId]
        (
            @Duration_Mapping_Id BIGINT
        )
        AS
        BEGIN
            SELECT      
                DISTINCT SS.Semester_Subject_Id,    
                SS.Duration_Mapping_Id,    
                S.Subject_Name,    
                ISNULL(SH.Subject_MaxHours, '''') AS Subject_MaxHours,     
                ISNULL(SH.Is_Continuous, 0) AS Is_Continuous,  
                ISNULL(SH.Allowed_ContinuousHours, '''') AS Allowed_ContinuousHours    
            FROM 
                Tbl_Semester_Subjects SS    
            LEFT JOIN 
                Tbl_Subject_Hours_PerWeek SH ON SH.Semester_Subject_Id = SS.Semester_Subject_Id    
            INNER JOIN  
                Tbl_Department_Subjects DS ON DS.Department_Subject_Id = SS.Department_Subjects_Id    
            INNER JOIN  
                Tbl_Subject S ON S.Subject_Id = DS.Subject_Id    
            WHERE 
                SS.Semester_Subjects_Status = 0 
                AND SS.Duration_Mapping_Id = @Duration_Mapping_Id 
                AND (SELECT COUNT(Subject_Id) FROM Tbl_Subject WHERE Parent_Subject_Id = S.Subject_Id) = 0    
        END
    ')
END
