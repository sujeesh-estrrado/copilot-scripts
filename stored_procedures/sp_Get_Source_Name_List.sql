IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Source_Name_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GET_SOURCE_NAME_LIST] 
    -- Add the parameters for the stored procedure here
    
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

--    -- Insert statements for procedure here
--select LandingiURL_Id, LandingiURL_Name from Tbl_LandingiURL Order By LandingiURL_Name

select SourceID as LandingiURL_Id,SourceName as LandingiURL_Name from Tbl_SourceInfo  where SourceName!=''''
END

    ')
END
