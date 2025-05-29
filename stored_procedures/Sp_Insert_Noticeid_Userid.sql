IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Noticeid_Userid]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_Insert_Noticeid_Userid]
    (@Noticeid BIGINT, @Userid BIGINT)
AS
BEGIN
    -- Check if the mapping exists
    MERGE INTO Noticeid_By_User AS target
    USING (SELECT @Noticeid AS Noticeid, @Userid AS Userid) AS source
    ON (target.Notice_Ic = source.Noticeid AND target.User_Id = source.Userid)
    WHEN MATCHED THEN
        -- Update the existing record if it exists
        UPDATE SET target.Notice_Ic = source.Noticeid, target.User_Id = source.Userid
    WHEN NOT MATCHED THEN
        -- Insert a new record if it doesn''t exist
        INSERT (Notice_Ic, User_Id)
        VALUES (source.Noticeid, source.Userid);
END
    ')
END;
