IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[deletetargetmarkettemp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[deletetargetmarkettemp]
 as begin
delete from Target_market_temp
select scope_identity()
end



    ')
END
