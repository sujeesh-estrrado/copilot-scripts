IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_MOVE_DELETE_STATUS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_MOVE_DELETE_STATUS]
@leadstatusID INT='''',
@InterestlevelId INT = '''',
 @flag BIGINT = 0

AS
BEGIN

IF(@flag=0)
BEGIN

select count(*) as leadstatuscount from Tbl_Lead_Personal_Det where LeadStatus_Id = @leadstatusID and Candidate_DelStatus = 0;

End

IF (@flag = 1)
    BEGIN
         UPDATE Tbl_Interest_level_Master
        SET Interest_level_DelStatus = 1
        WHERE InterestLevel_ID = @InterestlevelId;
		
    END
END;
'
)
END;
