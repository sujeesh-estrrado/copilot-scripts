IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_BatchIdFromDuration_Mapping_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_BatchIdFromDuration_Mapping_Id]
        (@Duration_Mapping_Id BIGINT = 0)
        AS
        BEGIN
            SELECT 
                cd.Duration_Period_Id AS Duration_Mapping_Id,
                bd.Batch_From,
                bd.Batch_To,
                bd.Batch_Code,
                cd.Duration_Period_Id,
                bd.Batch_Id
            FROM dbo.Tbl_Course_Duration_PeriodDetails AS cd
            LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id
            LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS CDM ON CDM.Duration_Period_Id = cd.Duration_Period_Id
            WHERE cd.Duration_Period_Id = @Duration_Mapping_Id
        END
    ')
END
