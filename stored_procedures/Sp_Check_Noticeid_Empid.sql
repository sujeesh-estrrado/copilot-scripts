IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Check_Noticeid_Empid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_Check_Noticeid_Empid]
    @Noticeid BIGINT,
    @Userid BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM Noticeid_By_Emp 
        WHERE Notice_Ic = @Noticeid AND User_Id = @Userid
    )
        SELECT 1 AS Flag;  -- Exists
    ELSE
        SELECT 0 AS Flag;  -- Does not exist
END;

');
END;
