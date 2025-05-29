IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Employee_Stroe_Mappping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Employee_Stroe_Mappping]
(
@Employee_Id bigint,
@Store_Id bigint
)

as

begin

insert into dbo.Tbl_Employee_Store_Mapping values(@Employee_Id,@Store_Id,0)

end');
END;
