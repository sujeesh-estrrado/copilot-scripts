IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_FollowupStatusMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Delete_FollowupStatusMaster]
    @Followup_ID INT,
	@flag int
AS
BEGIN
    -- Declare variables to store the Followup_Name corresponding to the Followup_ID
    DECLARE @Followup_Name NVARCHAR(255);

    -- Get the Followup_Name corresponding to the given Followup_ID
    SELECT @Followup_Name = Followup_Name
    FROM Tbl_FollowupStatus_Master
    WHERE Followp_Id = @Followup_ID;

    -- If Followup_Name is found for the given Followup_ID, check for Respond_Type in other tables
    IF @Followup_Name IS NOT NULL
    BEGIN
        -- Check in Tbl_FollowUp_Detail and Tbl_FollowUpLead_Detail if any Respond_Type matches the Followup_Name
        IF EXISTS ( 
            SELECT 1
            FROM Tbl_FollowUp_Detail
            WHERE Respond_Type = @Followup_Name 
        )
        BEGIN
            -- If Respond_Type is found in Tbl_FollowUp_Detail, return -1
            SELECT -1 AS Result;
            RETURN;
        END
        ELSE IF EXISTS ( 
            SELECT 1
            FROM Tbl_FollowUpLead_Detail
            WHERE Respond_Type = @Followup_Name 
        )
        BEGIN
            -- If Respond_Type is found in Tbl_FollowUpLead_Detail, return -1
            SELECT -1 AS Result;
            RETURN;
        END
        ELSE
        BEGIN
            -- If no match found, proceed to update Followup_DelStatus in Tbl_FollowupStatus_Master
            UPDATE Tbl_FollowupStatus_Master
            SET Followup_DelStatus = 1
            WHERE Followp_Id = @Followup_ID;

            -- Return 1 to indicate successful update
            SELECT 1 AS Result;
        END
    END
    ELSE
    BEGIN
        -- If Followup_Name is not found for the given Followup_ID, return -1
        SELECT -1 AS Result;
    END
END;
');
END;
