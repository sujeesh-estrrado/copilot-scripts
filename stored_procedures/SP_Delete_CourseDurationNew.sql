IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_CourseDurationNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_CourseDurationNew]
(@Duration_Id bigint)
AS
BEGIN 

if not exists (select * from Tbl_Department where Department_Id=(select Program_Category_Id from Tbl_Program_Duration where Duration_Id=@Duration_Id ))
begin 
update Tbl_Program_Duration set Delete_Status=1,Program_Duration_DelStatus=1 WHERE Duration_Id=@Duration_Id 
END 
end

    ')
END
