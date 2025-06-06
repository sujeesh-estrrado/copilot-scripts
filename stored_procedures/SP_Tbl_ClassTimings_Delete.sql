IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_ClassTimings_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_ClassTimings_Delete]
            @Class_Timings_Id BIGINT
        AS
        BEGIN
            DELETE FROM Tbl_Customize_ClassTiming 
            WHERE Customize_ClassTimingId = @Class_Timings_Id;
            
            DELETE FROM Tbl_Customize_ClassTimingMapping 
            WHERE Customize_ClassTimingId = @Class_Timings_Id;
        END
    ')
END
