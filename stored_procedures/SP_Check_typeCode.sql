IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_typeCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Check_typeCode]--''MAHSA Academy''
(@coursetype varchar(max)
 )
as
begin 
--if(@id>0)
--begin
select * from Tbl_Course_Category where Course_Category_Name=@coursetype and Course_Category_Status=0;
--end
--else
--begin
--select * from Tbl_Course_Category where Course_Category_Name=''Bachelors''  and Course_Category_Status=0
--end
end 
    ')
END
