IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Customize_ClassTiming_IsAlreadyExists_Validation]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Customize_ClassTiming_IsAlreadyExists_Validation]
        (
            @Department_Id BIGINT,
            @Batch_Id BIGINT
        )
        AS
        BEGIN
            SELECT CC.Customize_ClassTimingId 
            FROM Tbl_Customize_ClassTimingMapping CCTM
            INNER JOIN Tbl_Customize_ClassTiming CC ON CCTM.Customize_ClassTimingId = CC.Customize_ClassTimingId
            INNER JOIN Tbl_Course_Duration_PeriodDetails CCP ON CCTM.Batch_Id = CCP.Duration_Period_Id
            WHERE 
                CCP.Duration_Period_Id = @Batch_Id
            AND Department_Id = @Department_Id
        END
    ')
END
