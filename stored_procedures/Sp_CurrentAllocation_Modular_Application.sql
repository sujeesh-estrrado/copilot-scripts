IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CurrentAllocation_Modular_Application]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_CurrentAllocation_Modular_Application]
(
    @SlotId bigint,
    @CourseId bigint
)
AS
BEGIN
    SELECT COUNT(*) AS CurrentAllocation 
    FROM Tbl_Modular_Candidate_Details 
    WHERE Modular_Course_Id = @CourseId AND Modular_Slot_Id = @SlotId and Delete_Status=0
END
    ')
END;
