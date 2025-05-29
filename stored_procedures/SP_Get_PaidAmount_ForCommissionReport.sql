IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_ParentMenu]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Get_ParentMenu]   
@menu_Id  int 
AS  
BEGIN  
Declare @ParentId bigint  
set @ParentId=(Select menu_ParentId from tbl_Menu Where menu_Id=@menu_Id)  
If(@ParentId>0)  
begin  
set @menu_Id=(Select menu_Id from tbl_Menu Where menu_Id=@ParentId)  
end  
Select   
menu_Id,  
menu_Name,  
menu_dtTime,  
menu_ParentId,  
menu_ToPage,  
menu_ImageName,  
menu_color,  
menu_description,  
menu_SImage,  
menu_DisplayOrder  ,
menu_tooltip
From tbl_Menu Where menu_Id=@menu_Id  
END




    ')
END
GO
