IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Room_Subject_mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Room_Subject_mapping]
            @Class_time_table_id bigint,
            @weekcode varchar(50),
            @Start_Time datetime,
            @End_Time datetime,
            @Room_Id bigint,
            @To_Time datetime,
            @From_Time datetime,
            @Duration_Mapping_id bigint,
            @Campus_id bigint,
            @subject_id bigint
        AS
        BEGIN
            INSERT INTO dbo.Tbl_Room_Subject_Mapping (
                Class_TimeTable_Id,
                Semster_Subject_Id,
                Start_Time,
                End_Time,
                WeekDay_Code,
                Mapping_ToDate,
                Mapping_FromDate,
                Campus_Id,
                Room_Id,
                Duration_Mapping_Id,
                Room_Mapping_delete_Status
            )
            VALUES (
                @Class_time_table_id,
                @subject_id,
                @Start_Time,
                @End_Time,
                @weekcode,
                @To_Time,
                @From_Time,
                @Campus_id,
                @Room_Id,
                @Duration_Mapping_id,
                0
            )
        END
    ')
END
