IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DDL_LEAD_STATUS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_DDL_LEAD_STATUS] 
    @Pipelineid INT = NULL,
    @flag INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    -- Case when @flag = 1
    IF (@flag = 1)
    BEGIN
        SELECT LSM.Lead_Status_Name, LSM.Lead_Status_Id 
        FROM Tbl_Lead_Status_Master LSM
        WHERE LSM.Lead_Status_DelStatus = 0
        AND (
            NOT EXISTS (
                SELECT 1 
                FROM tbl_Lead_Status_Maping LSMAP 
                WHERE LSMAP.Lead_Satus_Id = LSM.Lead_Status_Id
            )
            OR EXISTS (
                SELECT 1 
                FROM tbl_Lead_Status_Maping LSMAP 
                WHERE LSMAP.Lead_Satus_Id = LSM.Lead_Status_Id
                AND LSMAP.Lead_Status_Del = 1
                AND LSMAP.mp = (
                    SELECT MAX(mp) 
                    FROM tbl_Lead_Status_Maping 
                    WHERE Lead_Satus_Id = LSM.Lead_Status_Id
                )
            )
        );
    END

    -- Case when @flag = 2
    ELSE IF (@flag = 2)
    BEGIN
        SELECT LSM.Lead_Status_Name, LSM.Lead_Status_Id 
        FROM Tbl_Lead_Status_Master LSM
        WHERE LSM.Lead_Status_DelStatus = 0
        AND (
            NOT EXISTS (
                SELECT 1 
                FROM tbl_Lead_Status_Maping LSMAP 
                WHERE LSMAP.Lead_Satus_Id = LSM.Lead_Status_Id
            )
            OR EXISTS (
                SELECT 1 
                FROM tbl_Lead_Status_Maping LSMAP 
                WHERE LSMAP.Lead_Satus_Id = LSM.Lead_Status_Id
                AND LSMAP.Lead_Status_Del = 1
                AND LSMAP.mp = (
                    SELECT MAX(mp) 
                    FROM tbl_Lead_Status_Maping 
                    WHERE Lead_Satus_Id = LSM.Lead_Status_Id
                )
            )
            OR EXISTS (
                SELECT 2 
                FROM tbl_Lead_Status_Maping LSMAP 
                WHERE LSMAP.Lead_Satus_Id = LSM.Lead_Status_Id
                AND LSMAP.Pipeline_Id = @Pipelineid
            )
        );
        end
        ELSE IF (@flag=3)
        begin
        SELECT Pipeline_Name,Pipeline_Id 
FROM Tbl_Pipeline_Settings 
WHERE Delete_Status = 0 
  AND Pipeline_Id <> @pipelineid;
END
end
'
)
END;
