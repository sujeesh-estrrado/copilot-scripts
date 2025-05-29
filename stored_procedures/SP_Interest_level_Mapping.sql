IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Interest_level_Mapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Interest_level_Mapping]   
@leadstatusId bigint = 0,
@InterestlevelId bigint,
@createduser bigint,
@flag INT 
AS
BEGIN
if @flag = 1
begin

insert into Tbl_Interest_level_Mapping(InterestLevel_ID,Lead_Status_Id,CreatedDate,CreatedBy)
values(@InterestlevelId,@leadstatusId,GETDATE(),@createduser)

end
 IF @flag = 2 
BEGIN
    
    DELETE FROM Tbl_Interest_level_Mapping
    WHERE InterestLevel_ID = @InterestlevelId ;

	


	end
end;


');
END;
