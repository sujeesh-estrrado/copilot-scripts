IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_City_By_State]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Proc_Get_City_By_State]   --2 
(
@State_Id bigint
)
as    
begin    
    
select distinct * from Tbl_City where State_Id=@State_Id 
  
end  
    ')
END
