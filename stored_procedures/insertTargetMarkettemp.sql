IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[insertTargetMarkettemp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[insertTargetMarkettemp](@marketid int,@markettype varchar(50))  
as begin  
insert into  Target_market_temp values(@marketid,@markettype)  
select scope_identity()  
end
    ')
END
