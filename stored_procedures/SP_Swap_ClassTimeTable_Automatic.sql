IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Swap_ClassTimeTable_Automatic]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Swap_ClassTimeTable_Automatic]              
        (              
            @Semster_Subject_Id bigint,              
            @Duration_Mapping_Id bigint,              
            @WeekDay_Settings_Id bigint,              
            @Class_Timings_Id bigint,              
            @Employee_Id bigint,
            @Semster_Subject_Id1 bigint,             
            @Employee_Id1 bigint,
            @Class_TimeTable_Id bigint
        )              
        AS              
        BEGIN        
            DECLARE @Result INT      

            IF NOT EXISTS(
                SELECT * FROM Tbl_Class_TimeTable 
                WHERE Employee_Id = @Employee_Id1          
                AND WeekDay_Settings_Id = @WeekDay_Settings_Id 
                AND Class_Timings_Id = @Class_Timings_Id
            )          
            BEGIN 
                INSERT INTO Tbl_Class_TimeTable(
                    Semster_Subject_Id, Duration_Mapping_Id, WeekDay_Settings_Id, 
                    Class_Timings_Id, Employee_Id
                )              
                VALUES(@Semster_Subject_Id1, @Duration_Mapping_Id, @WeekDay_Settings_Id, 
                    @Class_Timings_Id, @Employee_Id1)          

                SELECT @@IDENTITY  

                UPDATE Tbl_Class_TimeTable 
                SET Semster_Subject_Id = @Semster_Subject_Id,
                    Employee_Id = @Employee_Id
                WHERE Class_TimeTable_Id = @Class_TimeTable_Id

                SELECT @Class_TimeTable_Id               
            END  
            ELSE          
                SELECT -2    -- Class allotted for Employee       
        END
    ')
END
