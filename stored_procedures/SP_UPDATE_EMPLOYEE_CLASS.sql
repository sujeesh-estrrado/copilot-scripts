IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_UPDATE_EMPLOYEE_CLASS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_UPDATE_EMPLOYEE_CLASS]
        (
            @WeekDay_Settings_Id BIGINT,              
            @Class_Timings_Id BIGINT,              
            @Employee_Id BIGINT,
            @Class_TimeTable_Id BIGINT             
        )              
        AS              
        BEGIN   
            IF NOT EXISTS (
                SELECT 1 FROM Tbl_Class_TimeTable 
                WHERE Employee_Id = @Employee_Id          
                AND WeekDay_Settings_Id = @WeekDay_Settings_Id 
                AND Class_Timings_Id = @Class_Timings_Id
            ) 
            BEGIN
                UPDATE Tbl_Class_TimeTable
                SET WeekDay_Settings_Id = @WeekDay_Settings_Id,
                    Class_Timings_Id = @Class_Timings_Id
                WHERE Class_TimeTable_Id = @Class_TimeTable_Id;
                
                SELECT 1;
            END
            ELSE
            BEGIN
                SELECT -2;
            END
        END
    ')
END
