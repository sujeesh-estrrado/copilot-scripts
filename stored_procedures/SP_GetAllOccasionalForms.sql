IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllOccasionalForms]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetAllOccasionalForms]
    @OCassionalform_Status BIGINT = NULL,
    @createddatefrom NVARCHAR(50) = NULL,
    @createddateto NVARCHAR(50) = NULL,
    @OccasionalForm_FormTypeId INT = NULL, -- Added parameter for Form Type
    @OccasionalForm_Availablity_type bigint = NULL -- Added parameter for Availability Type
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        OccasionalForm_FormId,
        OccasionalForm_FormTitle,
        OCassionalform_CreatedDate,
        OccasionalForm_DeleteStatus,
        OccasionalForm_updatedDate,
        OccasionalForm_FormTypeId,
        CASE OccasionalForm_FormTypeId
            WHEN 1 THEN ''Normal''
            WHEN 2 THEN ''Feedback''
            WHEN 3 THEN ''Survey''
            ELSE ''Unknown''
        END AS FormTypeName,
        OccasionalForm_StatusId,
        OccasionalForm_Availablity_type,
        CASE OccasionalForm_Availablity_type
            WHEN 1 THEN ''Recurring''
            WHEN 2 THEN ''One time''
            ELSE ''Unknown''
        END AS AvailabilityTypeName,
        OccasionalForm_RecurringtypeOptns,
        OccasionalForm_Recuringday,
        OccasionalForm_Recurringmonth,
        OccasionalForm_Recurringenddate
    FROM OccasionalForms OC
    WHERE OccasionalForm_DeleteStatus = 0
    AND (
        @OCassionalform_Status IS NULL OR OC.OccasionalForm_StatusId = @OCassionalform_Status
    )
    AND (
        (@createddatefrom IS NULL OR @createddatefrom = '''' OR CONVERT(DATE, OCassionalform_CreatedDate) >= CONVERT(DATE, @createddatefrom))
        AND (@createddateto IS NULL OR @createddateto = '''' OR CONVERT(DATE, OCassionalform_CreatedDate) <= CONVERT(DATE, @createddateto))
    )
    AND (
        @OccasionalForm_FormTypeId IS NULL OR @OccasionalForm_FormTypeId = 0 OR OC.OccasionalForm_FormTypeId = @OccasionalForm_FormTypeId
    )
    AND (
        @OccasionalForm_Availablity_type IS NULL OR @OccasionalForm_Availablity_type = 0 OR OC.OccasionalForm_Availablity_type = @OccasionalForm_Availablity_type
    )
    ORDER BY OccasionalForm_FormId DESC; -- Order by creation date in descending order

END;
   ')
END;
