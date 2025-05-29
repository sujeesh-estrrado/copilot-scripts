IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CodeBy_CountryId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CodeBy_CountryId]   
(
@Country_Id bigint=0,
@Flag bigint=0
) 
as    
begin    
 if(@Flag=0)
 begin   
select Phonecode from Tbl_Country where Country_Id=@Country_Id  
  end
  if(@Flag=1)
  begin
  select distinct Phonecode ,Phonecode AS code from  Tbl_Country
  end
end
    ');
END;
