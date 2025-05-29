IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_MaxSlots_Modular_Application]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_MaxSlots_Modular_Application]
(
    @SlotId bigint
)
AS
BEGIN
    SELECT MaxAllocation FROM Tbl_Schedule_Planning WHERE Id = @SlotId and Isdeleted=0
END
    ')
END;
