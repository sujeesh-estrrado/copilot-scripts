IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_All_Organizations]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_Get_All_Organizations]  
 
(
@flag bigint=0
)
as
begin 
if(@flag=0)--Active campus
begin 
select * from  dbo.Tbl_Organzations where  Organization_DelStatus=0
end
if(@flag=1)--All campus
begin 
select * from  dbo.Tbl_Organzations  
end
end
    ')
END
GO