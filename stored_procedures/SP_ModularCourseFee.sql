IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ModularCourseFee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_ModularCourseFee]
@flag int,
@ModularCourseID bigint = '''',
@modularCourseFee decimal(18,2) ='''',
@feeHeading varchar(500) ='''',
@isChecked bit = '''',
@delStatus bigint = ''''
AS
BEGIN

IF(@flag=1)
begin

--DELETE FROM Tbl_ModularCourseMapFee WHERE ModularCourseID= @ModularCourseID 

Insert into Tbl_ModularCourseMapFee (ModularCourseID,ModularCourseFee,FeeHeading,Ischecked,DeleteStatus)
VALUES (@ModularCourseID,@modularCourseFee,@feeHeading,
 CASE WHEN @feeHeading = ''CourseFee'' THEN 1 ELSE @isChecked END, @delStatus)
 SELECT SCOPE_IDENTITY();
end
IF(@flag=2)
begin

DELETE FROM Tbl_ModularCourseMapFee WHERE ModularCourseID= @ModularCourseID 
end
END
    ')
END;
